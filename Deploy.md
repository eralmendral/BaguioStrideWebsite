# Deploy To A DigitalOcean Droplet

This guide deploys the static Astro website to a DigitalOcean Ubuntu droplet and serves it at:

```text
http://<IP_ADDRESS_OF_DROPLET>/BaguioStride/Website
```

The site is static, so production should serve the generated `dist/` files with Nginx. Do not run `astro dev` in production.

## Important Subpath Note

Because the site will not be served from `/`, the app must be built for the subpath `/BaguioStride/Website`.

Generated Astro assets can be handled with `base` in `astro.config.mjs`, but any hardcoded public asset paths such as `/images/...`, `/downloads/...`, `/fonts/...`, or `/favicon.svg` also need to be subpath-aware.

Recommended project config:

```js
// astro.config.mjs
import react from '@astrojs/react';
import tailwind from '@astrojs/tailwind';
import { defineConfig } from 'astro/config';

export default defineConfig({
  output: 'static',
  site: 'http://<IP_ADDRESS_OF_DROPLET>',
  base: '/BaguioStride/Website',
  integrations: [
    react(),
    tailwind({
      applyBaseStyles: false,
    }),
  ],
});
```

For hardcoded public assets, use `import.meta.env.BASE_URL` in Astro components. Example:

```astro
---
const base = import.meta.env.BASE_URL;
---

<img src={`${base}images/1.PNG`} alt="BaguioStride app screen" />
<a href={`${base}downloads/baguiostride-arm64-v8a-release.apk`}>Download</a>
```

For CSS font files, use the same base path directly:

```css
@font-face {
  font-family: "Lexend";
  src: url("/BaguioStride/Website/fonts/Lexend-Regular.ttf") format("truetype");
}
```

If you skip these subpath changes, the page may load at `/BaguioStride/Website`, but CSS, JavaScript, images, fonts, or downloads may request root-level URLs like `/_astro/...` or `/images/...` and return `404`.

## Server Assumptions

This guide assumes:

- Ubuntu 22.04 or 24.04 on DigitalOcean
- SSH access to the droplet
- Public route uses the droplet IP, not a domain
- Repo is cloned to `/opt/BaguioStride/Website/repo`
- Built files are published to `/var/www/html/BaguioStride/Website`
- Nginx serves the public URL path `/BaguioStride/Website`

Replace placeholders:

```text
<IP_ADDRESS_OF_DROPLET>
<YOUR_REPOSITORY_URL>
```

## Step 1: SSH Into The Droplet

```bash
ssh root@<IP_ADDRESS_OF_DROPLET>
```

Update packages:

```bash
apt update
apt upgrade -y
```

## Step 2: Install Nginx, Git, And Node.js

Install base packages:

```bash
apt install -y nginx curl git
```

Install Node.js 22:

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs
```

Confirm versions:

```bash
node --version
npm --version
nginx -v
```

## Step 3: Create Deployment Directories

```bash
mkdir -p /opt/BaguioStride/Website
mkdir -p /var/www/html/BaguioStride/Website
```

## Step 4: Clone The Repository

```bash
cd /opt/BaguioStride/Website
git clone <YOUR_REPOSITORY_URL> repo
cd repo
```

If the repository is private, configure SSH deploy keys or GitHub access before cloning.

## Step 5: Configure Astro For The Subpath

In the repo on the droplet, confirm `astro.config.mjs` includes:

```js
base: '/BaguioStride/Website',
site: 'http://<IP_ADDRESS_OF_DROPLET>',
```

Example edit command:

```bash
nano astro.config.mjs
```

Also confirm public assets in components and CSS are subpath-aware as described in the Important Subpath Note.

## Step 6: Install Dependencies And Build

```bash
cd /opt/BaguioStride/Website/repo
npm ci
npm run build
```

Astro should generate:

```text
/opt/BaguioStride/Website/repo/dist
```

## Step 7: Publish The Build

Copy the built files into the Nginx serving directory:

```bash
rm -rf /var/www/html/BaguioStride/Website/*
cp -r /opt/BaguioStride/Website/repo/dist/* /var/www/html/BaguioStride/Website/
chown -R www-data:www-data /var/www/html/BaguioStride/Website
```

## Step 8: Configure Nginx

Create the Nginx config:

```bash
nano /etc/nginx/sites-available/baguiostride
```

Use this config:

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/html;
    index index.html;

    location = / {
        return 302 /BaguioStride/Website/;
    }

    location = /BaguioStride/Website {
        return 301 /BaguioStride/Website/;
    }

    location /BaguioStride/Website/ {
        index index.html;
        try_files $uri $uri/ /BaguioStride/Website/index.html;
    }

    location ~* ^/BaguioStride/Website/.*\.(js|css|png|jpg|jpeg|gif|svg|ico|webp|woff|woff2|ttf|apk)$ {
        expires 30d;
        access_log off;
        add_header Cache-Control "public, max-age=2592000, immutable";
        try_files $uri =404;
    }
}
```

Enable the site:

```bash
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/baguiostride /etc/nginx/sites-enabled/baguiostride
nginx -t
systemctl reload nginx
```

## Step 9: Open Firewall Port 80

If UFW is enabled:

```bash
ufw allow OpenSSH
ufw allow 'Nginx HTTP'
ufw status
```

If UFW is inactive and you want to enable it:

```bash
ufw allow OpenSSH
ufw allow 'Nginx HTTP'
ufw enable
```

## Step 10: Test In The Browser

Open:

```text
http://<IP_ADDRESS_OF_DROPLET>/BaguioStride/Website
```

Test from the droplet:

```bash
curl -I http://127.0.0.1/BaguioStride/Website/
```

Expected result:

```text
HTTP/1.1 200 OK
```

Also test the built asset paths:

```bash
curl -I http://127.0.0.1/BaguioStride/Website/favicon.svg
curl -I http://127.0.0.1/BaguioStride/Website/images/1.PNG
curl -I http://127.0.0.1/BaguioStride/Website/downloads/baguiostride-arm64-v8a-release.apk
```

Each should return `200 OK`.

## Deploy Updates

After pushing new changes to the repository:

```bash
cd /opt/BaguioStride/Website/repo
git pull origin main
npm ci
npm run build
rm -rf /var/www/html/BaguioStride/Website/*
cp -r dist/* /var/www/html/BaguioStride/Website/
chown -R www-data:www-data /var/www/html/BaguioStride/Website
nginx -t
systemctl reload nginx
```

## Optional Deploy Script

Create:

```bash
nano /opt/BaguioStride/Website/deploy.sh
```

Paste:

```bash
#!/usr/bin/env bash
set -euo pipefail

APP_ROOT="/opt/BaguioStride/Website"
REPO_DIR="$APP_ROOT/repo"
PUBLIC_DIR="/var/www/html/BaguioStride/Website"

cd "$REPO_DIR"
git pull origin main
npm ci
npm run build

rm -rf "$PUBLIC_DIR"/*
cp -r "$REPO_DIR/dist"/* "$PUBLIC_DIR"/
chown -R www-data:www-data "$PUBLIC_DIR"

nginx -t
systemctl reload nginx
```

Make it executable:

```bash
chmod +x /opt/BaguioStride/Website/deploy.sh
```

Run:

```bash
/opt/BaguioStride/Website/deploy.sh
```

## Troubleshooting

### Page loads but styling is missing

The site was likely built without the Astro `base` path or the Nginx root path is wrong.

Check the generated HTML:

```bash
grep -o 'href="[^"]*"' /var/www/html/BaguioStride/Website/index.html | head
```

Asset URLs should start with:

```text
/BaguioStride/Website/
```

### Images or downloads return 404

Hardcoded paths like `/images/1.PNG` or `/downloads/file.apk` are still root-based. Update component paths to use `import.meta.env.BASE_URL`, rebuild, and redeploy.

### Nginx config test fails

Run:

```bash
nginx -t
```

Read the line number in the error and fix `/etc/nginx/sites-available/baguiostride`.

### Permission errors during `npm ci`

Do not use `sudo npm ci`. Fix ownership instead:

```bash
chown -R root:root /opt/BaguioStride/Website
```

If deploying as a non-root user, replace `root:root` with that user:

```bash
chown -R deploy:deploy /opt/BaguioStride/Website/repo
```

## Production Checklist

- Droplet is reachable over SSH
- Nginx is installed
- Node.js 22 is installed
- Repo is cloned at `/opt/BaguioStride/Website/repo`
- `astro.config.mjs` uses `base: '/BaguioStride/Website'`
- Hardcoded public assets are subpath-aware
- `npm ci` succeeds
- `npm run build` succeeds
- Built files exist in `/var/www/html/BaguioStride/Website`
- Nginx config passes `nginx -t`
- Browser opens `http://<IP_ADDRESS_OF_DROPLET>/BaguioStride/Website`
- CSS, JavaScript, images, fonts, and APK download return `200 OK`

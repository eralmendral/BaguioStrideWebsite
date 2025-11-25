# Vercel Deployment Guide

This guide explains how to deploy BaguioStride website to Vercel with HugeIcons Pro authentication.

## Prerequisites

- Vercel account
- HugeIcons Pro Universal License Key

## Step 1: Add Environment Variable in Vercel

1. Go to your Vercel project dashboard
2. Navigate to **Settings** → **Environment Variables**
3. Add a new environment variable:
   - **Name**: `HUGEICONS_LICENSE_KEY`
   - **Value**: Your HugeIcons Pro Universal License Key (from hugeicons.com)
   - **Environment**: Select all (Production, Preview, Development)

## Step 2: Deploy to Vercel

### Option A: Deploy via Vercel Dashboard

1. Push your code to GitHub/GitLab/Bitbucket
2. Import the repository in Vercel
3. Vercel will automatically detect Astro and use the build settings
4. The `prebuild` script will automatically create `.npmrc` from the environment variable

### Option B: Deploy via Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy
vercel

# For production
vercel --prod
```

## How It Works

1. **During Build**: The `prebuild` script runs before `npm run build`
2. **Script**: `scripts/setup-npmrc.js` reads `HUGEICONS_LICENSE_KEY` from environment variables
3. **Creates**: `.npmrc` file in the project root with the license key
4. **Installs**: npm can now authenticate with HugeIcons Pro registry
5. **Builds**: Astro builds the site normally

## Troubleshooting

### Build fails with authentication error

- Verify `HUGEICONS_LICENSE_KEY` is set in Vercel environment variables
- Check that the license key is correct (no extra spaces)
- Ensure the environment variable is available for all environments

### Icons not showing

- Check browser console for errors
- Verify the HugeIcons Pro packages are installed correctly
- Check that icon names match the package exports

## Security Notes

- ✅ `.npmrc` is in `.gitignore` - never commit it
- ✅ License key is stored as environment variable in Vercel
- ✅ `.npmrc` is generated only during build, not committed to git
- ✅ The script validates that the environment variable exists

## Local Development

For local development, you still need a `.npmrc` file with your license key:

```bash
# Create .npmrc manually (not committed to git)
echo "@hugeicons-pro:registry=https://npm.hugeicons.com/
//npm.hugeicons.com/:_authToken=YOUR_LICENSE_KEY" > .npmrc
```

Or the `prebuild` script will work locally if you set the environment variable:

```bash
export HUGEICONS_LICENSE_KEY="your-license-key"
npm run build
```


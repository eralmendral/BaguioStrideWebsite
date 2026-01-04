# Development Setup Guide

This guide will help you set up the BaguioStride Website project for local development.

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your system:

- **Node.js** (version 18 or higher)
  - Check your version: `node --version`
  - Download from [nodejs.org](https://nodejs.org/) if needed
- **npm** (comes with Node.js)
  - Check your version: `npm --version`
- **Git** (for cloning the repository)
  - Check your version: `git --version`
- **HugeIcons Pro License Key** (required for icon dependencies)
  - Contact the project maintainer to obtain a license key

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd BaguioStride-Website
```

### 2. Set Up HugeIcons Pro Authentication

The project uses HugeIcons Pro icons, which requires authentication. You have two options:

#### Option A: Using Environment Variable (Recommended for CI/CD)

If you have the `HUGEICONS_LICENSE_KEY` environment variable set:

```bash
node scripts/setup-npmrc.js
```

#### Option B: Manual Setup

Create a `.npmrc` file in the project root with the following content:

```ini
# HugeIcons Pro Authentication
# This file is auto-generated during build
# Do not commit this file - it contains your license key

@hugeicons-pro:registry=https://npm.hugeicons.com/
//npm.hugeicons.com/:_authToken=YOUR_LICENSE_KEY_HERE
```

Replace `YOUR_LICENSE_KEY_HERE` with your actual HugeIcons Pro license key.

> **Note:** The `.npmrc` file is in `.gitignore` and should not be committed to version control.

### 3. Install Dependencies

```bash
npm install
```

This will install all project dependencies including:
- Astro framework
- React and React DOM
- TailwindCSS and DaisyUI
- TypeScript
- BiomeJS (linter/formatter)
- HugeIcons Pro packages

### 4. Start Development Server

```bash
npm run dev
```

The development server will start and you can access the website at:
- **Local:** http://localhost:4321
- **Network:** The terminal will display the network URL

The server supports hot module replacement (HMR), so changes will automatically reload in your browser.

## 🛠 Available Scripts

### Development

- `npm run dev` or `npm start` - Start the development server with hot reload
- `npm run build` - Build the project for production
- `npm run preview` - Preview the production build locally

### Code Quality

- `npm run lint` - Check for linting errors
- `npm run lint:fix` - Automatically fix linting errors
- `npm run format` - Format code according to project style
- `npm run format:check` - Check if code is properly formatted
- `npm run check` - Run both linting and formatting checks
- `npm run check:fix` - Automatically fix both linting and formatting issues

### Before Committing

Always run the following before committing your changes:

```bash
npm run check:fix
```

This ensures your code follows the project's style guidelines and passes all checks.

## 📁 Project Structure

```
BaguioStride-Website/
├── src/
│   ├── components/          # React and Astro components
│   │   ├── home/            # Homepage-specific components
│   │   ├── layout/          # Layout components (Header, Footer)
│   │   └── ui/              # Reusable UI components
│   ├── layouts/             # Page layouts
│   ├── pages/               # Route pages (Astro file-based routing)
│   ├── styles/              # Global styles and CSS
│   └── data/                # JSON data files
├── public/                  # Static assets (images, fonts, etc.)
├── scripts/                 # Utility scripts
├── dist/                    # Build output (generated, not committed)
├── astro.config.mjs         # Astro configuration
├── tailwind.config.cjs      # TailwindCSS configuration
├── tsconfig.json            # TypeScript configuration
├── biome.json               # BiomeJS linter/formatter configuration
└── package.json             # Project dependencies and scripts
```

## 🔧 Development Workflow

### Making Changes

1. **Create a new branch** for your feature or fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** to the codebase

3. **Test your changes**:
   - Run the dev server: `npm run dev`
   - Check the browser for visual changes
   - Verify the build works: `npm run build`

4. **Run code quality checks**:
   ```bash
   npm run check:fix
   ```

5. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

### Working with Components

- **Astro Components** (`.astro` files): Use for static content and server-side rendering
- **React Components** (`.tsx` files): Use for interactive client-side components
- Components are located in `src/components/` organized by feature/type

### Styling

- The project uses **TailwindCSS** for utility-first styling
- **DaisyUI** provides additional component classes
- Global styles are in `src/styles/global.css`
- Custom fonts (Lexend) are self-hosted in `public/fonts/`

### TypeScript

- The project uses TypeScript for type safety
- Type definitions are automatically inferred
- React components use TypeScript with `.tsx` extension

## 🐛 Troubleshooting

### Issue: `npm install` fails with authentication error

**Solution:** Ensure your `.npmrc` file is properly configured with a valid HugeIcons Pro license key. Contact the project maintainer if you don't have a license key.

### Issue: Port 4321 is already in use

**Solution:** Astro will automatically try the next available port. Alternatively, you can specify a different port:
```bash
npm run dev -- --port 3000
```

### Issue: Changes not reflecting in browser

**Solution:**
- Hard refresh your browser (Ctrl+Shift+R or Cmd+Shift+R)
- Clear browser cache
- Restart the dev server
- Check the terminal for any error messages

### Issue: Build fails

**Solution:**
- Ensure all dependencies are installed: `npm install`
- Clear the build cache: Delete `dist/` and `.astro/` directories
- Run `npm run build` again
- Check for TypeScript errors: `npm run check`

### Issue: Linting/formatting errors

**Solution:**
- Run `npm run check:fix` to automatically fix most issues
- Review BiomeJS documentation for specific rule configurations
- Check `biome.json` for project-specific linting rules

## 📚 Additional Resources

- [Astro Documentation](https://docs.astro.build/)
- [React Documentation](https://react.dev/)
- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [DaisyUI Documentation](https://daisyui.com/)
- [BiomeJS Documentation](https://biomejs.dev/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

## 🤝 Getting Help

If you encounter issues not covered in this guide:

1. Check the [CONTRIBUTING.md](./CONTRIBUTING.md) file
2. Review the [README.md](./README.md) for project overview
3. Open an issue on the repository
4. Contact the project maintainers

## ✅ Verification Checklist

Before you start developing, verify your setup:

- [ ] Node.js 18+ is installed
- [ ] Dependencies are installed (`npm install` completed successfully)
- [ ] `.npmrc` file is configured with HugeIcons Pro license
- [ ] Development server starts without errors (`npm run dev`)
- [ ] Website loads in browser at http://localhost:4321
- [ ] Code quality checks pass (`npm run check`)
- [ ] Build completes successfully (`npm run build`)

Once all items are checked, you're ready to start developing! 🎉


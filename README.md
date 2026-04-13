# BaguioStride Website

Marketing website for **BaguioStride**, an AI-assisted jeepney route guide for Baguio City.

Live site: https://baguio-stride-website.vercel.app/

## Overview

The site is a static Astro build with a responsive homepage, self-hosted Lexend fonts, app screenshots, and direct Android APK download support. The iOS call to action is currently marked as coming soon because no iOS build artifact is present in `public/downloads`.

## Tech Stack

- Astro 5
- TypeScript
- React islands
- Tailwind CSS 3
- DaisyUI
- HugeIcons
- Biome for linting and formatting
- npm for package management

## Project Structure

```text
src/
  components/
    home/      Homepage sections
    layout/    Header and footer
    ui/        Shared UI components
  layouts/     Page shells
  pages/       Astro routes
  styles/      Global styles
public/
  downloads/   APK and release files
  fonts/       Self-hosted Lexend fonts
  images/      App screenshots and badges
```

## Development

Install dependencies:

```bash
npm install
```

Run the local dev server:

```bash
npm run dev
```

Build for production:

```bash
npm run build
```

Preview the production build:

```bash
npm run preview
```

## Quality Commands

```bash
npm run check
npm run lint
npm run format:check
```

Use `npm run check:fix` or `npm run format` for automatic fixes.

## Release Notes

- Android downloads use `public/downloads/baguiostride-arm64-v8a-release.apk`.
- The homepage uses the screenshots in `public/images`.
- Deployment details are kept in `Deploy.md` when present.

# BaguioStride Marketing Website

A modern, conversion-focused homepage for BaguioStride, a mobile app that provides AI-powered jeepney route guidance for Baguio City, Philippines.

## Tech Stack

- **Framework**: Astro 4.x
- **Styling**: TailwindCSS v3.x + DaisyUI
- **Components**: Astro components with React islands for interactive elements
- **Fonts**: Lexend (self-hosted)
- **Icons**: HugeIcons Pro
- **Animations**: CSS animations and Intersection Observer for scroll animations

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm, yarn, or pnpm
- HugeIcons Pro license (see [HUGEICONS_SETUP.md](./HUGEICONS_SETUP.md))

### Installation

1. **Set up HugeIcons Pro** (required):
   - See [HUGEICONS_SETUP.md](./HUGEICONS_SETUP.md) for detailed instructions
   - Add your Universal License Key to `.npmrc`

2. **Install dependencies**:
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## Project Structure

```
website/
├── src/
│   ├── components/
│   │   ├── layout/       # Header, Footer, MobileMenu
│   │   ├── home/         # Homepage sections
│   │   └── ui/           # Reusable UI components
│   ├── layouts/          # Page layouts
│   ├── pages/            # Route pages
│   ├── styles/           # Global styles
│   └── data/             # JSON data files
├── public/               # Static assets
└── astro.config.mjs      # Astro configuration
```

## Features

- ✅ Responsive design (mobile-first)
- ✅ Modern UI with TailwindCSS and DaisyUI
- ✅ Smooth scroll animations
- ✅ Mobile-friendly navigation
- ✅ SEO optimized
- ✅ Fast performance with Astro

## Development

The site is built with Astro, which provides excellent performance by shipping minimal JavaScript. Interactive components use React islands for client-side interactivity.

### Code Quality

This project uses [BiomeJS](https://biomejs.dev/) for linting and formatting.

**Available scripts:**
- `npm run lint` - Check for linting errors
- `npm run lint:fix` - Fix linting errors automatically
- `npm run format` - Format code
- `npm run format:check` - Check code formatting
- `npm run check` - Run both linting and formatting checks
- `npm run check:fix` - Fix both linting and formatting issues

**Before committing:**
```bash
npm run check:fix
```

## License

MIT


# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Essential Commands
```bash
# Start development server
npm run dev
# or
npm start

# Build for production  
npm run build

# Preview production build
npm run preview
```

### Prerequisites Setup
Before running development commands, you MUST configure HugeIcons Pro:

1. Add your Universal License Key to `.npmrc`:
```
@hugeicons-pro:registry=https://npm.hugeicons.com/
//npm.hugeicons.com/:_authToken=YOUR_ACTUAL_LICENSE_KEY_HERE
```
2. Then run `npm install`

See `HUGEICONS_SETUP.md` for complete setup instructions.

## Architecture Overview

This is an **Astro 4.x** marketing website with **React islands** for interactive components.

### Tech Stack
- **Framework**: Astro 4.x (static site generation with islands architecture)
- **Styling**: TailwindCSS + DaisyUI 
- **Interactive Components**: React (TypeScript)
- **Icons**: HugeIcons Pro (requires license key)
- **Fonts**: Self-hosted Lexend font family
- **Animations**: CSS-based with Intersection Observer

### Project Structure
```
src/
├── components/
│   ├── layout/          # Header, Footer (Astro components)
│   ├── home/           # Homepage sections (Astro components)  
│   └── ui/             # Reusable components (mixed Astro/React)
├── layouts/Layout.astro # Base HTML layout
├── pages/index.astro   # Homepage route
├── styles/global.css   # Font declarations + Tailwind
└── data/*.json        # Content data (features, testimonials)
```

### Component Architecture

**Astro Components (.astro)**:
- Static components for layout and content sections
- Include inline `<script>` tags for vanilla JS interactivity
- Examples: `Header.astro`, `Hero.astro`, `Features.astro`

**React Islands (.tsx)**:
- Interactive components that need React state/effects
- Must use `client:load` directive when imported into Astro
- Examples: `HugeIcon.tsx`, `StarRating.tsx`

### Icon System
Icons use HugeIcons Pro with a centralized mapping system:

- **General icons**: `src/components/ui/HugeIcon.tsx`
- **Feature icons**: `src/components/ui/FeatureIcon.tsx` 
- **Adding new icons**: Update the `iconMap` object and import from `@hugeicons-pro/core-stroke-rounded`

### Styling System
- **Colors**: Custom color palette in `tailwind.config.cjs` with Baguio-themed colors
- **Typography**: Lexend font family (self-hosted, defined in `global.css`)
- **Components**: DaisyUI provides base component styles
- **Animations**: Custom CSS animations (`animate-float`, `animate-fade-in-up`)

### Mobile-First Approach
- Responsive design with mobile-first breakpoints
- Mobile menu implemented with vanilla JS (no React state needed)
- Header transforms on scroll using Intersection Observer

## Content Management

### Static Data
Content is managed through JSON files in `src/data/`:
- `features.json` - Feature cards with icons, titles, descriptions
- `testimonials.json` - User reviews and ratings

### Adding Content
To add new features or testimonials, edit the respective JSON files. The components automatically iterate over the data.

## Development Notes

### Interactive Components
When adding React components:
1. Create `.tsx` files in `src/components/ui/`
2. Use `client:load` directive when importing into Astro components
3. Keep React usage minimal - prefer Astro + vanilla JS for simple interactions

### Performance Considerations
- Astro ships zero JavaScript by default
- Only components with `client:` directives add JavaScript to the bundle
- Self-hosted fonts are preloaded with `font-display: swap`

### Mobile Menu Implementation
The mobile menu uses vanilla JavaScript with CSS transforms rather than React state for better performance. It includes:
- Slide-in animation with backdrop
- Auto-close on link clicks
- Header background change on scroll
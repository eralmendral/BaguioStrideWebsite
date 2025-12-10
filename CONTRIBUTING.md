# Contributing to BaguioStride Website

Thank you for your interest in contributing to the BaguioStride Website! This document provides instructions for setting up your development environment.

## Getting Started

### Prerequisites

- Node.js 18+
- npm, yarn, or pnpm
- HugeIcons Pro license

### Installation

1. **Set up HugeIcons Pro** (required):
   - You need a valid license key for HugeIcons Pro.
   - Add your Universal License Key to `.npmrc`.

2. **Install dependencies**:
   ```bash
   npm install
   ```

## Development

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build

### Code Quality

This project uses [BiomeJS](https://biomejs.dev/) for linting and formatting.

- `npm run lint` - Check for linting errors
- `npm run lint:fix` - Fix linting errors automatically
- `npm run format` - Format code
- `npm run format:check` - Check code formatting
- `npm run check` - Run both linting and formatting checks
- `npm run check:fix` - Fix both linting and formatting issues

**Before committing, please run:**
```bash
npm run check:fix
```


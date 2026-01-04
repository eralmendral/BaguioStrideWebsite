# Contributing to BaguioStride Website

Thank you for your interest in contributing to the BaguioStride Website! 

## Getting Started

For detailed setup instructions, please see [SETUP.md](./setup.md) which includes:
- Complete prerequisites
- Step-by-step installation guide
- Development workflow
- Troubleshooting tips

### Quick Setup

1. **Prerequisites**: Node.js 18+, npm, and HugeIcons Pro license
2. **Set up HugeIcons Pro** (required):
   - You need a valid license key for HugeIcons Pro.
   - Add your Universal License Key to `.npmrc` (see [SETUP.md](./setup.md) for details).

3. **Install dependencies**:
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


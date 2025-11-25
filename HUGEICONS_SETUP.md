# HugeIcons Pro Setup Guide

This project uses HugeIcons Pro for all icons. Follow these steps to set up HugeIcons Pro:

## 1. Get Your Universal License Key

1. Visit [hugeicons.com](https://hugeicons.com/) and log in to your account
2. Navigate to the **Tokens** tab in your account dashboard
3. Copy your **Universal License Key**

## 2. Configure Authentication

1. Open the `.npmrc` file in the project root
2. Replace `UNIVERSAL_LICENSE_KEY` with your actual license key:

```plaintext
@hugeicons-pro:registry=https://npm.hugeicons.com/
//npm.hugeicons.com/:_authToken=YOUR_ACTUAL_LICENSE_KEY_HERE
```

## 3. Install Dependencies

After configuring the `.npmrc` file, install the dependencies:

```bash
npm install
```

This will install:
- `@hugeicons/react` - React component library for HugeIcons
- `@hugeicons-pro/core-stroke-rounded` - Icon style package (you can change this to other styles if needed)

## 4. Available Icon Styles

HugeIcons Pro offers multiple icon styles. You can replace `core-stroke-rounded` with:
- `core-stroke-rounded` (currently used)
- `core-stroke-square`
- `core-filled-rounded`
- `core-filled-square`
- And many more...

To use a different style, update `package.json` and the import in `src/components/ui/HugeIcon.tsx` and `src/components/ui/FeatureIcon.tsx`.

## 5. Using Icons in Components

### In Astro Components

```astro
---
import HugeIcon from '../ui/HugeIcon';
---

<HugeIcon client:load name="menu" className="w-6 h-6" size={24} />
```

### In React Components

```tsx
import HugeIcon from './HugeIcon';

<HugeIcon name="star" className="text-yellow-500" size={20} />
```

## 6. Adding New Icons

To add new icons, update the `iconMap` in:
- `src/components/ui/HugeIcon.tsx` - For general icons
- `src/components/ui/FeatureIcon.tsx` - For feature-specific icons

Find the icon name in the HugeIcons Pro library and add it to the map:

```tsx
const iconMap: Record<string, any> = {
  'your-icon-name': Icons.YourIconNameIcon,
  // ... other icons
};
```

## Troubleshooting

### Installation Fails

- Verify your license key is correct in `.npmrc`
- Make sure you have an active HugeIcons Pro subscription
- Check that the registry URL is correct

### Icons Not Showing

- Ensure the icon name exists in the icon style package you're using
- Check the browser console for warnings about missing icons
- Verify the icon is imported correctly in the iconMap

## License

HugeIcons Pro icons are licensed for use in this project. Do not redistribute the icon files or use them in competing products.


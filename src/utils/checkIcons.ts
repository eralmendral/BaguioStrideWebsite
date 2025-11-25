// Debug utility to check available HugeIcons
// Run this in the browser console or import in a component to see available icons

import * as Icons from '@hugeicons-pro/core-stroke-rounded';

export function listAvailableIcons() {
  const iconNames = Object.keys(Icons);
  console.log('Available HugeIcons Pro icons:', iconNames);
  console.log('Total icons:', iconNames.length);

  // Check for specific icons we're using
  const iconsWeNeed = [
    'Users01Icon',
    'Star01Icon',
    'Globe01Icon',
    'ArrowDown01Icon',
    'Menu01Icon',
    'Close01Icon',
    'CheckmarkCircle01Icon',
    'Chat01Icon',
    'Microphone01Icon',
    'Location01Icon',
    'RouteIcon',
    'Magic01Icon',
    'Calculator01Icon',
    'Translate01Icon',
    'Clock01Icon',
  ];

  console.log('\nChecking icons we need:');
  for (const iconName of iconsWeNeed) {
    const exists = iconNames.includes(iconName);
    console.log(`${iconName}: ${exists ? '✓' : '✗'}`);
    if (!exists) {
      // Try to find similar names
      const similar = iconNames.filter((name) =>
        name.toLowerCase().includes(iconName.toLowerCase().replace('Icon', '').slice(0, 5))
      );
      if (similar.length > 0) {
        console.log(`  Similar: ${similar.join(', ')}`);
      }
    }
  }

  return iconNames;
}

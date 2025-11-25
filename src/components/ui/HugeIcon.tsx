import * as Icons from '@hugeicons-pro/core-stroke-rounded';
import { HugeiconsIcon } from '@hugeicons/react';
import React from 'react';

interface HugeIconProps {
  name: string;
  className?: string;
  size?: number;
  strokeWidth?: number;
}

// Define the props that HugeIcons Pro icons accept
interface IconProps {
  className?: string;
  size?: number;
  strokeWidth?: number;
}

// Map icon names to HugeIcons Pro icons
// Note: Icon names must match the exact export names from @hugeicons-pro/core-stroke-rounded
const iconMap: Record<string, React.ComponentType<IconProps>> = {
  // Navigation & UI
  users: Icons.Users01Icon,
  star: Icons.Star01Icon,
  globe: Icons.Globe01Icon,
  'arrow-down': Icons.ArrowDown01Icon,
  menu: Icons.Menu01Icon,
  close: Icons.Close01Icon,
  check: Icons.CheckmarkCircle01Icon,
  // Features
  'message-circle': Icons.Chat01Icon,
  mic: Icons.Microphone01Icon,
  'map-pin': Icons.Location01Icon,
  route: Icons.RouteIcon,
  sparkles: Icons.Magic01Icon,
  calculator: Icons.Calculator01Icon,
  // Problem statement
  'route-confused': Icons.RouteIcon,
  language: Icons.Translate01Icon,
  clock: Icons.Clock01Icon,
};

export default function HugeIcon({
  name,
  className = '',
  size = 24,
  strokeWidth = 1.5,
}: HugeIconProps) {
  const IconComponent = iconMap[name];

  if (!IconComponent) {
    console.warn(`Icon "${name}" not found in iconMap. Available icons:`, Object.keys(iconMap));
    return null;
  }

  // Ensure IconComponent is valid before passing to HugeiconsIcon
  if (typeof IconComponent === 'undefined' || IconComponent === null) {
    console.warn(`Icon "${name}" is undefined or null`);
    return null;
  }

  // Check if IconComponent is a valid React component/function
  if (typeof IconComponent !== 'function' && typeof IconComponent !== 'object') {
    console.warn(`Icon "${name}" is not a valid component. Type:`, typeof IconComponent);
    return null;
  }

  try {
    return (
      <HugeiconsIcon
        icon={IconComponent}
        className={className}
        size={size}
        strokeWidth={strokeWidth}
      />
    );
  } catch (error) {
    console.error(`Error rendering icon "${name}":`, error);
    // Return a fallback placeholder
    return (
      <div className={className} style={{ width: size, height: size }}>
        <span className="text-xs">?</span>
      </div>
    );
  }
}

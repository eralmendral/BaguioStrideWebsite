import * as Icons from '@hugeicons/core-free-icons';
import { HugeiconsIcon } from '@hugeicons/react';
import type { IconSvgElement } from '@hugeicons/react';

interface HugeIconProps {
  name: string;
  className?: string;
  size?: number;
  strokeWidth?: number;
}

// Map icon names to HugeIcons Free icons
const iconMap: Record<string, IconSvgElement> = {
  // Navigation & UI
  users: Icons.UserGroupIcon,
  star: Icons.StarIcon,
  globe: Icons.Globe02Icon,
  'arrow-down': Icons.ArrowDown01Icon,
  menu: Icons.Menu01Icon,
  close: Icons.Cancel01Icon,
  check: Icons.CheckmarkCircle01Icon,
  // Platform icons
  ios: Icons.AppleIcon,
  android: Icons.AndroidIcon,
  // Features
  'message-circle': Icons.Chat01Icon,
  mic: Icons.Mic01Icon,
  'ai-voice': Icons.AiVoiceIcon,
  'map-pin': Icons.Location01Icon,
  route: Icons.RouteIcon,
  sparkles: Icons.SparklesIcon,
  'magic-wand': Icons.MagicWand01Icon,
  calculator: Icons.Calculator01Icon,
  // Problem statement
  'route-confused': Icons.RouteIcon,
  language: Icons.TranslateIcon,
  conversation: Icons.ConversationIcon,
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
    // console.warn(`Icon "${name}" not found in iconMap. Available icons:`, Object.keys(iconMap));
    return null;
  }

  // Ensure IconComponent is valid before passing to HugeiconsIcon
  if (typeof IconComponent === 'undefined' || IconComponent === null) {
    // console.warn(`Icon "${name}" is undefined or null`);
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

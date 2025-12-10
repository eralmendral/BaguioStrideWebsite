import * as Icons from '@hugeicons-pro/core-stroke-rounded';
import { HugeiconsIcon } from '@hugeicons/react';
import React from 'react';

interface FeatureIconProps {
  icon: string;
  className?: string;
}

// Define the props that HugeIcons Pro icons accept
interface IconProps {
  className?: string;
  size?: number;
  strokeWidth?: number;
}

// Map our icon names to HugeIcons Pro icon names
const iconMap: Record<string, React.ComponentType<IconProps>> = {
  'message-circle': Icons.Chat01Icon,
  mic: Icons.Microphone01Icon,
  'ai-voice': Icons.AiVoiceIcon,
  'map-pin': Icons.Location01Icon,
  route: Icons.RouteIcon,
  sparkles: Icons.Magic01Icon,
  'magic-wand': Icons.MagicWandIcon,
  calculator: Icons.Calculator01Icon,
};

export default function FeatureIcon({ icon, className = 'w-full h-full' }: FeatureIconProps) {
  const IconComponent = iconMap[icon];

  if (!IconComponent) {
    // console.warn(`Icon "${icon}" not found in iconMap`);
    return null;
  }

  // Ensure IconComponent is valid before passing to HugeiconsIcon
  if (typeof IconComponent === 'undefined' || IconComponent === null) {
    // console.warn(`Icon "${icon}" is undefined or null`);
    return null;
  }

  try {
    return <HugeiconsIcon icon={IconComponent} className={className} size={28} strokeWidth={1.5} />;
  } catch (error) {
    console.error(`Error rendering icon "${icon}":`, error);
    return null;
  }
}

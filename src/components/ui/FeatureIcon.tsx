import * as Icons from '@hugeicons/core-free-icons';
import { HugeiconsIcon } from '@hugeicons/react';
import type { IconSvgElement } from '@hugeicons/react';

interface FeatureIconProps {
  icon: string;
  className?: string;
}

// Map our icon names to HugeIcons Free icon names
const iconMap: Record<string, IconSvgElement> = {
  'message-circle': Icons.Chat01Icon,
  mic: Icons.Mic01Icon,
  'ai-voice': Icons.AiVoiceIcon,
  'map-pin': Icons.Location01Icon,
  route: Icons.RouteIcon,
  sparkles: Icons.SparklesIcon,
  'magic-wand': Icons.MagicWand01Icon,
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

import * as Icons from '@hugeicons-pro/core-stroke-rounded';
import { HugeiconsIcon } from '@hugeicons/react';

interface StarRatingProps {
  rating: number;
  className?: string;
  size?: number;
}

export default function StarRating({ rating, className = '', size = 20 }: StarRatingProps) {
  // Ensure the icon is available
  if (!Icons.Star01Icon) {
    console.warn('Star01Icon not found in Icons');
    return null;
  }

  try {
    return (
      <div className={`flex items-center gap-1 ${className}`}>
        {Array.from({ length: 5 }, (_, i) => i + 1).map((starIndex) => (
          <HugeiconsIcon
            key={`star-${starIndex}`}
            icon={Icons.Star01Icon}
            className={starIndex <= rating ? 'text-yellow-400' : 'text-gray-300'}
            size={size}
            strokeWidth={starIndex <= rating ? 2 : 1}
          />
        ))}
      </div>
    );
  } catch (error) {
    console.error('Error rendering star rating:', error);
    return null;
  }
}

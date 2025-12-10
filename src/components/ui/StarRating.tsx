import * as Icons from '@hugeicons/core-free-icons';
import { HugeiconsIcon } from '@hugeicons/react';

interface StarRatingProps {
  rating: number;
  className?: string;
  size?: number;
}

export default function StarRating({ rating, className = '', size = 20 }: StarRatingProps) {
  // Ensure the icon is available
  if (!Icons.StarIcon) {
    console.warn('StarIcon not found in Icons');
    return null;
  }

  try {
    return (
      <div className={`flex items-center gap-1 ${className}`}>
        {Array.from({ length: 5 }, (_, i) => i + 1).map((starIndex) => (
          <HugeiconsIcon
            key={`star-${starIndex}`}
            icon={Icons.StarIcon}
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

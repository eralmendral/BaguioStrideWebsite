/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#2E7D32',
          dark: '#1B5E20',
          light: '#4CAF50',
        },
        secondary: {
          DEFAULT: '#1976D2',
          dark: '#0D47A1',
          light: '#42A5F5',
        },
        accent: '#FFA726',
        baguio: {
          green: '#2E7D32',
          blue: '#1976D2',
          orange: '#FFA726',
        },
      },
      fontFamily: {
        sans: ['Lexend', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [require('daisyui')],
};

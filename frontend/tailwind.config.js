/** @type {import('tailwindcss').Config} */
/** @type {import('tailwindcss').Config} */
export default {
  darkMode: ['class'],
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        bg: {
          DEFAULT: '#0a0a0a',
          card: '#111111',
          muted: '#181818',
        },
        fg: {
          DEFAULT: '#ffffff',
          muted: '#a1a1aa',
          accent: '#22d3ee',
        },
        primary: '#3b82f6',
        ok: '#10b981',
        warn: '#f59e0b',
        err: '#ef4444'
      },
      borderRadius: {
        xl: '14px',
      },
    },
  },
  plugins: [],
};

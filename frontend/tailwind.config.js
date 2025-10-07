/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        bg: '#0b1220',
        panel: '#121a2b',
        text: '#e7ecf5',
        muted: '#9fb3c8',
        primary: '#3b82f6',
        ok: '#10b981',
        warn: '#f59e0b',
        err: '#ef4444'
      }
    },
  },
  plugins: [],
}


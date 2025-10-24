import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    strictPort: true,
    // Dev proxy to Django backend so /api, /admin and /ui work from the
    // Vite domain (avoids SPA 404s when navigating to /admin/ or /ui/)
    proxy: {
      '/api': {
        target: 'http://localhost:8001',
        changeOrigin: true,
      },
      '/admin': {
        target: 'http://localhost:8001',
        changeOrigin: true,
      },
      '/ui': {
        target: 'http://localhost:8001',
        changeOrigin: true,
      },
      '/static': {
        target: 'http://localhost:8001',
        changeOrigin: true,
      },
    },
  },
  build: {
    sourcemap: false,
  },
});

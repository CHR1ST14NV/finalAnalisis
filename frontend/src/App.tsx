import { useEffect } from 'react';
import { Route, Routes } from 'react-router-dom';
import NavBar from './components/NavBar';
import RequireAuth from './components/RequireAuth';
import Home from './pages/Home';
import Products from './pages/Products';
import Orders from './pages/Orders';
import Inventory from './pages/Inventory';
import KPI from './pages/KPI';
import Login from './pages/Login';
import Profile from './pages/Profile';
import Register from './pages/Register';
import RequireRole from './components/RequireRole';
import NotFound from './pages/NotFound';

export default function App() {
  // Atajos: g p (productos), g o (pedidos), g k (kpi)
  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.target && (e.target as HTMLElement).tagName === 'INPUT') return;
      if (e.key.toLowerCase() === 'g') {
        const handler = (ev: KeyboardEvent) => {
          const k = ev.key.toLowerCase();
          if (k === 'p') location.href = '/products';
          if (k === 'o') location.href = '/orders';
          if (k === 'k') location.href = '/kpi';
          window.removeEventListener('keydown', handler, { capture: true } as any);
        };
        window.addEventListener('keydown', handler, { capture: true } as any);
      }
    }
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, []);

  return (
    <div>
      <NavBar />
      <Routes>
        <Route path="/" element={<RequireAuth><Home /></RequireAuth>} />
        <Route path="/products" element={<RequireAuth><Products /></RequireAuth>} />
        <Route path="/orders" element={<RequireAuth><Orders /></RequireAuth>} />
        <Route path="/inventory" element={<RequireAuth><Inventory /></RequireAuth>} />
        <Route path="/kpi" element={<RequireAuth><KPI /></RequireAuth>} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<RequireAuth><RequireRole roles={["ADMIN"]}><Register /></RequireRole></RequireAuth>} />
        <Route path="/profile" element={<RequireAuth><Profile /></RequireAuth>} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </div>
  );
}

import { NavLink, useNavigate } from 'react-router-dom';
import { isAuthenticated, logout } from '../lib/api';

export default function NavBar() {
  const navigate = useNavigate();
  const authed = isAuthenticated();
  const backend = (import.meta as any).env?.VITE_BACKEND_BASE || '';

  function onLogout() {
    logout();
    navigate('/login');
  }

  return (
    <header className="site">
      <div className="container">
        <nav className="top flex items-center gap-6 py-3">
          <NavLink to="/" className="text-lg font-semibold">Canal</NavLink>
          <div className="flex items-center gap-4">
            <NavLink to="/" end className={({isActive}) => isActive ? 'active' : ''}>Inicio</NavLink>
            <NavLink to="/products" className={({isActive}) => isActive ? 'active' : ''}>Catálogo</NavLink>
            <NavLink to="/orders" className={({isActive}) => isActive ? 'active' : ''}>Pedidos</NavLink>
            <NavLink to="/inventory" className={({isActive}) => isActive ? 'active' : ''}>Inventario</NavLink>
            <NavLink to="/kpi" className={({isActive}) => isActive ? 'active' : ''}>KPI</NavLink>
          </div>
          <div className="ml-auto flex items-center gap-2">
            {!authed ? (
              <NavLink to="/login" className="btn btn-ghost">Login</NavLink>
            ) : (
              <>
                <a href={`${backend}/admin/`} className="btn btn-ghost" rel="noreferrer">Admin</a>
                <a href={`${backend}/ui/`} className="btn btn-ghost" rel="noreferrer">UI</a>
                <NavLink to="/profile" className={({ isActive }) => `btn btn-ghost${isActive ? ' active' : ''}`}>Perfil</NavLink>
                <button onClick={onLogout} className="btn btn-primary">Salir</button>
              </>
            )}
          </div>
        </nav>
      </div>
    </header>
  );
}

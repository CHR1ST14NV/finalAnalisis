import { NavLink, useNavigate } from 'react-router-dom';
import { isAuthenticated, logout } from '../lib/api';

export default function NavBar() {
  const navigate = useNavigate();
  const authed = isAuthenticated();
  function onLogout() {
    logout();
    navigate('/login');
  }
  return (
    <header className="site">
      <div className="container flex items-center justify-between py-3">
        <div className="flex items-center gap-3">
          <div className="h-2.5 w-2.5 rounded-full bg-ok" />
          <span className="font-semibold tracking-tight">Canal</span>
        </div>
        <nav className="top flex gap-5 text-sm items-center">
          <NavLink to="/" className={({ isActive }) => (isActive ? 'active' : '')} end>
            Inicio
          </NavLink>
          <NavLink to="/products" className={({ isActive }) => (isActive ? 'active' : '')}>
            Catálogo
          </NavLink>
          <NavLink to="/orders" className={({ isActive }) => (isActive ? 'active' : '')}>
            Pedidos
          </NavLink>
          <NavLink to="/inventory" className={({ isActive }) => (isActive ? 'active' : '')}>
            Inventario
          </NavLink>
          <NavLink to="/kpi" className={({ isActive }) => (isActive ? 'active' : '')}>
            KPI
          </NavLink>
          {!authed ? (
            <NavLink to="/login" className={({ isActive }) => (isActive ? 'active' : '')}>
              Login
            </NavLink>
          ) : (
            <>
              <NavLink to="/profile" className={({ isActive }) => (isActive ? 'active' : '')}>
                Perfil
              </NavLink>
              <button onClick={onLogout} className="text-neutral-300 hover:text-white">Salir</button>
            </>
          )}
        </nav>
      </div>
    </header>
  );
}

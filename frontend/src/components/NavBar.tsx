import { NavLink } from 'react-router-dom';

export default function NavBar() {
  return (
    <header className="site">
      <div className="container flex items-center justify-between py-3">
        <div className="flex items-center gap-3">
          <div className="h-2.5 w-2.5 rounded-full bg-ok" />
          <span className="font-semibold">Canal</span>
        </div>
        <nav className="top flex gap-5 text-sm">
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
          <NavLink to="/login" className={({ isActive }) => (isActive ? 'active' : '')}>
            Login
          </NavLink>
        </nav>
      </div>
    </header>
  );
}


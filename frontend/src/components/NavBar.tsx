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
    <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
      <div className="container">
        <NavLink to="/" className="navbar-brand">Canal</NavLink>
        <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsMain">
          <span className="navbar-toggler-icon"></span>
        </button>
        <div id="navbarsMain" className="collapse navbar-collapse">
          <ul className="navbar-nav me-auto mb-2 mb-lg-0">
            <li className="nav-item"><NavLink to="/" end className={({ isActive }) => 'nav-link' + (isActive ? ' active' : '')}>Inicio</NavLink></li>
            <li className="nav-item"><NavLink to="/products" className={({ isActive }) => 'nav-link' + (isActive ? ' active' : '')}>Catálogo</NavLink></li>
            <li className="nav-item"><NavLink to="/orders" className={({ isActive }) => 'nav-link' + (isActive ? ' active' : '')}>Pedidos</NavLink></li>
            <li className="nav-item"><NavLink to="/inventory" className={({ isActive }) => 'nav-link' + (isActive ? ' active' : '')}>Inventario</NavLink></li>
            <li className="nav-item"><NavLink to="/kpi" className={({ isActive }) => 'nav-link' + (isActive ? ' active' : '')}>KPI</NavLink></li>
          </ul>
          <ul className="navbar-nav ms-auto">
            {!authed ? (
              <li className="nav-item"><NavLink to="/login" className={({ isActive }) => 'nav-link' + (isActive ? ' active' : '')}>Login</NavLink></li>
            ) : (
              <>
                <li className="nav-item"><a href="/admin/" className="nav-link" target="_self" rel="noreferrer">Admin</a></li>
                <li className="nav-item"><a href="/ui/" className="nav-link" target="_self" rel="noreferrer">UI</a></li>
                <li className="nav-item"><NavLink to="/profile" className={({ isActive }) => 'nav-link' + (isActive ? ' active' : '')}>Perfil</NavLink></li>
                <li className="nav-item"><button onClick={onLogout} className="btn btn-outline-light btn-sm ms-2">Salir</button></li>
              </>
            )}
          </ul>
        </div>
      </div>
    </nav>
  );
}

import { useState } from 'react';
import { login } from '../lib/api';
import { Input, Button, Label } from '../components/Form';
import { useNavigate, Link } from 'react-router-dom';

export default function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      await login(username, password);
      navigate('/');
    } catch (err) {
      setError('Credenciales inválidas');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="container py-10 max-w-md">
      <div className="card">
        <h1 className="text-xl font-semibold mb-4">Iniciar sesión</h1>
        <form className="space-y-4" onSubmit={onSubmit}>
          <div>
            <Label>Usuario</Label>
            <Input value={username} onChange={(e) => setUsername(e.currentTarget.value)} required />
          </div>
          <div>
            <Label>Contraseña</Label>
            <Input type="password" value={password} onChange={(e) => setPassword(e.currentTarget.value)} required />
          </div>
          {error && <p className="text-rose-400 text-sm">{error}</p>}
          <div className="flex items-center gap-3">
            <Button type="submit" disabled={loading}>{loading ? 'Ingresando…' : 'Entrar'}</Button>
            <Link to="/register" className="text-sm text-neutral-300 hover:text-white">Crear cuenta</Link>
          </div>
        </form>
      </div>
    </div>
  );
}

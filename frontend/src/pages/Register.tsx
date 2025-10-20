import { useEffect, useState } from 'react';
import { Input, Button, Label } from '../components/Form';
import { fetchRoles, registerUser, Role } from '../lib/api';
import { useNavigate } from 'react-router-dom';

export default function Register() {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [roles, setRoles] = useState<Role[]>([]);
  const [role, setRole] = useState('RETAILER');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    fetchRoles().then((r) => {
      setRoles(r);
      if (r.length && !role) setRole(r[0].code);
    });
  }, []);

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError('');
    try {
      await registerUser({ username, email, password, role_code: role });
      navigate('/login');
    } catch (err: any) {
      setError(err?.message || 'No se pudo registrar');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="container py-10 max-w-md">
      <div className="card">
        <h1 className="text-xl font-semibold mb-4">Crear cuenta</h1>
        <form className="space-y-4" onSubmit={onSubmit}>
          <div>
            <Label>Usuario</Label>
            <Input value={username} onChange={(e) => setUsername(e.currentTarget.value)} required />
          </div>
          <div>
            <Label>Email</Label>
            <Input type="email" value={email} onChange={(e) => setEmail(e.currentTarget.value)} required />
          </div>
          <div>
            <Label>Contraseña</Label>
            <Input type="password" value={password} onChange={(e) => setPassword(e.currentTarget.value)} required />
          </div>
          <div>
            <Label>Rol</Label>
            <select value={role} onChange={(e) => setRole(e.currentTarget.value)} className="w-full rounded-lg bg-bg-muted border border-neutral-800 px-3 py-2">
              {roles.map((r) => (
                <option key={r.id} value={r.code}>{r.name} ({r.code})</option>
              ))}
            </select>
          </div>
          {error && <p className="text-rose-400 text-sm">{error}</p>}
          <Button type="submit" disabled={loading}>{loading ? 'Creando…' : 'Registrarme'}</Button>
        </form>
      </div>
    </div>
  );
}


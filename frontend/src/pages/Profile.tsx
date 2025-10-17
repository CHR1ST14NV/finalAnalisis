import { useEffect, useState } from 'react';
import { me, type User } from '../lib/api';

export default function Profile() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    let cancel = false;
    (async () => {
      setLoading(true);
      try {
        const u = await me();
        if (!cancel) setUser(u);
      } finally {
        if (!cancel) setLoading(false);
      }
    })();
    return () => { cancel = true; };
  }, []);

  return (
    <div className="container py-6 space-y-4">
      <h1 className="text-xl font-semibold">Perfil</h1>
      <div className="card">
        {loading && <div className="h-6 w-32 skeleton" />}
        {user && (
          <div className="space-y-1">
            <p><span className="muted">Usuario:</span> {user.username}</p>
            <p><span className="muted">Nombre:</span> {(user.first_name || '') + ' ' + (user.last_name || '')}</p>
            <p><span className="muted">Email:</span> {user.email || '—'}</p>
            <p><span className="muted">Roles:</span> {user.roles.map(r => r.name).join(', ') || '—'}</p>
          </div>
        )}
      </div>
    </div>
  );
}


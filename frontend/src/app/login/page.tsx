"use client";
import { useState } from 'react';
import toast, { Toaster } from 'react-hot-toast';

export default function LoginPage() {
  const [username, setUsername] = useState('admin');
  const [password, setPassword] = useState('admin123!');
  const [message, setMessage] = useState('');

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setMessage('');
    try {
      const res = await fetch('/api/v1/auth/token/', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ username, password }) });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || 'Error de login');
      localStorage.setItem('token', data.access);
      if (data.refresh) localStorage.setItem('refresh', data.refresh);
      setMessage('Login OK');
      toast.success('Sesión iniciada');
    } catch (err: any) {
      setMessage(err.message);
    }
  }

  return (
    <div className="max-w-md mx-auto">
      <Toaster />
      <h2 className="text-2xl font-semibold mb-4">Login</h2>
      <form onSubmit={submit} className="space-y-4">
        <div>
          <label className="block mb-1">Usuario</label>
          <input className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2" value={username} onChange={e => setUsername(e.target.value)} />
        </div>
        <div>
          <label className="block mb-1">Contraseña</label>
          <input className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2" type="password" value={password} onChange={e => setPassword(e.target.value)} />
        </div>
        <button type="submit" className="px-4 py-2 rounded-md bg-blue-600 hover:brightness-110">Ingresar</button>
      </form>
      {message && <p className="mt-3 text-muted">{message}</p>}
    </div>
  );
}

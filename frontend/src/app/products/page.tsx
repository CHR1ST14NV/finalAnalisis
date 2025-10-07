"use client";
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';

type Product = { id: string; name: string; description?: string };

export default function ProductsPage() {
  const [items, setItems] = useState<Product[]>([]);
  const [q, setQ] = useState('');
  const [loading,setLoading] = useState(false);
  const [error, setError] = useState('');

  const load = async () => {
    setLoading(true); setError('');
    try {
      const url = '/api/v1/catalog/products/' + (q? `?q=${encodeURIComponent(q)}` : '');
      const data = await api(url);
      setItems(data);
    } catch (e:any) { setError(e.message); }
    finally { setLoading(false); }
  }

  useEffect(() => { load(); }, []);

  return (
    <div>
      <div className="flex items-end gap-2 mb-4">
        <div className="flex-1">
          <label className="block mb-1">Buscar</label>
          <input className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2" value={q} onChange={(e)=>setQ(e.target.value)} placeholder="Nombre o descripción" />
        </div>
        <button className="px-4 py-2 rounded-md bg-blue-600 hover:brightness-110" onClick={load}>Buscar</button>
      </div>
      {error && <p className="text-red-400">{error}</p>}
      {loading && <p className="text-muted">Cargando…</p>}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {items.map((p) => (
          <div className="card" key={p.id}>
            <div className="text-lg font-semibold mb-1">{p.name}</div>
            <div className="text-muted">{p.description || '—'}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

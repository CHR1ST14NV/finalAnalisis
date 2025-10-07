"use client";
import { useEffect, useState } from 'react';
import { api } from '@/lib/api';

type Av = { sku_id:string; warehouse_id:string; available:number };

export default function InventoryPage(){
  const [sku,setSku] = useState('');
  const [rows,setRows] = useState<Av[]>([]);
  const [err,setErr] = useState('');
  const [loading,setLoading]=useState(false);
  async function query(){
    setLoading(true); setErr('');
    try { const data = await api(`/api/v1/inventory/availability/?sku=${encodeURIComponent(sku)}`); setRows(data); }
    catch(e:any){ setErr(e.message); }
    finally { setLoading(false); }
  }
  return (
    <div>
      <h2 className="text-2xl font-semibold mb-4">Disponibilidad por SKU</h2>
      <div className="flex items-end gap-2 mb-4">
        <div className="flex-1">
          <label className="block mb-1">SKU UUID</label>
          <input className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2" value={sku} onChange={e=>setSku(e.target.value)} placeholder="f27e6b62-a89c-4338-..."/>
        </div>
        <button onClick={query} className="px-4 py-2 rounded-md bg-blue-600 hover:brightness-110">Consultar</button>
      </div>
      {loading && <p className="text-muted">Cargando…</p>}
      {err && <p className="text-red-400">{err}</p>}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {rows.map((r,i)=> (
          <div key={i} className="card">
            <div className="font-semibold">Warehouse</div>
            <div className="text-muted text-sm">{r.warehouse_id}</div>
            <div className="mt-2">Disponible: <b>{r.available}</b></div>
          </div>
        ))}
      </div>
    </div>
  )
}


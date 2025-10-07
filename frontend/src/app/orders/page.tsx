"use client";
import { useState } from 'react';
import { api } from '@/lib/api';

export default function OrdersPage() {
  const [skuId, setSkuId] = useState('');
  const [qty, setQty] = useState(1);
  const [orderId,setOrderId] = useState('');
  const [message, setMessage] = useState('');

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setMessage('');
    try {
      const data = await api('/api/v1/orders/', { method:'POST', headers:{'Idempotency-Key':'ui-'+Date.now()}, body: { customer_ref:'UI', channel:'B2B', items:[{ sku_id: skuId, qty, unit_price: '10.00'}] }});
      setOrderId(data.id);
      setMessage('Pedido creado: ' + data.id);
    } catch (err:any){ setMessage(err.message); }
  }

  async function confirm(){
    setMessage('');
    try {
      const data = await api(`/api/v1/orders/${orderId}/confirm/`, { method:'POST' });
      setMessage('Confirmado, saga encolada');
    } catch (e:any){ setMessage(e.message); }
  }

  return (
    <div className="max-w-xl">
      <h2 className="text-2xl font-semibold mb-4">Crear Pedido</h2>
      <form onSubmit={submit} className="space-y-4">
        <div>
          <label className="block mb-1">SKU ID</label>
          <input className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2" value={skuId} onChange={e => setSkuId(e.target.value)} placeholder="UUID del SKU" />
        </div>
        <div>
          <label className="block mb-1">Cantidad</label>
          <input className="w-full rounded-md border border-slate-700 bg-slate-900 px-3 py-2" type="number" value={qty} onChange={e => setQty(parseInt(e.target.value || '1', 10))} min={1} />
        </div>
        <button type="submit" className="px-4 py-2 rounded-md bg-blue-600 hover:brightness-110">Crear</button>
      </form>
      {orderId && (
        <div className="mt-4 flex items-center gap-2">
          <div className="text-muted">ID: {orderId}</div>
          <button className="px-3 py-2 rounded-md bg-green-600 hover:brightness-110" onClick={confirm}>Confirmar</button>
        </div>
      )}
      {message && <p className="mt-3 text-muted">{message}</p>}
      <p className="mt-3 text-muted">TIP: Toma un SKU desde /api/v1/catalog/skus/ y pégalo aquí.</p>
    </div>
  );
}

import { useEffect, useMemo, useState } from 'react';
import { Table, Th, Td } from '../components/Table';
import { Button, Input, Label } from '../components/Form';
import { Modal } from '../components/Modal';
import { useToast } from '../components/Toast';
import { confirmOrder, fetchOrders, createOrder, fetchProducts, type Order, type Product } from '../lib/api';

const StatusChip = ({ status }: { status: string }) => {
  const m: Record<string, string> = {
    DRAFT: 'border-neutral-700 text-neutral-300',
    PLACED: 'border-primary/50 text-primary',
    CONFIRMED: 'border-ok/50 text-ok',
    ALLOCATED: 'border-ok/50 text-ok',
    SHIPPED: 'border-neutral-400 text-neutral-300',
    DELIVERED: 'border-ok/50 text-ok',
  };
  return <span className={`chip ${m[status] || ''}`}>{status}</span>;
};

type FormItem = { product: Product; qty: number; unit_price: string };

export default function Orders() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState('');
  const [confirmId, setConfirmId] = useState<string | null>(null);
  const [showCreate, setShowCreate] = useState(false);
  const toast = useToast();

  // create form state
  const [customer, setCustomer] = useState('CUST-' + Math.random().toString(36).slice(2, 6).toUpperCase());
  const [channel, setChannel] = useState<'B2B' | 'B2C'>('B2B');
  const [items, setItems] = useState<FormItem[]>([]);
  const [q, setQ] = useState('');
  const [searching, setSearching] = useState(false);
  const [results, setResults] = useState<Product[]>([]);
  const [submitting, setSubmitting] = useState(false);
  const [formError, setFormError] = useState('');

  async function load() {
    setLoading(true);
    setErr('');
    try {
      const d = await fetchOrders();
      setOrders(d);
    } catch (e) {
      setErr('Error cargando pedidos');
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
    const t = setInterval(load, 5000);
    return () => clearInterval(t);
  }, []);

  async function confirm(id: string) {
    try {
      await confirmOrder(id);
      toast({ title: 'Pedido confirmado', color: 'ok' });
      await load();
    } catch {
      toast({ title: 'No se pudo confirmar', color: 'err' });
    }
  }

  // search products for modal
  useEffect(() => {
    let cancel = false;
    async function run() {
      try {
        setSearching(true);
        const d = await fetchProducts({ q, page: 1 });
        if (!cancel) setResults(d.results);
      } finally {
        if (!cancel) setSearching(false);
      }
    }
    if (showCreate) run();
    return () => { cancel = true; };
  }, [q, showCreate]);

  function addProduct(p: Product) {
    if (!p.primary_sku_id) return;
    const price = p.price?.amount ?? '10.00';
    setItems((old) => [...old, { product: p, qty: 1, unit_price: price }]);
  }

  function removeIndex(i: number) {
    setItems((old) => old.filter((_, idx) => idx !== i));
  }

  async function submitCreate() {
    setSubmitting(true);
    setFormError('');
    try {
      const payload = {
        customer_ref: customer,
        channel,
        items: items
          .filter((it) => it.product.primary_sku_id)
          .map((it) => ({ sku_id: it.product.primary_sku_id as string, qty: it.qty, unit_price: it.unit_price })),
      };
      if (!payload.items.length) {
        setFormError('Agrega al menos un producto');
        setSubmitting(false);
        return;
      }
      await createOrder(payload);
      toast({ title: 'Pedido creado', color: 'ok' });
      setShowCreate(false);
      setItems([]);
      await load();
    } catch {
      setFormError('No se pudo crear el pedido');
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="container py-6 space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-semibold">Pedidos</h1>
        <div className="flex gap-2">
          <Button onClick={() => setShowCreate(true)}>Crear pedido</Button>
          <Button onClick={load} variant="ghost">Refrescar</Button>
        </div>
      </div>

      <div className="card">
        <Table>
          <thead>
            <tr>
              <Th>ID</Th>
              <Th>Cliente</Th>
              <Th>Estado</Th>
              <Th></Th>
            </tr>
          </thead>
          <tbody>
            {loading && (
              <tr><Td colSpan={4 as any}><div className="h-6 skeleton w-full" /></Td></tr>
            )}
            {!loading && orders.map((o) => (
              <tr key={o.id}>
                <Td className="font-mono text-xs">{o.id.slice(0, 8)}</Td>
                <Td>{o.customer_ref}</Td>
                <Td><StatusChip status={o.status} /></Td>
                <Td className="text-right">
                  <Button disabled={o.status !== 'PLACED'} onClick={() => setConfirmId(o.id)}>Confirmar</Button>
                </Td>
              </tr>
            ))}
          </tbody>
        </Table>
        {err && <p className="text-rose-400 text-sm mt-2">{err}</p>}
      </div>

      {/* Confirm modal */}
      <Modal
        open={!!confirmId}
        onOpenChange={(v) => { if (!v) setConfirmId(null); }}
        title="Confirmar pedido"
        footer={
          <>
            <Button variant="ghost" onClick={() => setConfirmId(null)}>Cancelar</Button>
            <Button onClick={() => { if (confirmId) { confirm(confirmId); setConfirmId(null); } }}>Confirmar</Button>
          </>
        }
      >
        <p className="muted">¿Deseas confirmar el pedido y disparar fulfillment?</p>
      </Modal>

      {/* Create modal */}
      <Modal
        open={showCreate}
        onOpenChange={(v) => setShowCreate(v)}
        title="Nuevo pedido"
        footer={
          <>
            <Button variant="ghost" onClick={() => setShowCreate(false)}>Cancelar</Button>
            <Button onClick={submitCreate} disabled={submitting}>{submitting ? 'Creando…' : 'Crear'}</Button>
          </>
        }
      >
        <div className="space-y-4">
          <div className="grid sm:grid-cols-3 gap-3">
            <div className="sm:col-span-2">
              <Label>Referencia de cliente</Label>
              <Input value={customer} onChange={(e) => setCustomer(e.currentTarget.value)} />
            </div>
            <div>
              <Label>Canal</Label>
              <select value={channel} onChange={(e) => setChannel(e.currentTarget.value as any)} className="w-full rounded-lg bg-bg-muted border border-neutral-800 px-3 py-2">
                <option value="B2B">B2B</option>
                <option value="B2C">B2C</option>
              </select>
            </div>
          </div>

          <div className="space-y-2">
            <Label>Agregar productos</Label>
            <Input placeholder="Buscar por nombre" value={q} onChange={(e) => setQ(e.currentTarget.value)} />
            {!searching && results.length > 0 && (
              <div className="max-h-40 overflow-auto rounded-lg border border-neutral-800">
                {results.map((p) => (
                  <button key={p.id} onClick={() => addProduct(p)} className="w-full text-left px-3 py-2 hover:bg-neutral-900">
                    <div className="font-medium">{p.name}</div>
                    <div className="text-xs text-neutral-400">SKU primario: {p.primary_sku_id ? p.primary_sku_id.slice(0,8) : '—'} · Precio: {p.price?.amount ?? '—'}</div>
                  </button>
                ))}
              </div>
            )}
          </div>

          <div className="card">
            <Table>
              <thead>
                <tr>
                  <Th>Producto</Th>
                  <Th>Cantidad</Th>
                  <Th>Precio</Th>
                  <Th></Th>
                </tr>
              </thead>
              <tbody>
                {items.length === 0 && (
                  <tr><Td colSpan={4 as any}><div className="text-sm text-neutral-400">Sin items</div></Td></tr>
                )}
                {items.map((it, idx) => (
                  <tr key={idx}>
                    <Td>{it.product.name}</Td>
                    <Td>
                      <Input type="number" min={1} value={it.qty}
                        onChange={(e) => setItems((old) => old.map((x, i) => i === idx ? { ...x, qty: Number(e.currentTarget.value) } : x))} />
                    </Td>
                    <Td>
                      <Input value={it.unit_price}
                        onChange={(e) => setItems((old) => old.map((x, i) => i === idx ? { ...x, unit_price: e.currentTarget.value } : x))} />
                    </Td>
                    <Td className="text-right">
                      <Button variant="ghost" onClick={() => removeIndex(idx)}>Quitar</Button>
                    </Td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>

          {formError && <p className="text-rose-400 text-sm">{formError}</p>}
        </div>
      </Modal>
    </div>
  );
}


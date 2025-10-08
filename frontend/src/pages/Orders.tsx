import { useEffect, useState } from 'react';
import { Table, Th, Td } from '../components/Table';
import { Button } from '../components/Form';
import { confirmOrder, fetchOrders, type Order } from '../lib/api';

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

export default function Orders() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState('');

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
    const t = setInterval(load, 5000); // polling simple
    return () => clearInterval(t);
  }, []);

  async function confirm(id: string) {
    await confirmOrder(id);
    await load();
  }

  return (
    <div className="container py-6 space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-semibold">Pedidos</h1>
        <Button onClick={load} variant="ghost">Refrescar</Button>
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
                  <Button disabled={o.status !== 'PLACED'} onClick={() => confirm(o.id)}>Confirmar</Button>
                </Td>
              </tr>
            ))}
          </tbody>
        </Table>
        {err && <p className="text-rose-400 text-sm mt-2">{err}</p>}
      </div>
    </div>
  );
}


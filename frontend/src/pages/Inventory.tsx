import { useEffect, useState } from 'react';
import { Table, Th, Td } from '../components/Table';
import { Input, Button } from '../components/Form';
import { api } from '../lib/api';

type Availability = {
  sku_id: string;
  sku_code: string;
  product_name: string;
  warehouse_id: string;
  warehouse_name: string;
  available: number;
};

export default function Inventory() {
  const [sku, setSku] = useState('');
  const [data, setData] = useState<Availability[]>([]);
  const [loading, setLoading] = useState(false);

  async function load() {
    if (!sku) return;
    setLoading(true);
    try {
      const d = await api<Availability[]>(`/inventory/availability/?sku=${sku}`);
      setData(d);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    if (sku) load();
  }, [sku]);

  return (
    <div className="container py-6 space-y-4">
      <div className="flex items-end gap-2">
        <div className="flex-1">
          <label className="block text-sm mb-1">Código de SKU</label>
          <Input placeholder="Código o ID del SKU" value={sku} onChange={(e) => setSku(e.currentTarget.value)} />
        </div>
        <Button onClick={load}>Consultar</Button>
      </div>
      <div className="card">
        {data && data.length > 0 && (
          <div className="mb-3 text-sm text-neutral-300">
            <span className="font-semibold">Producto:</span> {data[0]?.product_name ?? '—'}
            <span className="ml-3 muted">SKU:</span> <span className="font-mono">{data[0]?.sku_code ?? ''}</span>
          </div>
        )}
        <Table>
          <thead>
            <tr>
              <Th>Bodega</Th>
              <Th>Disponible</Th>
            </tr>
          </thead>
          <tbody>
            {loading && (
              <tr><Td colSpan={2 as any}><div className="h-6 skeleton w-full" /></Td></tr>
            )}
            {!loading && data.length === 0 && (
              <tr><Td colSpan={2 as any} className="text-center text-neutral-400">Sin resultados</Td></tr>
            )}
            {!loading && data.map((a) => (
              <tr key={a.warehouse_id}>
                <Td>{a.warehouse_name}</Td>
                <Td>{a.available}</Td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </div>
  );
}

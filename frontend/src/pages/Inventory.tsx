import { useEffect, useState } from 'react';
import { Table, Th, Td } from '../components/Table';
import { Input, Button } from '../components/Form';
import { api } from '../lib/api';

type Availability = { sku_id: string; warehouse_id: string; available: number };

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
          <label className="block text-sm mb-1">SKU ID</label>
          <Input placeholder="UUID del SKU" value={sku} onChange={(e) => setSku(e.currentTarget.value)} />
        </div>
        <Button onClick={load}>Consultar</Button>
      </div>
      <div className="card">
        <Table>
          <thead>
            <tr>
              <Th>Warehouse</Th>
              <Th>Disponible</Th>
            </tr>
          </thead>
          <tbody>
            {loading && (
              <tr><Td colSpan={2 as any}><div className="h-6 skeleton w-full" /></Td></tr>
            )}
            {!loading && data.map((a) => (
              <tr key={a.warehouse_id}>
                <Td className="font-mono text-xs">{a.warehouse_id.slice(0,8)}</Td>
                <Td>{a.available}</Td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </div>
  );
}


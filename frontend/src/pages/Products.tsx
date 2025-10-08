import { useEffect, useMemo, useState } from 'react';
import { Input, Button } from '../components/Form';
import { Table, Th, Td } from '../components/Table';
import { fetchProducts, type Product } from '../lib/api';

export default function Products() {
  const [q, setQ] = useState('');
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<{ results: Product[]; count: number }>({ results: [], count: 0 });

  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    fetchProducts({ page, q })
      .then((d) => !cancelled && setData(d))
      .finally(() => setLoading(false));
    return () => {
      cancelled = true;
    };
  }, [page, q]);

  const totalPages = useMemo(() => Math.max(1, Math.ceil(data.count / 20)), [data.count]);

  return (
    <div className="container py-6 space-y-4">
      <div className="flex items-center gap-2">
        <Input placeholder="Buscar…" value={q} onChange={(e) => setQ(e.currentTarget.value)} />
        <Button onClick={() => setPage(1)}>Filtrar</Button>
      </div>
      <div className="card">
        <Table>
          <thead>
            <tr>
              <Th>Producto</Th>
              <Th>Descripción</Th>
            </tr>
          </thead>
          <tbody>
            {loading && (
              <tr>
                <Td colSpan={3 as any}><div className="h-6 skeleton w-full" /></Td>
              </tr>
            )}
            {!loading && data.results.map((p) => (
              <tr key={p.id}>
                <Td>{p.name}</Td>
                <Td className="muted">{p.description || '—'}</Td>
              </tr>
            ))}
          </tbody>
        </Table>
        <div className="flex items-center justify-between mt-3 text-sm text-neutral-400">
          <span>{data.count} resultados</span>
          <div className="flex gap-2">
            <Button variant="ghost" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page <= 1}>Anterior</Button>
            <span>página {page} de {totalPages}</span>
            <Button variant="ghost" onClick={() => setPage((p) => Math.min(totalPages, p + 1))} disabled={page >= totalPages}>Siguiente</Button>
          </div>
        </div>
      </div>
    </div>
  );
}


import { useEffect, useState } from 'react';
import { kpis } from '../lib/api';
import { Line, LineChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from 'recharts';

export default function KPI() {
  const [data, setData] = useState<Record<string, number | null>>({});
  const [loading, setLoading] = useState(false);

  async function load() {
    setLoading(true);
    try {
      const d = await kpis({});
      setData(d);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  const series = [
    { name: 'fill_rate', value: data.fill_rate ?? 0 },
    { name: 'error_rate', value: data.error_rate ?? 0 },
  ];

  return (
    <div className="container py-6 space-y-4">
      <h1 className="text-xl font-semibold">KPIs</h1>
      <div className="grid md:grid-cols-3 gap-4">
        <div className="card"><p className="muted">Fill rate</p><p className="text-2xl font-semibold">{fmtPct(data.fill_rate)}</p></div>
        <div className="card"><p className="muted">Pedidos</p><p className="text-2xl font-semibold">{data.orders_total ?? '—'}</p></div>
        <div className="card"><p className="muted">Stock</p><p className="text-2xl font-semibold">{data.stock_total ?? '—'}</p></div>
        <div className="card"><p className="muted">Lead time p95</p><p className="text-2xl font-semibold">{fmtSec(data.lead_time_p95_seconds)}</p></div>
        <div className="card"><p className="muted">Error rate</p><p className="text-2xl font-semibold">{fmtPct(data.error_rate)}</p></div>
        <div className="card"><p className="muted">P95 latencia</p><p className="text-2xl font-semibold">{fmtSec(data.p95_latency_seconds)}</p></div>
      </div>
      <div className="card h-64">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={series}>
            <XAxis dataKey="name" stroke="#888" />
            <YAxis stroke="#888" />
            <Tooltip contentStyle={{ background: '#111', border: '1px solid #333', borderRadius: 8 }} />
            <Line dataKey="value" stroke="#22d3ee" dot={false} strokeWidth={2} />
          </LineChart>
        </ResponsiveContainer>
      </div>
      {loading && <div className="h-6 w-24 skeleton" />}
    </div>
  );
}

function fmtPct(v?: number | null) {
  if (v == null) return '—';
  return `${(v * 100).toFixed(1)}%`;
}
function fmtSec(v?: number | null) {
  if (!v && v !== 0) return '—';
  return `${v.toFixed(2)}s`;
}


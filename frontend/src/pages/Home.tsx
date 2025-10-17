import { Link } from 'react-router-dom';
import { useEffect, useState } from 'react';
import { kpis } from '../lib/api';

export default function Home() {
  const [data, setData] = useState<Record<string, number | null>>({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancel = false;
    (async () => {
      try {
        setLoading(true);
        const d = await kpis({});
        if (!cancel) setData(d);
      } catch {
        // ignore on landing
      } finally {
        if (!cancel) setLoading(false);
      }
    })();
    return () => {
      cancel = true;
    };
  }, []);

  return (
    <div>
      {/* Hero */}
      <section className="border-b border-neutral-900 bg-gradient-to-b from-neutral-900/30 to-transparent">
        <div className="container py-12 md:py-16">
          <div className="max-w-3xl">
            <h1 className="text-3xl md:text-4xl font-semibold tracking-tight mb-3">
              Operaciones de canal, de extremo a extremo.
            </h1>
            <p className="text-neutral-400 mb-6">
              Catálogo, inventario one‑pallet, pedidos B2B/B2C y logística con trazabilidad, seguridad y
              observabilidad listas para producción.
            </p>
            <div className="flex gap-3">
              <Link className="btn" to="/products">Ver productos</Link>
              <Link className="btn" to="/orders">Crear pedido</Link>
            </div>
          </div>
        </div>
      </section>

      {/* KPIs quick glance */}
      <section className="container py-8">
        <div className="grid sm:grid-cols-3 gap-4">
          <StatCard label="Fill rate" value={fmtPct(data.fill_rate)} loading={loading} />
          <StatCard label="Pedidos" value={fmtInt(data.orders_total)} loading={loading} />
          <StatCard label="Stock" value={fmtInt(data.stock_total)} loading={loading} />
        </div>
      </section>

      {/* Features */}
      <section className="container pb-10 grid md:grid-cols-3 gap-6">
        <Feature
          title="Inventario"
          desc="Reservas atómicas en Redis, asignación FEFO y ledger event‑sourced."
        />
        <Feature
          title="Pedidos & Fulfillment"
          desc="Flujos B2B/B2C, compensaciones estilo saga, carriers por adapter y webhooks HMAC."
        />
        <Feature
          title="Observabilidad"
          desc="OpenTelemetry + Prometheus + Grafana con KPIs por canal y latencia p95."
        />
      </section>
    </div>
  );
}

function StatCard({ label, value, loading }: { label: string; value: string; loading: boolean }) {
  return (
    <div className="card">
      <p className="muted text-sm mb-1">{label}</p>
      {loading ? (
        <div className="h-7 w-24 skeleton" />
      ) : (
        <p className="text-2xl font-semibold">{value}</p>
      )}
    </div>
  );
}

function Feature({ title, desc }: { title: string; desc: string }) {
  return (
    <div className="card">
      <h3 className="font-semibold mb-1">{title}</h3>
      <p className="muted">{desc}</p>
    </div>
  );
}

function fmtInt(v?: number | null) {
  if (v == null) return '—';
  return new Intl.NumberFormat('es').format(v);
}
function fmtPct(v?: number | null) {
  if (v == null) return '—';
  return `${(v * 100).toFixed(1)}%`;
}


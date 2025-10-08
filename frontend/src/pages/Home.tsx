import { Link } from 'react-router-dom';

export default function Home() {
  return (
    <div className="container py-6">
      <section className="grid md:grid-cols-2 gap-6">
        <div className="card">
          <h1 className="text-2xl font-semibold mb-2">Canal unificado</h1>
          <p className="muted mb-4">Inventario one-pallet, pedidos B2B/B2C y logística integrados.</p>
          <div className="flex gap-3">
            <Link className="btn" to="/products">Ver productos</Link>
            <Link className="btn" to="/orders">Crear pedido</Link>
          </div>
        </div>
        <div className="card">
          <h3 className="font-semibold mb-1">Inventario</h3>
          <p className="muted">Reservas atómicas (Redis) y asignación FEFO con ledger event-sourced.</p>
        </div>
        <div className="card">
          <h3 className="font-semibold mb-1">Fulfillment</h3>
          <p className="muted">Adapters de carriers y webhooks firmados con HMAC.</p>
        </div>
        <div className="card">
          <h3 className="font-semibold mb-1">Observabilidad</h3>
          <p className="muted">OpenTelemetry + Prometheus + Grafana listos para producción.</p>
        </div>
      </section>
    </div>
  );
}


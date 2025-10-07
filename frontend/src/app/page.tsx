export default function HomePage() {
  return (
    <div className="grid">
      <div className="card">
        <h1 style={{marginTop:0}}>Bienvenido</h1>
        <p className="muted">Plataforma unificada de catálogo, inventario one‑pallet, pedidos y logística.</p>
        <div style={{display:'flex',gap:10,marginTop:10}}>
          <a className="btn" href="/login">Iniciar sesión</a>
          <a className="btn" style={{background:'var(--ok)'}} href="/products">Ver productos</a>
        </div>
      </div>
      <div className="card">
        <h3 style={{marginTop:0}}>Inventario one‑pallet</h3>
        <p className="muted">Reservas atómicas con FEFO y ledger event‑sourced.</p>
      </div>
      <div className="card">
        <h3 style={{marginTop:0}}>Pedidos y Fulfillment</h3>
        <p className="muted">Sagas con Celery y webhooks con HMAC.</p>
      </div>
      <div className="card">
        <h3 style={{marginTop:0}}>Observabilidad</h3>
        <p className="muted">Prometheus, Grafana y OpenTelemetry listos.</p>
      </div>
    </div>
  );
}

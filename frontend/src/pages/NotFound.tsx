export default function NotFound() {
  return (
    <div className="container py-16 text-center">
      <h1 className="text-4xl font-semibold mb-2">Página no encontrada</h1>
      <p className="muted mb-6">La ruta solicitada no existe.</p>
      <a className="btn btn-primary" href="/">Volver al inicio</a>
    </div>
  );
}


import './globals.css';
import { Toaster } from 'react-hot-toast';

export const metadata = { title: 'Channel Platform' };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body style={{ fontFamily: 'system-ui, sans-serif', margin: 0 }}>
        <header>
          <div className="container" style={{display:'flex',justifyContent:'space-between',alignItems:'center',padding:'14px 16px'}}>
            <div style={{display:'flex',alignItems:'center',gap:10}}>
              <div style={{width:10,height:10,borderRadius:99,background:'var(--ok)'}}/>
              <b>Channel Platform</b>
            </div>
            <nav style={{display:'flex',gap:14}}>
              <a href="/">Inicio</a>
              <a href="/login">Login</a>
              <a href="/products">Productos</a>
              <a href="/orders">Pedidos</a>
              <a href="/inventory">Inventario</a>
              <a href="/kpis">KPIs</a>
            </nav>
          </div>
        </header>
        <main className="container" style={{padding:'18px 16px'}}>
          <Toaster />
          {children}
        </main>
      </body>
    </html>
  );
}

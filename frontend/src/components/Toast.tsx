import React, { createContext, useContext, useState, useCallback, useEffect } from 'react';

type Toast = { id: string; title: string; color?: 'ok' | 'err' | 'warn' };

const ToastCtx = createContext<{ notify: (t: Omit<Toast, 'id'>) => void } | null>(null);

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [items, setItems] = useState<Toast[]>([]);
  const notify = useCallback((t: Omit<Toast, 'id'>) => {
    const id = `${Date.now()}-${Math.random().toString(16).slice(2)}`;
    setItems((list) => [...list, { ...t, id }]);
    setTimeout(() => setItems((list) => list.filter((x) => x.id !== id)), 3500);
  }, []);

  return (
    <ToastCtx.Provider value={{ notify }}>
      {children}
      <div className="position-fixed bottom-0 end-0 p-3 z-3" style={{ zIndex: 1080 }}>
        {items.map((t) => (
          <div key={t.id} className={`alert ${
            t.color === 'ok' ? 'alert-success' :
            t.color === 'warn' ? 'alert-warning' :
            t.color === 'err' ? 'alert-danger' :
            'alert-secondary'
          }`} role="alert">{t.title}</div>
        ))}
      </div>
    </ToastCtx.Provider>
  );
}

export function useToast() {
  const ctx = useContext(ToastCtx);
  if (!ctx) throw new Error('useToast must be used within ToastProvider');
  return ctx.notify;
}

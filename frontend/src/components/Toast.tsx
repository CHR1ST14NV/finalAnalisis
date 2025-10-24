import React, { createContext, useContext, useState, useCallback } from 'react';

type Toast = { id: string; title: string; color?: 'ok' | 'err' | 'warn' };

const ToastCtx = createContext<{ notify: (t: Omit<Toast, 'id'>) => void } | null>(null);

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [items, setItems] = useState<Toast[]>([]);
  const notify = useCallback((t: Omit<Toast, 'id'>) => {
    const id = `${Date.now()}-${Math.random().toString(16).slice(2)}`;
    setItems((list) => [...list, { ...t, id }]);
    setTimeout(() => setItems((list) => list.filter((x) => x.id !== id)), 3500);
  }, []);

  const colorClass = (c?: Toast['color']) =>
    c === 'ok' ? 'border-emerald-600/60 text-emerald-300' :
    c === 'warn' ? 'border-amber-600/60 text-amber-300' :
    c === 'err' ? 'border-rose-600/60 text-rose-300' : 'border-neutral-700 text-neutral-300';

  return (
    <ToastCtx.Provider value={{ notify }}>
      {children}
      <div className="fixed bottom-0 right-0 p-3 z-50 space-y-2">
        {items.map((t) => (
          <div key={t.id} className={`rounded-lg border px-3 py-2 bg-neutral-950 shadow ${colorClass(t.color)}`}>{t.title}</div>
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


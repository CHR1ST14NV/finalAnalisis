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
      <div className="fixed bottom-4 right-4 space-y-2 z-50">
        {items.map((t) => (
          <div key={t.id} className={`rounded-lg px-3 py-2 shadow border ${
            t.color === 'ok' ? 'bg-emerald-950/80 border-emerald-800 text-emerald-200' :
            t.color === 'warn' ? 'bg-amber-950/80 border-amber-800 text-amber-200' :
            t.color === 'err' ? 'bg-rose-950/80 border-rose-800 text-rose-200' :
            'bg-neutral-900/80 border-neutral-700 text-neutral-200'
          }`}>{t.title}</div>
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


import React from 'react';

export function Input(props: React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      {...props}
      className={
        'w-full rounded-lg bg-bg-muted border border-neutral-800 px-3 py-2 outline-none focus:ring-2 focus:ring-primary/40 ' +
        (props.className || '')
      }
    />
  );
}

export function Button(
  props: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: 'primary' | 'ghost' }
) {
  const base =
    'inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm transition-colors disabled:opacity-60';
  const v = props.variant === 'ghost'
    ? 'bg-transparent border border-neutral-800 hover:bg-neutral-900'
    : 'bg-primary/90 hover:bg-primary text-white';
  return (
    <button {...props} className={`${base} ${v} ${props.className || ''}`.trim()} />
  );
}

export function Label({ children }: { children: React.ReactNode }) {
  return <label className="text-sm text-neutral-300 mb-1 block">{children}</label>;
}


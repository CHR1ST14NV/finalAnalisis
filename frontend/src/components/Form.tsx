import React from 'react';

export function Input(props: React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      {...props}
      className={['form-control', props.className || ''].join(' ').trim()}
    />
  );
}

export function Button(
  props: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: 'primary' | 'ghost' }
) {
  const base =
    'btn btn-sm';
  const v = props.variant === 'ghost'
    ? 'btn-outline-secondary'
    : 'btn-primary';
  return (
    <button {...props} className={`${base} ${v} ${props.className || ''}`.trim()} />
  );
}

export function Label({ children }: { children: React.ReactNode }) {
  return <label className="form-label">{children}</label>;
}

import React from 'react';

export function Input(props: React.InputHTMLAttributes<HTMLInputElement>) {
  return <input {...props} className={["input", props.className || ''].join(' ').trim()} />;
}

export function Button(
  props: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: 'primary' | 'ghost' | 'danger' }
) {
  const v = props.variant === 'ghost' ? 'btn-ghost' : props.variant === 'danger' ? 'btn-danger' : 'btn-primary';
  return (
    <button {...props} className={["btn", v, props.className || ''].join(' ').trim()} />
  );
}

export function Label({ children }: { children: React.ReactNode }) {
  return <label className="label">{children}</label>;
}

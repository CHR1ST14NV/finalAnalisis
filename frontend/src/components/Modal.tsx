import * as Dialog from '@radix-ui/react-dialog';
import { ReactNode } from 'react';

export function Modal({ open, onOpenChange, title, children, footer }: {
  open: boolean;
  onOpenChange: (v: boolean) => void;
  title: string;
  children: ReactNode;
  footer?: ReactNode;
}) {
  return (
    <Dialog.Root open={open} onOpenChange={onOpenChange}>
      <Dialog.Portal>
        <Dialog.Overlay className="modal-overlay" />
        <div className="fixed inset-0 grid place-items-center p-4">
          <Dialog.Content className="modal-panel w-full max-w-2xl">
            <div className="p-4 border-b border-neutral-800 flex items-center justify-between">
              <Dialog.Title className="text-lg font-semibold">{title}</Dialog.Title>
              <Dialog.Close className="btn btn-ghost px-2 py-1" aria-label="Close">✕</Dialog.Close>
            </div>
            <div className="p-4">
              {children}
            </div>
            {footer && (
              <div className="p-4 border-t border-neutral-800 flex items-center justify-end gap-2">
                {footer}
              </div>
            )}
          </Dialog.Content>
        </div>
      </Dialog.Portal>
    </Dialog.Root>
  );
}

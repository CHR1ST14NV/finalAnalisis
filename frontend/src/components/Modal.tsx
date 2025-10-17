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
        <Dialog.Content className="modal-panel w-[min(100%,40rem)] mx-auto mt-24">
          <div className="flex items-center justify-between px-4 py-3 border-b border-neutral-800">
            <Dialog.Title className="font-semibold">{title}</Dialog.Title>
            <Dialog.Close className="text-neutral-400 hover:text-white">×</Dialog.Close>
          </div>
          <div className="p-4">
            {children}
          </div>
          {footer && (
            <div className="flex items-center justify-end gap-2 px-4 py-3 border-t border-neutral-800">
              {footer}
            </div>
          )}
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
}


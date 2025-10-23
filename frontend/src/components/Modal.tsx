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
        <Dialog.Overlay className="modal fade show d-block" style={{ backgroundColor: 'rgba(0,0,0,.5)' }} />
        <Dialog.Content className="modal d-block" style={{ display: 'block' }}>
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <Dialog.Title className="modal-title">{title}</Dialog.Title>
                <Dialog.Close className="btn-close" aria-label="Close" />
              </div>
              <div className="modal-body">
                {children}
              </div>
              {footer && (
                <div className="modal-footer">
                  {footer}
                </div>
              )}
            </div>
          </div>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
}
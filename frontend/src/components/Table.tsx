import React from 'react';

export function Table({ children, ...rest }: React.TableHTMLAttributes<HTMLTableElement>) {
  return (
    <table className="table" {...rest}>
      {children}
    </table>
  );
}

export function Th({ children, ...rest }: React.ThHTMLAttributes<HTMLTableHeaderCellElement>) {
  return (
    <th className="px-2 py-2 text-left text-neutral-300 border-b border-neutral-800" {...rest}>
      {children}
    </th>
  );
}

export function Td({ children, ...rest }: React.TdHTMLAttributes<HTMLTableCellElement>) {
  return (
    <td className="px-2 py-2 border-b border-neutral-900" {...rest}>
      {children}
    </td>
  );
}

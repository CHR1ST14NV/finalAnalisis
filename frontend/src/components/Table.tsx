import React from 'react';

export function Table({ children, ...rest }: React.TableHTMLAttributes<HTMLTableElement>) {
  return (
    <table className="table table-dark table-striped table-hover table-sm align-middle" {...rest}>
      {children}
    </table>
  );
}

export function Th({ children, ...rest }: React.ThHTMLAttributes<HTMLTableHeaderCellElement>) {
  return (
    <th className="text-start" {...rest}>
      {children}
    </th>
  );
}

export function Td({ children, ...rest }: React.TdHTMLAttributes<HTMLTableCellElement>) {
  return (
    <td {...rest}>
      {children}
    </td>
  );
}

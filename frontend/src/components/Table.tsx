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
    <th {...rest}>
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

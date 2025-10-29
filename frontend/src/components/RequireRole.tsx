import React, { useEffect, useState } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { me } from '../lib/api';

type Props = { roles: string[]; children: React.ReactNode };

export default function RequireRole({ roles, children }: Props) {
  const loc = useLocation();
  const [ok, setOk] = useState<boolean | null>(null);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const u = await me();
        const codes = new Set((u.roles || []).map((r) => (r as any).code));
        if (!mounted) return;
        setOk(roles.some((r) => codes.has(r)));
      } catch (e) {
        // If cannot fetch profile, consider not authorized
        if (!mounted) return;
        setOk(false);
      }
    })();
    return () => {
      mounted = false;
    };
  }, [roles.join(',')]);

  if (ok === null) return <div className="container py-6 text-sm text-neutral-400">Verificando permisos…</div>;
  if (!ok) return <Navigate to="/" state={{ from: loc }} replace />;
  return <>{children}</>;
}


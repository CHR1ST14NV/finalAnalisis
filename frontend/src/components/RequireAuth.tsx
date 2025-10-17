import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { isAuthenticated } from '../lib/api';

export default function RequireAuth({ children }: { children: React.ReactNode }) {
  const authed = isAuthenticated();
  const loc = useLocation();
  if (!authed) {
    return <Navigate to="/login" state={{ from: loc }} replace />;
  }
  return <>{children}</>;
}


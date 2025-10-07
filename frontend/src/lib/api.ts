export type HttpMethod = 'GET'|'POST'|'PUT'|'PATCH'|'DELETE'

const refresh = async () => {
  const refreshToken = localStorage.getItem('refresh');
  if (!refreshToken) throw new Error('no_refresh');
  const r = await fetch('/api/v1/auth/token/refresh/', {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ refresh: refreshToken })
  });
  const data = await r.json();
  if (!r.ok) throw new Error('refresh_failed');
  localStorage.setItem('token', data.access);
  return data.access as string;
}

export async function api(path: string, opts?: { method?: HttpMethod, body?: any, headers?: Record<string,string> }) {
  const method = opts?.method || 'GET';
  const headers: Record<string,string> = { 'Content-Type':'application/json', ...(opts?.headers||{}) };
  let token = localStorage.getItem('token');
  if (token) headers['Authorization'] = `Bearer ${token}`;
  let res = await fetch(path, { method, headers, body: opts?.body ? JSON.stringify(opts.body) : undefined });
  if (res.status === 401 && localStorage.getItem('refresh')) {
    try { token = await refresh(); headers['Authorization'] = `Bearer ${token}`; }
    catch { /* ignore */ }
    res = await fetch(path, { method, headers, body: opts?.body ? JSON.stringify(opts.body) : undefined });
  }
  const data = await res.json().catch(()=>({}));
  if (!res.ok) throw new Error((data && (data.detail||data.error)) || 'request_failed');
  return data;
}


import { z } from 'zod';

// Simple in-memory + sessionStorage token store for JWT session
// Uses sessionStorage to persist across refresh without writing long-lived tokens to disk
const TOKENS_KEY = 'chan.tokens';

const API_BASE = '/api/v1';

export const jwtSchema = z.object({
  access: z.string(),
  refresh: z.string().optional(),
});

export type JWT = z.infer<typeof jwtSchema>;

let accessToken: string | null = null;
let refreshToken: string | null = null;

function loadTokens() {
  try {
    const raw = sessionStorage.getItem(TOKENS_KEY);
    if (!raw) return;
    const parsed = jwtSchema.partial().safeParse(JSON.parse(raw));
    if (parsed.success) {
      accessToken = parsed.data.access ?? null;
      refreshToken = parsed.data.refresh ?? null;
    }
  } catch {
    // ignore
  }
}

function persistTokens() {
  try {
    const data: Partial<JWT> = {};
    if (accessToken) data.access = accessToken;
    if (refreshToken) data.refresh = refreshToken;
    sessionStorage.setItem(TOKENS_KEY, JSON.stringify(data));
  } catch {
    // ignore
  }
}

export function setTokens(tokens: Partial<JWT>) {
  if (tokens.access) accessToken = tokens.access;
  if (tokens.refresh) refreshToken = tokens.refresh;
  persistTokens();
}

export async function api<T>(path: string, init: RequestInit = {}): Promise<T> {
  const headers = new Headers(init.headers);
  headers.set('Content-Type', 'application/json');
  if (accessToken) headers.set('Authorization', `Bearer ${accessToken}`);

  const res = await fetch(`${API_BASE}${path}`, { ...init, headers });
  if (res.status === 401 && refreshToken) {
    // try refresh
    const r = await fetch(`${API_BASE}/auth/token/refresh/`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refresh: refreshToken }),
    });
    if (r.ok) {
      const data = await r.json();
      const parsed = jwtSchema.partial().parse(data);
      if (parsed.access) {
        accessToken = parsed.access;
        persistTokens();
        return api<T>(path, init);
      }
    }
    // failed refresh
    accessToken = null;
    refreshToken = null;
    persistTokens();
    throw new Error('Unauthorized');
  }
  if (!res.ok) {
    const msg = await res.text();
    throw new Error(msg || res.statusText);
  }
  return (await res.json()) as T;
}

export async function login(username: string, password: string) {
  const data = await fetch(`${API_BASE}/auth/token/`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password }),
  }).then((r) => r.json());
  const tokens = jwtSchema.parse(data);
  setTokens(tokens);
}

export function logout() {
  accessToken = null;
  refreshToken = null;
  persistTokens();
}

export function isAuthenticated() {
  if (!accessToken && !refreshToken) loadTokens();
  return Boolean(accessToken || refreshToken);
}

function randomIdemKey() {
  if (typeof crypto !== 'undefined' && 'randomUUID' in crypto) return (crypto as any).randomUUID();
  return `${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

// Types
export const productSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string().optional(),
});
export type Product = z.infer<typeof productSchema>;

export const orderSchema = z.object({
  id: z.string(),
  status: z.string(),
  customer_ref: z.string(),
  created_at: z.string(),
});
export type Order = z.infer<typeof orderSchema>;

export async function fetchProducts(params: { page?: number; q?: string }) {
  const search = new URLSearchParams();
  if (params.page) search.set('page', String(params.page));
  if (params.q) search.set('q', params.q);
  const url = `/catalog/products/${search.toString() ? `?${search.toString()}` : ''}`;
  return api<{ results: Product[]; count: number }>(url);
}

export async function fetchOrders() {
  return api<Order[]>(`/orders/`);
}

export async function createOrder(payload: {
  customer_ref: string;
  channel: 'B2B' | 'B2C';
  items: { sku_id: string; qty: number; unit_price: string }[];
  warehouse_id?: string;
}) {
  return api<Order>(`/orders/`, {
    method: 'POST',
    headers: { 'Idempotency-Key': randomIdemKey() },
    body: JSON.stringify(payload),
  });
}

export async function confirmOrder(orderId: string) {
  return api<{ status: string }>(`/orders/${orderId}/confirm/`, {
    method: 'POST',
    headers: { 'Idempotency-Key': randomIdemKey() },
  });
}

export async function kpis(params: { start?: string; end?: string; warehouse?: string }) {
  const sp = new URLSearchParams(params as Record<string, string>);
  return api<Record<string, number | null>>(`/metrics/kpis/?${sp.toString()}`);
}

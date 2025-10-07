"use client";
import { useEffect, useState } from 'react';

type KPIs = { fill_rate:number; orders_total:number; delivered:number; stock_total:number };

export default function KPIsPage(){
  const [data,setData] = useState<KPIs|null>(null);
  const [err,setErr] = useState('');
  useEffect(()=>{
    const token = localStorage.getItem('token');
    fetch('/api/v1/metrics/kpis/', { headers: token? {Authorization:`Bearer ${token}`} : {} })
      .then(r=>r.json()).then(setData).catch(e=>setErr(String(e)));
  },[]);
  return (
    <div className="grid">
      {err && <div className="card" style={{borderColor:'var(--err)'}}>{err}</div>}
      <div className="card"><h3 style={{marginTop:0}}>Fill rate</h3><div style={{fontSize:28}}>{data? (data.fill_rate*100).toFixed(1):'—'}%</div></div>
      <div className="card"><h3 style={{marginTop:0}}>Órdenes</h3><div style={{fontSize:28}}>{data?.orders_total ?? '—'}</div></div>
      <div className="card"><h3 style={{marginTop:0}}>Entregadas</h3><div style={{fontSize:28}}>{data?.delivered ?? '—'}</div></div>
      <div className="card"><h3 style={{marginTop:0}}>Stock total</h3><div style={{fontSize:28}}>{data?.stock_total ?? '—'}</div></div>
    </div>
  );
}


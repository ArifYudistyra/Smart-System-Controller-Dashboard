'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { loginAction, logoutAction, manageUserAction, registerAction } from './actions'

type User = { id: string; name?: string | null; email: string; role?: string | null } | null
type ManagedUser = { id: string; name?: string | null; email: string; role?: 'user'|'master'|null; status?: 'active'|'suspended'|null; createdAt: string }
const devices = [
  { name: 'Greenhouse Utama', id: 'ND-GH01', icon: '/assets/2b40a.svg', value: '28,4 °C', sub: '72% RH · Tanah 46%', online: true },
  { name: 'Hidroponik Teras', id: 'ND-HY02', icon: '/assets/12e43.svg', value: 'pH 6,2', sub: 'Air 24,8 °C', online: true },
  { name: 'Akuarium Ruang', id: 'ND-AQ03', icon: '/assets/fc6cf.svg', value: '26,1 °C', sub: 'Level air 82%', online: true },
  { name: 'Kebun Samping', id: 'ND-GD04', icon: '/assets/e56e0.svg', value: 'Tanah 38%', sub: 'Data terakhir · bukan data terkini', online: false },
]

function AuthView() {
  const [mode, setMode] = useState<'login' | 'register'>('login')
  const [pending, start] = useTransition()
  const [message, setMessage] = useState('')
  const router = useRouter()
  const submit = (formData: FormData) => start(async () => {
    const result = mode === 'login' ? await loginAction(formData) : await registerAction(formData)
    setMessage(result.message || '')
    if (result.ok) router.refresh()
  })
  return <main className="auth-shell">
    <section className="auth-story">
      <div className="brand"><span>N</span> Nodus</div>
      <div><p className="eyebrow">SMART SYSTEM, SIMPLIFIED</p><h1>Semua ruang Anda,<br/>dalam satu kendali.</h1><p>Pantau sensor, kendalikan aktuator, dan jaga semua perangkat tetap sinkron dari mana saja.</p></div>
      <p className="secure-note">Data privat per pengguna · Akses master terkontrol</p>
    </section>
    <section className="auth-panel">
      <div className="auth-card"><p className="eyebrow">SELAMAT DATANG</p><h2>{mode === 'login' ? 'Masuk ke ruang Anda' : 'Buat ruang kendali'}</h2><p className="muted">{mode === 'login' ? 'Gunakan akun yang sudah terdaftar.' : 'Mulai hubungkan sistem pintar Anda.'}</p>
        <form action={submit}>
          {mode === 'register' && <label>Nama lengkap<input name="name" required placeholder="Nama Anda"/></label>}
          <label>Email<input name="email" type="email" required placeholder="nama@email.com"/></label>
          <label>Kata sandi<input name="password" type="password" minLength={8} required placeholder="Minimal 8 karakter"/></label>
          {message && <p className="form-error">{message}</p>}
          <button className="primary" disabled={pending}>{pending ? 'Memproses…' : mode === 'login' ? 'Masuk' : 'Daftar akun'}</button>
        </form>
        <button className="text-button" onClick={() => { setMode(mode === 'login' ? 'register' : 'login'); setMessage('') }}>{mode === 'login' ? 'Belum punya akun? Daftar' : 'Sudah punya akun? Masuk'}</button>
      </div>
    </section>
  </main>
}

export default function DashboardApp({ user, managedUsers }: { user: User; managedUsers: ManagedUser[] }) {
  const [tab, setTab] = useState<'home'|'devices'|'activity'|'admin'|'account'>('home')
  const [modal, setModal] = useState(false)
  const [pump, setPump] = useState(false)
  const [adminPending, startAdmin] = useTransition()
  const [adminMessage, setAdminMessage] = useState('')
  const router = useRouter()
  if (!user) return <AuthView />
  const signOut = async () => { await logoutAction(); router.refresh() }
  const manage = (formData: FormData) => startAdmin(async () => {
    const result = await manageUserAction(formData)
    setAdminMessage(result.message || '')
    if (result.ok) router.refresh()
  })
  return <main className="app-shell">
    <aside className="sidebar">
      <div className="brand"><span>N</span> Nodus</div>
      <nav>
        <button className={tab==='home'?'active':''} onClick={()=>setTab('home')}>▦ <span>Beranda</span></button>
        <button className={tab==='devices'?'active':''} onClick={()=>setTab('devices')}>▣ <span>Perangkat</span></button>
        <button className={tab==='activity'?'active':''} onClick={()=>setTab('activity')}>⌁ <span>Aktivitas</span></button>
        {user.role==='master' && <button className={tab==='admin'?'active':''} onClick={()=>setTab('admin')}>◎ <span>Pengguna</span></button>}
        <button className={tab==='account'?'active':''} onClick={()=>setTab('account')}>○ <span>Akun</span></button>
      </nav>
      <div className="side-user"><span>{(user.name||user.email).slice(0,2).toUpperCase()}</span><div><b>{user.name||'Pengguna'}</b><small>{user.role==='master'?'Master admin':'Ruang pribadi'}</small></div></div>
    </aside>
    <div className="workspace">
      <header><div><h1>Selamat pagi, {(user.name||'Pengguna').split(' ')[0]}</h1><p>Ruang pribadi · Semua sistem normal</p></div><button className="icon-button" aria-label="Notifikasi"><img src="/assets/0e574.svg" alt=""/></button></header>
      <div className="content">
        {tab === 'home' && <>
          <section className="summary-grid">
            <article className="connect-card"><div className="card-label">PERANGKAT SAYA <span>◉</span></div><div className="count"><b>04</b><p>perangkat tertaut<br/>hanya milik Anda</p></div><div className="bar"><i/><i/></div><div className="status-row"><span>● &nbsp;3 online</span><span>● &nbsp;1 offline</span></div><small>Sinkronisasi terakhir · baru saja</small></article>
            <article className="chart-card"><div className="section-head"><div><p className="card-label">SUHU GREENHOUSE</p><h2>28,4 °C</h2></div><select aria-label="Rentang waktu"><option>24 jam</option><option>7 hari</option><option>30 hari</option></select></div><svg viewBox="0 0 520 150" role="img" aria-label="Grafik suhu 24 jam"><defs><linearGradient id="area" x1="0" y1="0" x2="0" y2="1"><stop stopColor="#13a89e" stopOpacity=".25"/><stop offset="1" stopColor="#13a89e" stopOpacity="0"/></linearGradient></defs><path className="area" d="M0 130 C60 120 70 80 130 92 S210 125 260 72 S330 35 385 62 S455 100 520 24 L520 150 L0 150Z"/><path className="line" d="M0 130 C60 120 70 80 130 92 S210 125 260 72 S330 35 385 62 S455 100 520 24"/></svg><div className="timeline"><span>00.00</span><span>06.00</span><span>12.00</span><span>18.00</span><span>Sekarang</span></div></article>
          </section>
          <section className="sync-note"><img src="/assets/65f20.svg" alt=""/><div><b>Tetap sinkron, meski aplikasi ditutup</b><p>Perangkat mengirim data langsung ke cloud selama daya dan internet tersedia.</p></div></section>
          <div className="section-head"><div><p className="eyebrow">RUANG KENDALI</p><h2>Perangkat Anda</h2></div><button className="primary compact" onClick={()=>setModal(true)}>+ Tambah perangkat</button></div>
          <section className="device-grid">{devices.map((d,i)=><article className="device-card" key={d.id}><div className="device-head"><span className="device-icon"><img src={d.icon} alt=""/></span><div><h3>{d.name}</h3><small>{d.id}</small></div><span className={d.online?'badge':'badge offline'}>● {d.online?'Online':'Offline'}</span></div><div className="device-data"><div><b>{d.value}</b><p>{d.sub}</p></div>{i===0&&<button className={'switch '+(pump?'on':'')} onClick={()=>setPump(!pump)} aria-label="Pompa air"><i/></button>}</div>{i===0&&<small className="control-label">Pompa air · {pump?'Aktif':'Nonaktif'}</small>}</article>)}</section>
        </>}
        {tab === 'devices' && <section><div className="section-head"><div><p className="eyebrow">INVENTARIS</p><h2>Semua perangkat</h2></div><button className="primary compact" onClick={()=>setModal(true)}>+ Tambah perangkat</button></div><div className="device-grid">{devices.map(d=><article className="device-card" key={d.id}><div className="device-head"><span className="device-icon"><img src={d.icon} alt=""/></span><div><h3>{d.name}</h3><small>{d.id}</small></div><span className={d.online?'badge':'badge offline'}>● {d.online?'Online':'Offline'}</span></div><p className="muted">{d.value} · {d.sub}</p></article>)}</div></section>}
        {tab === 'activity' && <section className="empty-state"><p className="eyebrow">AKTIVITAS REALTIME</p><h2>Semua perubahan tercatat</h2><p>Grafik sensor dan riwayat kontrol akan tampil di sini saat perangkat mulai mengirim data.</p></section>}
        {tab === 'admin' && user.role === 'master' && <section>
          <div className="section-head"><div><p className="eyebrow">ADMINISTRASI</p><h2>Management pengguna</h2></div><span className="badge">● {managedUsers.length} akun</span></div>
          <p className="muted">Tinjau akun, atur hak master, atau tangguhkan akses tanpa membuka data pengguna lain dari browser.</p>
          {adminMessage && <p className="admin-message">{adminMessage}</p>}
          <div className="user-table">
            <div className="user-table-head"><span>Pengguna</span><span>Role</span><span>Status</span><span>Aksi</span></div>
            {managedUsers.map(managed => <div className="user-row" key={managed.id}>
              <div className="user-identity"><span>{(managed.name||managed.email).slice(0,2).toUpperCase()}</span><div><b>{managed.name||'Tanpa nama'}{managed.id===user.id && ' (Anda)'}</b><small>{managed.email}</small></div></div>
              <form action={manage}><input type="hidden" name="id" value={managed.id}/><input type="hidden" name="intent" value="role"/><select name="role" defaultValue={managed.role||'user'} disabled={managed.id===user.id||adminPending} onChange={event=>event.currentTarget.form?.requestSubmit()}><option value="user">Pengguna</option><option value="master">Master</option></select></form>
              <form action={manage}><input type="hidden" name="id" value={managed.id}/><input type="hidden" name="intent" value="status"/><input type="hidden" name="status" value={managed.status==='suspended'?'active':'suspended'}/><button className={managed.status==='suspended'?'status-action active':'status-action'} disabled={managed.id===user.id||adminPending}>{managed.status==='suspended'?'Aktifkan':'Tangguhkan'}</button></form>
              <form action={manage} onSubmit={event=>{if(!window.confirm(`Hapus akun ${managed.email}? Perangkat yang masih terkait dapat mencegah penghapusan.`)) event.preventDefault()}}><input type="hidden" name="id" value={managed.id}/><input type="hidden" name="intent" value="delete"/><button className="delete-action" disabled={managed.id===user.id||adminPending}>Hapus</button></form>
            </div>)}
          </div>
        </section>}
        {tab === 'account' && <section className="account-card"><span className="avatar">{(user.name||user.email).slice(0,2).toUpperCase()}</span><h2>{user.name||'Pengguna Nodus'}</h2><p>{user.email}</p><span className="badge">● {user.role==='master'?'Master admin':'Akun pengguna'}</span><button className="danger" onClick={signOut}>Keluar dari akun</button></section>}
      </div>
    </div>
    {modal && <div className="modal-backdrop" onMouseDown={()=>setModal(false)}><section className="modal" onMouseDown={e=>e.stopPropagation()}><div className="section-head"><div><p className="eyebrow">PERANGKAT BARU</p><h2>Hubungkan smart system</h2></div><button className="icon-button" onClick={()=>setModal(false)}>×</button></div><label>Nama perangkat<input placeholder="Contoh: Pompa Kebun"/></label><label>Jenis perangkat<select><option>Microcontroller</option><option>Sensor</option><option>Aktuator / relay</option><option>Sistem hybrid</option></select></label><label>ID perangkat<input placeholder="ND-XXXXX"/></label><div className="modal-actions"><button className="secondary" onClick={()=>setModal(false)}>Batal</button><button className="primary" onClick={()=>setModal(false)}>Hubungkan</button></div></section></div>}
  </main>
}

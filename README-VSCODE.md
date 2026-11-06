# Nodus Smart System

Paket ini berisi source code Next.js, React, Tailwind CSS, dan Payload CMS untuk
dibuka serta diedit di Visual Studio Code.

## Persyaratan

- Node.js 24.22.1 atau lebih baru
- pnpm 9, 10, atau 11
- Visual Studio Code

## Membuka proyek

1. Ekstrak file ZIP.
2. Buka folder hasil ekstrak melalui **File → Open Folder** di VS Code.
3. Buka terminal VS Code.
4. Jalankan:

   ```bash
   corepack enable
   pnpm install
   pnpm dev
   ```

5. Buka `http://localhost:3000`.

## Pemeriksaan source code

```bash
pnpm exec tsc --noEmit
pnpm build
```

## Struktur penting

- `src/app/(frontend)` — UI aplikasi, autentikasi, dan dashboard.
- `src/collections` — model Users, Devices, dan Sensor Readings.
- `src/payload.config.ts` — konfigurasi Payload.
- `public/assets` — aset visual lokal.

## Backend

Versi ini menggunakan backend Payload yang dikelola Figma Make melalui
`@payloadcms/figma`. Source code dapat diedit di VS Code, tetapi autentikasi,
database, storage, dan `/admin` memerlukan environment backend yang disediakan
Figma saat dijalankan dari Figma Make atau setelah dipublikasikan melalui
platform tersebut.

Menjalankan backend sepenuhnya secara mandiri di komputer lokal memerlukan
migrasi terpisah ke Payload standalone beserta database sendiri, atau migrasi
ke Firebase. Jangan menambahkan secret ke source code atau mengirim file `.env`
ke Git.

## Membuat akun master

1. Daftarkan akun pengguna melalui aplikasi.
2. Buka `/admin` menggunakan akses editor Figma/Payload.
3. Pilih **Smart System → Users**.
4. Ubah `Role` akun menjadi `Master` dan `Status` menjadi `Aktif`.
5. Masuk kembali melalui aplikasi. Menu **Pengguna** akan tersedia.

'use server'

import config from '@payload-config'
import { cookies } from 'next/headers'
import { getPayload } from 'payload'
import { getCurrentUser } from '@/lib/app-auth'

type Result = { ok: boolean; message?: string }

export async function loginAction(formData: FormData): Promise<Result> {
  try {
    const payload = await getPayload({ config })
    const result = await payload.login({
      collection: 'users',
      data: {
        email: String(formData.get('email') || ''),
        password: String(formData.get('password') || ''),
      },
    })
    if (!result.token) return { ok: false, message: 'Email atau kata sandi tidak sesuai.' }
    if (result.user?.status === 'suspended') {
      return { ok: false, message: 'Akun ini sedang ditangguhkan oleh administrator.' }
    }
    ;(await cookies()).set('app-session', result.token, {
      httpOnly: true,
      sameSite: 'lax',
      secure: process.env.NODE_ENV === 'production',
      path: '/',
    })
    return { ok: true }
  } catch {
    return { ok: false, message: 'Email atau kata sandi tidak sesuai.' }
  }
}

export async function registerAction(formData: FormData): Promise<Result> {
  try {
    const payload = await getPayload({ config })
    await payload.create({
      collection: 'users',
      data: {
        name: String(formData.get('name') || ''),
        email: String(formData.get('email') || ''),
        password: String(formData.get('password') || ''),
      },
      overrideAccess: false,
    })
    return loginAction(formData)
  } catch {
    return { ok: false, message: 'Akun tidak dapat dibuat. Periksa kembali data Anda.' }
  }
}

export async function logoutAction(): Promise<Result> {
  ;(await cookies()).delete('app-session')
  return { ok: true }
}

export async function manageUserAction(formData: FormData): Promise<Result> {
  const currentUser = await getCurrentUser()
  if (!currentUser || currentUser.role !== 'master') {
    return { ok: false, message: 'Akses administrator diperlukan.' }
  }

  const id = String(formData.get('id') || '')
  const intent = String(formData.get('intent') || '')
  if (!id || id === String(currentUser.id)) {
    return { ok: false, message: 'Akun master yang sedang aktif tidak dapat diubah.' }
  }

  try {
    const payload = await getPayload({ config })
    if (intent === 'delete') {
      await payload.delete({
        collection: 'users',
        id,
        overrideAccess: false,
        user: currentUser,
      })
    } else if (intent === 'role') {
      const role = formData.get('role')
      if (role !== 'user' && role !== 'master') return { ok: false, message: 'Role tidak valid.' }
      await payload.update({
        collection: 'users',
        id,
        data: { role },
        overrideAccess: false,
        user: currentUser,
      })
    } else if (intent === 'status') {
      const status = formData.get('status')
      if (status !== 'active' && status !== 'suspended') {
        return { ok: false, message: 'Status tidak valid.' }
      }
      await payload.update({
        collection: 'users',
        id,
        data: { status },
        overrideAccess: false,
        user: currentUser,
      })
    } else {
      return { ok: false, message: 'Perintah tidak dikenal.' }
    }
    return { ok: true, message: 'Perubahan pengguna berhasil disimpan.' }
  } catch {
    return { ok: false, message: 'Perubahan gagal disimpan.' }
  }
}

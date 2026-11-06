import config from '@payload-config'
import { cookies } from 'next/headers'
import { getPayload } from 'payload'

export async function getCurrentUser() {
  const token = (await cookies()).get('app-session')?.value
  if (!token) return null
  const payload = await getPayload({ config })
  const { user } = await payload.auth({
    headers: new Headers({ Authorization: `JWT ${token}` }),
  })
  return user?.collection === 'users' ? user : null
}

export async function getManagedUsers(user: Awaited<ReturnType<typeof getCurrentUser>>) {
  if (!user || user.role !== 'master') return []
  const payload = await getPayload({ config })
  const result = await payload.find({
    collection: 'users',
    limit: 100,
    sort: '-createdAt',
    overrideAccess: false,
    user,
  })
  return result.docs.map(({ id, name, email, role, status, createdAt }) => ({
    id: String(id),
    name,
    email,
    role,
    status,
    createdAt,
  }))
}

import DashboardApp from './DashboardApp'
import { getCurrentUser, getManagedUsers } from '@/lib/app-auth'

export default async function HomePage() {
  const user = await getCurrentUser()
  const managedUsers = await getManagedUsers(user)
  return <DashboardApp user={user ? { id: String(user.id), name: user.name, email: user.email, role: user.role } : null} managedUsers={managedUsers} />
}

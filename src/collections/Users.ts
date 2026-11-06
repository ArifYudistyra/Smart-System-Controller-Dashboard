import type { Access, CollectionConfig } from 'payload'

const isManager = (user: any) =>
  user?.collection === 'admins' || (user?.collection === 'users' && user?.role === 'master')
const selfOrManager: Access = ({ req }) =>
  isManager(req.user) || (req.user?.collection === 'users' ? { id: { equals: req.user.id } } : false)

export const Users: CollectionConfig = {
  slug: 'users',
  auth: true,
  admin: { useAsTitle: 'name', group: 'Smart System' },
  access: {
    create: () => true,
    read: selfOrManager,
    update: selfOrManager,
    delete: ({ req }) => isManager(req.user),
  },
  fields: [
    { name: 'name', type: 'text', required: true },
    {
      name: 'role',
      type: 'select',
      defaultValue: 'user',
      options: [
        { label: 'Pengguna', value: 'user' },
        { label: 'Master', value: 'master' },
      ],
      access: {
        create: ({ req }) => isManager(req.user),
        update: ({ req }) => isManager(req.user),
      },
    },
    {
      name: 'status',
      type: 'select',
      defaultValue: 'active',
      options: [
        { label: 'Aktif', value: 'active' },
        { label: 'Ditangguhkan', value: 'suspended' },
      ],
      access: {
        create: ({ req }) => isManager(req.user),
        update: ({ req }) => isManager(req.user),
      },
    },
  ],
}

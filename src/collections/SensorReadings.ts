import type { Access, CollectionConfig } from 'payload'

const canRead: Access = ({ req }) => {
  const user = req.user as any
  if (user?.collection !== 'users') return false
  return user.role === 'master' ? true : { owner: { equals: user.id } }
}

export const SensorReadings: CollectionConfig = {
  slug: 'sensor-readings',
  admin: { useAsTitle: 'metric', group: 'Smart System' },
  access: { create: canRead, read: canRead, update: () => false, delete: canRead },
  hooks: {
    beforeChange: [
      ({ req, data }) =>
        req.user?.collection === 'users' ? { ...data, owner: req.user.id } : data,
    ],
  },
  fields: [
    { name: 'device', type: 'relationship', relationTo: 'devices', required: true, index: true },
    { name: 'owner', type: 'relationship', relationTo: 'users', required: true, index: true },
    { name: 'metric', type: 'text', required: true },
    { name: 'value', type: 'number', required: true },
    { name: 'unit', type: 'text' },
    { name: 'recordedAt', type: 'date', required: true, index: true },
  ],
}

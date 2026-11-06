import type { Access, CollectionConfig } from 'payload'

const owned: Access = ({ req }) => {
  const user = req.user as any
  if (user?.collection !== 'users') return false
  return user.role === 'master' ? true : { owner: { equals: user.id } }
}

export const Devices: CollectionConfig = {
  slug: 'devices',
  admin: { useAsTitle: 'name', group: 'Smart System' },
  access: { create: owned, read: owned, update: owned, delete: owned },
  hooks: {
    beforeChange: [
      ({ req, data, operation }) => {
        if (operation === 'create' && req.user?.collection === 'users') {
          return { ...data, owner: req.user.id }
        }
        return data
      },
    ],
  },
  fields: [
    { name: 'name', type: 'text', required: true },
    { name: 'deviceId', type: 'text', required: true, unique: true, index: true },
    {
      name: 'kind',
      type: 'select',
      required: true,
      options: ['microcontroller', 'sensor', 'actuator', 'hybrid'],
    },
    {
      name: 'owner',
      type: 'relationship',
      relationTo: 'users',
      required: true,
      index: true,
      access: { create: () => false, update: () => false },
    },
    { name: 'online', type: 'checkbox', defaultValue: false },
    { name: 'lastSeen', type: 'date' },
    {
      name: 'controls',
      type: 'array',
      fields: [
        { name: 'label', type: 'text', required: true },
        { name: 'pin', type: 'text' },
        { name: 'value', type: 'checkbox', defaultValue: false },
      ],
    },
  ],
}

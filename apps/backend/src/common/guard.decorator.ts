import { SetMetadata } from '@nestjs/common'

export const PUBLIC_KEY = 'public'
export const ROLES_KEY = 'role'

export const Public = () => SetMetadata(PUBLIC_KEY, true)

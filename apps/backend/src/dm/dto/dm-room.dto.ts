import type { JwtPayload } from '@/auth/jwt/jwt.interface'

export interface DMRoom {
  roomId: string
  name: string
  lastMessage?: {
    messageId: string
    content: string
    timestamp: Date
    sender: JwtPayload
  }
  participants: {
    userId: number
    lastRead: Date
  }[]
}

export interface DMRoomResponse {
  roomId: string
  name: string
  participants: number[]
  createdAt: Date
}

export interface CreateRoomDto {
  name: string
  participantIds: number[]
}

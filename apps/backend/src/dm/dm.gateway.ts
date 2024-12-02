import {
  Catch,
  UseFilters,
  UseGuards,
  type ArgumentsHost
} from '@nestjs/common'
import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  WsException,
  BaseWsExceptionFilter
} from '@nestjs/websockets'
import type { JwtPayload } from '@/auth/jwt/jwt.interface'
import { WsJwtGuard } from '@/auth/ws-jwt/ws.jwt.guard'
import { Server, Socket } from 'socket.io'
import { v4 as uuid } from 'uuid'
import type { CreateRoomDto, DMRoom, DMRoomResponse } from './dto/dm-room.dto'

@Catch(WsException)
export class WebsocketExceptionsFilter extends BaseWsExceptionFilter {
  catch(exception: WsException, host: ArgumentsHost) {
    const client = host.switchToWs().getClient<Socket>()
    const error = exception.getError()
    const details = error instanceof Object ? { ...error } : { message: error }

    client.emit('error', {
      error: details,
      timestamp: new Date().toISOString()
    })
  }
}

@UseFilters(new WebsocketExceptionsFilter())
@UseGuards(WsJwtGuard)
@WebSocketGateway({
  cors: {
    origin: '*'
  }
})
export class DMGateway {
  @WebSocketServer()
  server: Server

  private chatRooms: Map<string, DMRoom> = new Map()
  private userRooms: Map<number, Set<string>> = new Map()

  handleConnection(client: Socket) {
    const user = client.data.user as JwtPayload
    console.log(`사용자 ${user.nickname} 연결되었습니다`)
  }

  @SubscribeMessage('getRooms')
  async handleGetRooms(@ConnectedSocket() client: Socket) {
    const user = client.data.user as JwtPayload
    const rooms = this.userRooms.get(user.userId) || new Set()

    const roomList = Array.from(rooms).map((roomId) => {
      const room = this.chatRooms.get(roomId)
      const unreadCount = this.getUnreadCount(roomId, user.userId)

      return {
        roomId,
        lastMessage: room?.lastMessage,
        unreadCount
      }
    })

    return roomList
  }

  @SubscribeMessage('createRoom')
  async handleCreateRoom(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: CreateRoomDto
  ): Promise<DMRoomResponse> {
    const creator = client.data.user as JwtPayload

    const roomId = uuid()
    const room: DMRoom = {
      roomId,
      name: data.name,
      participants: [
        {
          userId: creator.userId,
          lastRead: new Date()
        }
      ]
    }

    this.chatRooms.set(roomId, room)
    ;[creator.userId, ...data.participantIds].forEach((userId) => {
      const userRooms = this.userRooms.get(userId) || new Set()
      userRooms.add(roomId)
      this.userRooms.set(userId, userRooms)
    })

    const response: DMRoomResponse = {
      roomId,
      name: data.name,
      participants: [creator.userId, ...data.participantIds],
      createdAt: new Date()
    }

    this.server
      .to(data.participantIds.map((id) => id.toString()))
      .emit('roomCreated', response)

    return response
  }

  @SubscribeMessage('joinRoom')
  async handleJoinRoom(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { roomId: string }
  ) {
    const user = client.data.user as JwtPayload

    await client.join(data.roomId)

    this.server.to(data.roomId).emit('userJoined', {
      roomId: data.roomId,
      user: {
        userId: user.userId,
        nickname: user.nickname,
        profileImgUrl: user.profileImgUrl
      },
      message: `${user.nickname}님이 입장하셨습니다.`
    })
  }

  @SubscribeMessage('message')
  async handleMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { roomId: string; message: string }
  ) {
    const user = client.data.user as JwtPayload
    const messageId = uuid()
    const timestamp = new Date()

    const room = this.chatRooms.get(data.roomId)
    if (!room) return

    room.lastMessage = {
      messageId,
      content: data.message,
      timestamp,
      sender: {
        userId: user.userId,
        username: user.username,
        nickname: user.nickname,
        profileImgUrl: user.profileImgUrl
      }
    }

    room.lastMessage = {
      messageId,
      content: data.message,
      timestamp,
      sender: user
    }

    this.updateReadStatus(data.roomId, user.userId, timestamp)

    this.server.to(data.roomId).emit('message', {
      messageId,
      roomId: data.roomId,
      message: data.message,
      user: {
        userId: user.userId,
        nickname: user.nickname,
        profileImgUrl: user.profileImgUrl
      },
      timestamp
    })
  }

  @SubscribeMessage('markAsRead')
  async handleMarkAsRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { roomId: string }
  ) {
    const user = client.data.user as JwtPayload
    const timestamp = new Date()

    this.updateReadStatus(data.roomId, user.userId, timestamp)

    this.server.to(data.roomId).emit('messageRead', {
      roomId: data.roomId,
      userId: user.userId,
      timestamp
    })
  }

  private updateReadStatus(roomId: string, userId: number, timestamp: Date) {
    const room = this.chatRooms.get(roomId)
    if (!room) return

    const participantIndex = room.participants.findIndex(
      (p) => p.userId === userId
    )
    if (participantIndex === -1) {
      room.participants.push({ userId, lastRead: timestamp })
    } else {
      room.participants[participantIndex].lastRead = timestamp
    }

    this.chatRooms.set(roomId, room)
  }

  private getUnreadCount(roomId: string, userId: number): number {
    const room = this.chatRooms.get(roomId)
    if (!room || !room.lastMessage) return 0

    const participant = room.participants.find((p) => p.userId === userId)
    if (!participant) return 0

    return participant.lastRead < room.lastMessage.timestamp ? 1 : 0
  }
}

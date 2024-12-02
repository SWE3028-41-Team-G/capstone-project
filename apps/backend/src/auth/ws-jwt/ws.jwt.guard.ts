import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common'
import { JwtService } from '@nestjs/jwt'
import { WsException } from '@nestjs/websockets'
import { Socket } from 'socket.io'
import type { JwtPayload } from '../jwt/jwt.interface'

@Injectable()
export class WsJwtGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    try {
      const client: Socket = context.switchToWs().getClient()
      const token = this.extractToken(client)

      if (!token) {
        throw new WsException('토큰이 없습니다')
      }

      const payload = await this.jwtService.verifyAsync<JwtPayload>(token)
      client.data.user = payload

      return true
    } catch (err) {
      throw new WsException('유효하지 않은 토큰입니다')
    }
  }

  private extractToken(client: Socket): string | undefined {
    return client.handshake?.auth?.token
  }
}

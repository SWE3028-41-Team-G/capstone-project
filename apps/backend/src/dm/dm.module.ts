import { Module } from '@nestjs/common'
import { AuthModule } from '@/auth/auth.module'
import { WsJwtGuard } from '@/auth/ws-jwt/ws.jwt.guard'
import { DMGateway } from './dm.gateway'

@Module({
  imports: [AuthModule],
  providers: [DMGateway, WsJwtGuard]
})
export class DmModule {}

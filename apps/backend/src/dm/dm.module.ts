import { Module } from '@nestjs/common'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { JwtModule, type JwtModuleOptions } from '@nestjs/jwt'
import { WsJwtGuard } from '@/auth/ws-jwt/ws.jwt.guard'
import { DMGateway } from './dm.gateway'

@Module({
  imports: [
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (config: ConfigService) => {
        const options: JwtModuleOptions = {
          secret: config.get('JWT_SECRET'),
          signOptions: {
            expiresIn: '60m',
            issuer: 'skku-dm.site'
          }
        }
        return options
      },
      inject: [ConfigService]
    })
  ],
  providers: [DMGateway, WsJwtGuard]
})
export class DmModule {}

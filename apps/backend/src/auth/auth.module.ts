import { Module } from '@nestjs/common'
import { ConfigModule, ConfigService } from '@nestjs/config'
import { JwtModule, JwtService, type JwtModuleOptions } from '@nestjs/jwt'
import { UserModule } from '@/user/user.module'
import { AuthController } from './auth.controller'
import { AuthService } from './auth.service'
import { JwtAuthModule } from './jwt/jwt-auth.module'

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
    }),
    JwtAuthModule,
    UserModule
  ],
  controllers: [AuthController],
  providers: [AuthService],
  exports: [AuthService, JwtService]
})
export class AuthModule {}

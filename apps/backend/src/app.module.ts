import { MailerModule } from '@nestjs-modules/mailer'
import { CacheModule } from '@nestjs/cache-manager'
import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { APP_GUARD } from '@nestjs/core'
import { AppController } from './app.controller'
import { AppService } from './app.service'
import { AuthModule } from './auth/auth.module'
import { JwtAuthGuard } from './auth/jwt/jwt-auth.guard'
import { BoardModule } from './board/board.module'
import { CacheConfigService } from './common/cache/cache-config.service'
import { DmModule } from './dm/dm.module'
import { EmailModule } from './email/email.module'
import { MailerConfigService } from './email/mailer-config.service'
import { MajorModule } from './major/marjor.module'
import { PrismaModule } from './prisma/prisma.module'
import { SquareModule } from './square/square.module'
import { StorageModule } from './storage/storage.module'
import { UserModule } from './user/user.module'
import { ApplyModule } from './apply/apply.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    MailerModule.forRootAsync({
      useClass: MailerConfigService
    }),
    CacheModule.registerAsync({
      isGlobal: true,
      useClass: CacheConfigService
    }),
    AuthModule,
    PrismaModule,
    UserModule,
    EmailModule,
    BoardModule,
    StorageModule,
    SquareModule,
    DmModule,
    MajorModule,
    ApplyModule
  ],
  controllers: [AppController],
  providers: [AppService, { provide: APP_GUARD, useClass: JwtAuthGuard }]
})
export class AppModule {}

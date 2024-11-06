import { Module } from '@nestjs/common'
import { EmailModule } from '../email/email.module'
import { UserService } from './user.service'

@Module({
  imports: [EmailModule],
  controllers: [],
  providers: [UserService],
  exports: [UserService]
})
export class UserModule {}
import {
  Injectable,
  InternalServerErrorException,
  NotFoundException
} from '@nestjs/common'
import { Prisma, type User } from '@prisma/client'
import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  async getUserCredential(username: string): Promise<User> {
    try {
      const user = await this.prisma.user.findUniqueOrThrow({
        where: { username }
      })

      return user
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2025'
      ) {
        throw new NotFoundException('계정정보가 존재하지 않습니다')
      }
      throw new InternalServerErrorException(error)
    }
  }
}

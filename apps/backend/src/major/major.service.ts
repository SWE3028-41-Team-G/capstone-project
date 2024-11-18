import {
  Injectable,
  InternalServerErrorException,
  NotFoundException
} from '@nestjs/common'
import { PrismaService } from '@/prisma/prisma.service'
import { Prisma } from '@prisma/client'

@Injectable()
export class MajorService {
  constructor(private readonly prisma: PrismaService) {}

  async getMajorList() {
    try {
      return await this.prisma.major.findMany({
        select: {
          id: true,
          name: true
        }
      })
    } catch (error) {
      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async getMajor(majorId: number) {
    try {
      return await this.prisma.major.findUniqueOrThrow({
        where: {
          id: majorId
        }
      })
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2025'
      ) {
        throw new NotFoundException('해당 전공이 존재하지 않습니다.')
      }
      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }
}

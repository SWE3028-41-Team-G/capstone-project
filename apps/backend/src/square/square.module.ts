import { Module } from '@nestjs/common'
import { PrismaService } from '../prisma/prisma.service'
import { SquareController } from './square.controller'
import { SquareService } from './square.service'

@Module({
  controllers: [SquareController],
  providers: [SquareService, PrismaService]
})
export class SquareModule {}

import { Module } from '@nestjs/common'
import { PrismaService } from 'src/prisma/prisma.service'
import { BoardController } from './board.controller'
import { BoardService } from './board.service'

@Module({
  providers: [BoardService, PrismaService],
  controllers: [BoardController]
})
export class BoardModule {}

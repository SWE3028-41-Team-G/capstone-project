import { Controller, Post, Body, Param, Get } from '@nestjs/common'
import { SquareService } from './square.service'

@Controller('square')
export class SquareController {
  constructor(private readonly squareService: SquareService) {}

  // Square 및 첫 게시글 생성
  @Post()
  async createSquare(
    @Body()
    createSquareDto: {
      name: string
      leaderId: number
      max: number
      postTitle: string
      postContent: string
    }
  ) {
    return this.squareService.createSquare(createSquareDto)
  }

  // User가 Square에 가입
  @Post(':squareId/join')
  async joinSquare(
    @Param('squareId') squareId: number,
    @Body() joinDto: { userId: number }
  ) {
    return this.squareService.joinSquare(squareId, joinDto.userId)
  }

  // 모든 Square 조회
  @Get()
  async findAllSquares() {
    return this.squareService.findAllSquares()
  }
}

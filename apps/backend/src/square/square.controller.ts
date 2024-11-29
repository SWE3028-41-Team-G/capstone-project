import {
  Controller,
  Post,
  Body,
  Param,
  Get,
  Delete,
  Patch,
  Req
} from '@nestjs/common'
import type { AuthenticatedRequest } from '@/auth/class/authenticated-request.interface'
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

  @Patch(':squareId')
  async updateSquare(
    @Param('squareId') squareId: number,
    @Body()
    updateSquareDto: {
      name?: string
      max?: number
    },
    @Req() req: AuthenticatedRequest
  ) {
    return this.squareService.updateSquare(
      +squareId,
      updateSquareDto,
      req.user.id
    )
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

  // SquarePost에 댓글 추가
  @Post(':postId/comments')
  async addComment(
    @Param('postId') postId: number,
    @Body() commentDto: { userId: number; content: string }
  ) {
    return this.squareService.addComment(postId, commentDto)
  }

  // SquarePost 댓글 삭제
  @Delete('comments/:commentId')
  async deleteComment(@Param('commentId') commentId: number) {
    return this.squareService.deleteComment(commentId)
  }
}

import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Put,
  Delete,
  Patch,
  Query
} from '@nestjs/common'
import { BoardService } from './board.service'

@Controller('board')
export class BoardController {
  constructor(private readonly boardService: BoardService) {}

  @Get()
  async findAll(@Query('tag') tag?: string) {
    return this.boardService.findAll(tag)
  }

  @Get(':id')
  async findOne(@Param('id') id: number) {
    return this.boardService.findOne(+id)
  }

  @Post()
  async create(
    @Body() createPostDto: { title: string; content: string; userId: number }
  ) {
    return this.boardService.create(createPostDto)
  }

  @Put(':id')
  async update(
    @Param('id') id: number,
    @Body() updatePostDto: { title?: string; content?: string }
  ) {
    return this.boardService.update(+id, updatePostDto)
  }

  @Delete(':id')
  async remove(@Param('id') id: number) {
    return this.boardService.remove(+id)
  }

  @Patch(':id/like')
  async incrementLikes(@Param('id') id: number) {
    return this.boardService.incrementLikes(+id)
  }

  @Patch(':id/unlike')
  async decrementLikes(@Param('id') id: number) {
    return this.boardService.decrementLikes(+id)
  }

  @Post(':postId/comment')
  async addComment(
    @Param('postId') postId: number,
    @Body()
    createCommentDto: { userId: number; content: string; parentId?: number }
  ) {
    return this.boardService.addComment(+postId, createCommentDto)
  }

  @Delete('comment/:commentId')
  async removeComment(@Param('commentId') commentId: number) {
    return this.boardService.removeComment(+commentId)
  }
}

import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Put,
  Delete,
  Patch,
  Query,
  ParseArrayPipe
} from '@nestjs/common'
import { BoardService } from './board.service'

@Controller('board')
export class BoardController {
  constructor(private readonly boardService: BoardService) {}

  @Get()
  async findAll(
    @Query('tags', new ParseArrayPipe({ items: String, optional: true }))
    tags?: string[]
  ) {
    return this.boardService.findAll(tags)
  }

  @Get(':id')
  async findOne(@Param('id') id: number) {
    return this.boardService.findOne(+id)
  }

  @Post()
  async create(
    @Body()
    createPostDto: {
      title: string
      content: string
      userId: number
      tags?: string[]
    }
  ) {
    return this.boardService.create(createPostDto)
  }

  @Put(':id')
  async update(
    @Param('id') id: number,
    @Body() updatePostDto: { title?: string; content?: string; tags?: string[] }
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

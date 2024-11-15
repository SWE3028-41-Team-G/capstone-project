import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Put,
  Delete,
  Patch
} from '@nestjs/common'
import { BoardService } from './board.service'

@Controller('board')
export class BoardController {
  constructor(private readonly boardService: BoardService) {}

  @Get()
  async findAll() {
    return this.boardService.findAll()
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
}

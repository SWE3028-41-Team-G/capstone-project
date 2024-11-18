import { Controller, Get, Param, ParseIntPipe } from '@nestjs/common'
import { Public } from '@/common/guard.decorator'
import { MajorService } from './major.service'

@Controller('majors')
export class MajorController {
  constructor(private readonly majorService: MajorService) {}

  @Public()
  @Get()
  async getMajors() {
    return await this.majorService.getMajorList()
  }

  @Get(':majorId')
  async getMajor(@Param('majorId', ParseIntPipe) majorId: number) {
    return await this.majorService.getMajor(majorId)
  }
}

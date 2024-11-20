import { Controller, Post, Body, Delete, Get, Req } from '@nestjs/common'
import type { AuthenticatedRequest } from '@/auth/class/authenticated-request.interface'
import { ApplyService } from './apply.service'

@Controller('apply')
export class ApplyController {
  constructor(private readonly applyService: ApplyService) {}

  // 나의 MockApply 조회 (내 등수 포함)
  @Get()
  async getMockApply(@Req() req: AuthenticatedRequest) {
    return this.applyService.getMockApply(req.user.id)
  }

  // MockApply 생성
  @Post()
  async createMockApply(
    @Body()
    createMockApplyDto: {
      majorId: number
      score: number
    },
    @Req() req: AuthenticatedRequest
  ) {
    return this.applyService.createMockApply(createMockApplyDto, req.user.id)
  }

  // 내 MockApply 삭제
  @Delete()
  async deleteMockApply(@Req() req: AuthenticatedRequest) {
    return this.applyService.deleteMockApply(req.user.id)
  }
}

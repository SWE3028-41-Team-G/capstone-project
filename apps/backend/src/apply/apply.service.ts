import { Injectable, NotFoundException } from '@nestjs/common'
import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class ApplyService {
  constructor(private readonly prisma: PrismaService) {}

  // MockApply 조회
  async getMockApply(userId: number) {
    const mockApply = await this.prisma.mockApply.findUniqueOrThrow({
      where: {
        userId
      }
    })

    const rankings = await this.prisma.mockApply.findMany({
      where: {
        majorId: mockApply.majorId
      },
      select: {
        userId: true,
        score: true
      },
      orderBy: {
        score: 'desc'
      }
    })

    const scoreToRankMap = new Map<number, number>()
    let rank = 1

    rankings.forEach((apply) => {
      if (!scoreToRankMap.has(apply.score)) {
        scoreToRankMap.set(apply.score, rank)
      }
      rank++
    })

    // 점수가 같은 경우 동일한 랭킹 부여
    const userRank = scoreToRankMap.get(mockApply.score)

    return {
      ...mockApply,
      rank: userRank, // 순위
      total: rankings.length // 총 지원자 수
    }
  }

  // MockApply 생성
  async createMockApply(
    data: { majorId: number; score: number },
    userId: number
  ) {
    const { majorId, score } = data

    // 이미 해당 userId로 MockApply가 존재하는지 확인
    const existingApply = await this.prisma.mockApply.findFirst({
      where: { userId }
    })

    if (existingApply) {
      throw new NotFoundException(`User with ID ${userId} has already applied`)
    }

    // 데이터베이스에 MockApply 생성
    return this.prisma.mockApply.create({
      data: {
        userId,
        majorId,
        score
      }
    })
  }

  // MockApply 삭제 (userId 기반)
  async deleteMockApply(userId: number) {
    // userId로 MockApply 존재 여부 확인
    const mockApply = await this.prisma.mockApply.findFirst({
      where: { userId }
    })

    if (!mockApply) {
      throw new NotFoundException(`MockApply for userId ${userId} not found`)
    }

    // 데이터베이스에서 삭제
    return this.prisma.mockApply.delete({
      where: { id: mockApply.id }
    })
  }
}

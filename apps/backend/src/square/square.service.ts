import { Injectable, BadRequestException } from '@nestjs/common'
import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class SquareService {
  constructor(private readonly prisma: PrismaService) {}

  // Square 및 첫 게시글 생성
  async createSquare(data: {
    name: string
    leaderId: number
    max: number
    postTitle: string
    postContent: string
  }) {
    return this.prisma.$transaction(async (tx) => {
      // Square 생성
      const square = await tx.square.create({
        data: {
          name: data.name,
          leaderId: data.leaderId,
          max: data.max
        }
      })

      // SquarePost 생성
      await tx.squarePost.create({
        data: {
          squareId: square.id,
          userId: data.leaderId,
          title: data.postTitle,
          content: data.postContent
        }
      })

      return square
    })
  }

  // User가 Square에 가입
  async joinSquare(squareId: number, userId: number) {
    // Square의 현재 가입된 인원을 확인
    const square = await this.prisma.square.findUnique({
      where: { id: squareId },
      include: { UserSquare: true }
    })

    if (!square) {
      throw new BadRequestException('Square not found')
    }

    // 정원 초과 확인
    if (square.UserSquare.length >= square.max) {
      throw new BadRequestException('Square is full')
    }

    // UserSquare 생성
    return this.prisma.userSquare.create({
      data: {
        squareId,
        userId
      }
    })
  }

  // 모든 Square 조회
  async findAllSquares() {
    return this.prisma.square.findMany({
      include: {
        leader: true, // Square 리더 정보 포함
        UserSquare: {
          include: { user: true } // 가입된 User 정보 포함
        },
        SquarePosts: true // 게시글 정보 포함
      }
    })
  }
}

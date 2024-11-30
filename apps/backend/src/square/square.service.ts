import {
  Injectable,
  BadRequestException,
  NotFoundException,
  ForbiddenException
} from '@nestjs/common'
import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class SquareService {
  constructor(private readonly prisma: PrismaService) {}

  // Square 및 첫 게시글 생성
  async createSquare(data: {
    name: string
    leaderId: number
    majorId: number
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
          max: data.max,
          majorId: data.majorId
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

  // Square와 SquarePost 업데이트
  async updateSquare(
    squareId: number,
    updateSquareDto: {
      name?: string
      max?: number
      majorId?: number
      title?: string
      content?: string
    },
    userId: number
  ) {
    const { name, max, title, content, majorId } = updateSquareDto

    // Square 존재 여부 및 리더 권한 확인
    const square = await this.prisma.square.findUnique({
      where: { id: squareId },
      include: { leader: true }
    })

    if (!square) {
      throw new NotFoundException(`Square with ID ${squareId} not found`)
    }

    if (square.leaderId !== userId) {
      throw new ForbiddenException(
        'You do not have permission to update this square'
      )
    }

    // 트랜잭션을 사용하여 Square와 SquarePost를 원자적으로 업데이트
    return this.prisma.$transaction(async (tx) => {
      // Square 업데이트
      const updatedSquare = await tx.square.update({
        where: { id: squareId },
        data: {
          name: name || undefined,
          max: max || undefined,
          majorId: majorId || undefined
        }
      })

      // SquarePost 업데이트 (최신 게시글을 업데이트한다고 가정)
      if (title || content) {
        const latestPost = await tx.squarePost.findFirst({
          where: { squareId },
          orderBy: { createdAt: 'desc' } // 최신 게시글 기준
        })

        if (latestPost) {
          await tx.squarePost.update({
            where: { id: latestPost.id },
            data: {
              title: title || undefined,
              content: content || undefined
            }
          })
        }
      }

      return updatedSquare
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

  // SquarePost에 댓글 추가
  async addComment(
    postId: number,
    commentDto: { userId: number; content: string }
  ) {
    const { userId, content } = commentDto

    // SquarePost 존재 여부 확인
    const post = await this.prisma.squarePost.findUnique({
      where: { id: postId }
    })
    if (!post) {
      throw new NotFoundException('SquarePost not found')
    }

    // 댓글 생성
    return this.prisma.squarePostComment.create({
      data: {
        squarePostId: postId,
        userId,
        content
      }
    })
  }

  // SquarePost 댓글 삭제
  async deleteComment(commentId: number) {
    // 댓글 존재 여부 확인
    const comment = await this.prisma.squarePostComment.findUnique({
      where: { id: commentId }
    })
    if (!comment) {
      throw new NotFoundException('Comment not found')
    }

    // 댓글 삭제
    return this.prisma.squarePostComment.delete({
      where: { id: commentId }
    })
  }
}

import { Injectable } from '@nestjs/common'
import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class BoardService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(tag?: string) {
    const whereCondition = tag
      ? {
          tags: {
            some: {
              name: tag // 태그 이름과 일치하는 조건
            }
          }
        }
      : {}

    return this.prisma.post.findMany({
      where: whereCondition,
      include: {
        tags: true,
        Comment: true,
        user: true // 작성자 정보 포함
      }
    })
  }

  async findOne(id: number) {
    return this.prisma.post.findUnique({
      where: { id },
      include: {
        tags: true,
        Comment: true,
        user: true
      }
    })
  }

  async create(data: { title: string; content: string; userId: number }) {
    return this.prisma.post.create({
      data: {
        title: data.title,
        content: data.content,
        userId: data.userId
      }
    })
  }

  async update(id: number, data: { title?: string; content?: string }) {
    return this.prisma.post.update({
      where: { id },
      data
    })
  }

  async remove(id: number) {
    return this.prisma.post.delete({
      where: { id }
    })
  }

  async incrementLikes(id: number) {
    return this.prisma.post.update({
      where: { id },
      data: {
        likes: { increment: 1 }
      }
    })
  }

  async decrementLikes(id: number) {
    return this.prisma.post.update({
      where: { id },
      data: {
        likes: { decrement: 1 }
      }
    })
  }

  async addComment(
    postId: number,
    data: { userId: number; content: string; parentId?: number }
  ) {
    return this.prisma.comment.create({
      data: {
        postId,
        userId: data.userId,
        content: data.content,
        parentId: data.parentId || null
      }
    })
  }

  async removeComment(commentId: number) {
    return this.prisma.comment.delete({
      where: { id: commentId }
    })
  }
}

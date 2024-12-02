import { Injectable } from '@nestjs/common'
import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class BoardService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(tags?: string[]) {
    return this.prisma.post.findMany({
      where: tags?.length
        ? {
            tags: {
              hasSome: tags,
            },
          }
        : undefined,
      include: {
        Comment: true,
        user: true,
      },
    });
  }

  async findOne(id: number) {
    return this.prisma.post.findUnique({
      where: { id },
      include: {
        Comment: true,
        user: true
      }
    })
  }

  async create(data: {
    title: string
    content: string
    userId: number
    tags?: string[]
  }) {
    return this.prisma.post.create({
      data: {
        title: data.title,
        content: data.content,
        userId: data.userId,
        tags: data.tags ?? []
      }
    })
  }

  async update(
    id: number,
    data: { title?: string; content?: string; tags?: string[] }
  ) {
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

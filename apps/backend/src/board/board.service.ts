import { Injectable } from '@nestjs/common'
import { PrismaService } from '../prisma/prisma.service'

@Injectable()
export class BoardService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll() {
    return this.prisma.post.findMany({
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
}

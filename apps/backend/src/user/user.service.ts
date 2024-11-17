import { CACHE_MANAGER } from '@nestjs/cache-manager'
import {
  BadRequestException,
  ConflictException,
  HttpException,
  Inject,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
  UnprocessableEntityException
} from '@nestjs/common'
import { emailAuthenticationPinCacheKey } from '@/common/cache/keys'
import { EmailService } from '@/email/email.service'
import { PrismaService } from '@/prisma/prisma.service'
import { StorageService } from '@/storage/storage.service'
import { Prisma, type User } from '@prisma/client'
import { hash } from 'argon2'
import { Cache } from 'cache-manager'
import { CreateUserDTO } from './dto/create-user.dto'

@Injectable()
export class UserService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly emailService: EmailService,
    private readonly storageService: StorageService,
    @Inject(CACHE_MANAGER) private readonly cacheManager: Cache
  ) {}

  async uploadProfile(image: Express.Multer.File): Promise<{ url: string }> {
    try {
      const result = await this.storageService.uploadObject(
        image,
        'temp-profile'
      )

      // Production 기준으로 작성
      return { url: `https://cdn.skku-dm.site/${result.src}` }
    } catch (error) {
      if (error instanceof HttpException) throw error

      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async getUserCredential(username: string): Promise<User> {
    try {
      const user = await this.prisma.user.findUniqueOrThrow({
        where: { username }
      })

      return user
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2025'
      ) {
        throw new NotFoundException('계정정보가 존재하지 않습니다')
      }
      throw new InternalServerErrorException(error)
    }
  }

  async verifyEmail(email: string, pin: string): Promise<{ verify: boolean }> {
    try {
      const realPin = await this.cacheManager.get(
        emailAuthenticationPinCacheKey(email)
      )

      const valid = pin === realPin

      return {
        verify: valid
      }
    } catch (error) {
      throw new InternalServerErrorException(error)
    }
  }

  async requestEmailVerify(email: string): Promise<void> {
    try {
      if (!this.isValidDomain(email))
        throw new BadRequestException('성균관대학교 이메일이 아닙니다')

      const pin = this.generatePin()
      await this.emailService.sendEmailAuthenticationPin(email, pin)
      await this.cacheManager.set(emailAuthenticationPinCacheKey(email), pin)
    } catch (error) {
      if (error instanceof HttpException) throw error

      throw new InternalServerErrorException(error)
    }
  }

  async createUser(userDTO: CreateUserDTO, pin: string): Promise<void> {
    try {
      const { verify } = await this.verifyEmail(userDTO.email, pin)

      if (!verify)
        throw new UnprocessableEntityException(
          '이메일 인증 정보가 유효하지 않습니다'
        )

      const user = await this.prisma.user.create({
        data: {
          username: userDTO.username,
          password: await hash(userDTO.password),
          nickname: userDTO.nickname,
          email: userDTO.email,
          admitYear: userDTO.admitYear,
          real: userDTO.real,
          UserMajor: {
            create: {
              majorId: userDTO.majorId,
              origin: true
            }
          },
          Profile: {
            create: {
              public: userDTO.public,
              imageUrl: userDTO.profileImageUrl,
              intro: userDTO.intro,
              interests: userDTO.interests
            }
          }
        },
        select: { id: true }
      })

      if (userDTO.dualMajorId) {
        await this.prisma.userMajor.create({
          data: {
            majorId: userDTO.dualMajorId,
            origin: false,
            userId: user.id
          }
        })
      }
    } catch (error) {
      if (error instanceof HttpException) throw error
      if (error instanceof Prisma.PrismaClientKnownRequestError) {
        if (error.code === 'P2002') {
          throw new ConflictException('닉네임이나 이메일이 이미 존재합니다')
        }
        if (error.code === 'P2003') {
          throw new NotFoundException('해당 전공이 존재하지 않습니다')
        }
      }

      throw new InternalServerErrorException(error)
    }
  }

  private generatePin(): string {
    const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    let pin = ''

    for (let i = 0; i < 6; i++) {
      const randomIndex = Math.floor(Math.random() * characters.length)
      pin += characters.charAt(randomIndex)
    }

    return pin
  }

  private isValidDomain(email: string): boolean {
    return email.endsWith('@skku.edu') || email.endsWith('@g.skku.edu')
  }
}

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
import { Prisma, type Profile, type User } from '@prisma/client'
import { hash } from 'argon2'
import { Cache } from 'cache-manager'
import { CreateUserDTO } from './dto/create-user.dto'
import type { UpdateProfileDTO } from './dto/update-profile.dto'

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

  async updateProfileImage(
    image: Express.Multer.File,
    userId: number
  ): Promise<{ url: string }> {
    try {
      const profile = await this.prisma.profile.findUniqueOrThrow({
        where: {
          userId
        },
        select: {
          imageUrl: true
        }
      })

      await this.storageService.deleteObject(profile.imageUrl)

      const result = await this.storageService.uploadObject(
        image,
        `profile/${userId}`
      )

      const newUrl = `https://cdn.skku-dm.site/${result.src}`

      await this.prisma.user.update({
        where: {
          id: userId
        },
        data: {
          Profile: {
            update: {
              imageUrl: newUrl
            }
          }
        }
      })

      return { url: newUrl }
    } catch (error) {
      if (error instanceof HttpException) throw error
      if (error instanceof Prisma.PrismaClientKnownRequestError) {
        throw new NotFoundException('존재하지 않는 계정입니다.')
      }

      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async getProfile(userId: number, requestUserId: number) {
    try {
      const profile = await this.prisma.profile.findUniqueOrThrow({
        where: {
          userId
        },
        select: {
          public: true,
          imageUrl: true,
          intro: true,
          interests: true
        }
      })

      // 비공개 프로필을 다른 계정이 조회할 경우
      if (requestUserId !== userId && !profile.public) {
        return null
      }

      const user = await this.prisma.user.findUniqueOrThrow({
        where: {
          id: userId
        },
        select: {
          admitYear: true,
          username: true,
          nickname: true,
          real: true
        }
      })

      const majors = await this.prisma.userMajor.findMany({
        where: {
          userId
        },
        select: {
          origin: true,
          Major: {
            select: {
              id: true,
              name: true
            }
          }
        }
      })

      return {
        ...user,
        ...profile,
        majors,
        userId
      }
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2025'
      ) {
        throw new NotFoundException('존재하지 않는 계정입니다.')
      }

      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async getUserProfilesByMajors(majorId?: number, dualMajorId?: number) {
    try {
      const majorIds = [majorId, dualMajorId].filter((id) => id !== undefined)

      const users = await this.prisma.user.findMany({
        where: {
          Profile: {
            public: true
          },
          ...(majorIds.length > 0 && {
            UserMajor: {
              some: {
                majorId: {
                  in: majorIds
                }
              }
            }
          })
        },
        select: {
          id: true,
          admitYear: true,
          username: true,
          nickname: true,
          real: true,
          Profile: {
            select: {
              public: true,
              imageUrl: true,
              intro: true,
              interests: true
            }
          },
          UserMajor: {
            select: {
              origin: true,
              Major: {
                select: {
                  id: true,
                  name: true
                }
              }
            }
          }
        },
        take: 12
      })

      return users.map((user) => {
        return {
          majors: [...user.UserMajor],
          userId: user.id,
          imageUrl: user.Profile.imageUrl,
          interests: user.Profile.interests,
          public: user.Profile.public,
          username: user.username,
          nickname: user.nickname,
          adminYear: user.admitYear,
          real: user.real
        }
      })
    } catch (error) {
      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async getRelatedUserProfiles(userId: number) {
    try {
      const user = await this.prisma.user.findUniqueOrThrow({
        where: {
          id: userId
        },
        select: {
          Profile: {
            select: {
              public: true,
              interests: true
            }
          },
          UserMajor: {
            select: {
              majorId: true
            }
          }
        }
      })

      const users = await this.prisma.user.findMany({
        where: {
          Profile: {
            public: true
          },
          OR: [
            {
              UserMajor: {
                some: {
                  majorId: {
                    in: user.UserMajor.map((item) => item.majorId)
                  }
                }
              }
            },
            {
              Profile: {
                interests: {
                  hasSome: user.Profile.interests
                }
              }
            }
          ]
        },
        select: {
          id: true,
          admitYear: true,
          username: true,
          nickname: true,
          real: true,
          Profile: {
            select: {
              public: true,
              imageUrl: true,
              intro: true,
              interests: true
            }
          },
          UserMajor: {
            select: {
              origin: true,
              Major: {
                select: {
                  id: true,
                  name: true
                }
              }
            }
          }
        },
        take: 12
      })

      return users.map((user) => {
        return {
          majors: [...user.UserMajor],
          userId: user.id,
          imageUrl: user.Profile.imageUrl,
          interests: user.Profile.interests,
          public: user.Profile.public,
          username: user.username,
          nickname: user.nickname,
          adminYear: user.admitYear,
          real: user.real
        }
      })
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2025'
      ) {
        throw new NotFoundException('존재하지 않는 계정입니다.')
      }

      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async updateProfile(userDTO: UpdateProfileDTO, userId: number) {
    try {
      await this.prisma.user.update({
        where: {
          id: userId
        },
        data: {
          real: userDTO.real,
          nickname: userDTO.nickname,
          Profile: {
            update: {
              interests: userDTO.interests,
              public: userDTO.public
            }
          }
        }
      })

      if (!userDTO.majorId && !userDTO.dualMajorId) return

      const majors = await this.prisma.userMajor.findMany({
        where: {
          userId
        }
      })

      if (userDTO.majorId) {
        const majorId = majors.filter((major) => major.origin)[0].majorId

        await this.prisma.userMajor.update({
          where: {
            userId_majorId: {
              userId,
              majorId
            }
          },
          data: {
            majorId: userDTO.majorId
          }
        })
      }

      if (userDTO.dualMajorId) {
        const majorId = majors.filter((major) => !major.origin)[0].majorId

        await this.prisma.userMajor.upsert({
          where: {
            userId_majorId: {
              userId,
              majorId
            }
          },
          update: {
            majorId: userDTO.dualMajorId
          },
          create: {
            origin: false,
            userId,
            majorId: userDTO.dualMajorId
          }
        })
      }
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError) {
        if (error.code === 'P2025')
          throw new BadRequestException('존재하지 않는 계정입니다.')

        if (error.code === 'P2002' || error.code === 'P2003')
          throw new NotFoundException('존재하지 않는 전공입니다.')
      }

      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async getUserCredential(
    username: string
  ): Promise<User & { Profile: Partial<Profile> }> {
    try {
      const user = await this.prisma.user.findUniqueOrThrow({
        where: { username },
        include: {
          Profile: {
            select: {
              imageUrl: true
            }
          }
        }
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
              imageUrl:
                userDTO.profileImageUrl ??
                'https://cdn.skku-dm.site/default.jpeg',
              intro: '',
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
      console.log(error)
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

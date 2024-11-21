/* eslint-disable @typescript-eslint/no-unused-vars */
import { CACHE_MANAGER } from '@nestjs/cache-manager'
import { BadRequestException, NotFoundException } from '@nestjs/common'
import { Test } from '@nestjs/testing'
import { EmailService } from '@/email/email.service'
import { PrismaService } from '@/prisma/prisma.service'
import { StorageService } from '@/storage/storage.service'
import { Prisma } from '@prisma/client'
import { hash } from 'argon2'
import { Cache } from 'cache-manager'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { UserService } from './user.service'

vi.mock('argon2', () => ({
  hash: vi.fn().mockImplementation((pwd) => Promise.resolve(`hashed_${pwd}`))
}))

describe('UserService', () => {
  let userService: UserService
  let prismaService: PrismaService
  let emailService: EmailService
  let storageService: StorageService
  let cacheManager: Cache

  const mockPrismaService = {
    user: {
      findUniqueOrThrow: vi.fn(),
      findMany: vi.fn(),
      create: vi.fn(),
      update: vi.fn()
    },
    profile: {
      findUniqueOrThrow: vi.fn()
    },
    userMajor: {
      findMany: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      upsert: vi.fn()
    }
  }

  const mockEmailService = {
    sendEmailAuthenticationPin: vi.fn()
  }

  const mockStorageService = {
    uploadObject: vi.fn(),
    deleteObject: vi.fn()
  }

  const mockCacheManager = {
    get: vi.fn(),
    set: vi.fn()
  }

  beforeEach(async () => {
    const moduleRef = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: PrismaService,
          useValue: mockPrismaService
        },
        {
          provide: EmailService,
          useValue: mockEmailService
        },
        {
          provide: StorageService,
          useValue: mockStorageService
        },
        {
          provide: CACHE_MANAGER,
          useValue: mockCacheManager
        }
      ]
    }).compile()

    userService = moduleRef.get<UserService>(UserService)
    prismaService = moduleRef.get<PrismaService>(PrismaService)
    emailService = moduleRef.get<EmailService>(EmailService)
    storageService = moduleRef.get<StorageService>(StorageService)
    cacheManager = moduleRef.get<Cache>(CACHE_MANAGER)

    // Reset all mocks before each test
    vi.clearAllMocks()
  })

  describe('uploadProfile', () => {
    it('should upload profile image successfully', async () => {
      const mockFile = { buffer: Buffer.from('test') } as Express.Multer.File
      const mockResult = { src: 'test-image.jpg' }

      mockStorageService.uploadObject.mockResolvedValue(mockResult)

      const result = await userService.uploadProfile(mockFile)

      expect(storageService.uploadObject).toHaveBeenCalledWith(
        mockFile,
        'temp-profile'
      )
      expect(result).toEqual({
        url: `https://cdn.skku-dm.site/${mockResult.src}`
      })
    })
  })

  describe('updateProfileImage', () => {
    it('should update profile image successfully', async () => {
      const mockFile = { buffer: Buffer.from('test') } as Express.Multer.File
      const userId = 1
      const oldImageUrl = 'old-image.jpg'
      const mockResult = { src: 'new-image.jpg' }

      mockPrismaService.profile.findUniqueOrThrow.mockResolvedValue({
        imageUrl: oldImageUrl
      })
      mockStorageService.uploadObject.mockResolvedValue(mockResult)

      const result = await userService.updateProfileImage(mockFile, userId)

      expect(prismaService.profile.findUniqueOrThrow).toHaveBeenCalledWith({
        where: { userId },
        select: {
          imageUrl: true
        }
      })
      expect(storageService.deleteObject).toHaveBeenCalledWith(oldImageUrl)
      expect(storageService.uploadObject).toHaveBeenCalledWith(
        mockFile,
        `profile/${userId}`
      )
      expect(result).toEqual({
        url: `https://cdn.skku-dm.site/${mockResult.src}`
      })
    })

    it('should throw NotFoundException when user not found', async () => {
      const mockFile = { buffer: Buffer.from('test') } as Express.Multer.File
      const userId = 1

      mockPrismaService.profile.findUniqueOrThrow.mockRejectedValue(
        new Prisma.PrismaClientKnownRequestError('Not found', {
          code: 'P2025',
          clientVersion: '2.0.0'
        })
      )

      await expect(
        userService.updateProfileImage(mockFile, userId)
      ).rejects.toThrow(NotFoundException)
    })
  })

  describe('getProfile', () => {
    it('should return profile when public or same user', async () => {
      const userId = 1
      const requestUserId = 1

      mockPrismaService.profile.findUniqueOrThrow.mockResolvedValue({
        public: true,
        imageUrl: 'image.jpg',
        intro: 'intro',
        interests: ['coding']
      })

      mockPrismaService.user.findUniqueOrThrow.mockResolvedValue({
        admitYear: 2024,
        username: 'test',
        nickname: 'test',
        real: true
      })

      mockPrismaService.userMajor.findMany.mockResolvedValue([
        {
          origin: true,
          Major: {
            id: 1,
            name: 'Computer Science'
          }
        }
      ])

      const result = await userService.getProfile(userId, requestUserId)

      expect(prismaService.profile.findUniqueOrThrow).toHaveBeenCalledWith({
        where: { userId },
        select: {
          public: true,
          imageUrl: true,
          intro: true,
          interests: true
        }
      })
      expect(result).toMatchObject({
        admitYear: 2024,
        username: 'test',
        nickname: 'test',
        public: true
      })
    })
  })

  describe('createUser', () => {
    it('should create user successfully', async () => {
      const userDTO = {
        username: 'test',
        password: 'password',
        nickname: 'test',
        email: 'test@skku.edu',
        public: true,
        intro: 'intro',
        admitYear: 2024,
        interests: ['coding'],
        majorId: 1,
        real: true,
        profileImageUrl: 'image.jpg'
      }
      const pin = '123456'

      mockCacheManager.get.mockResolvedValue(pin)
      mockPrismaService.user.create.mockResolvedValue({ id: 1 })

      await userService.createUser(userDTO, pin)

      expect(hash).toHaveBeenCalledWith(userDTO.password)
      expect(prismaService.user.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          username: userDTO.username,
          email: userDTO.email
        }),
        select: { id: true }
      })
    })

    it('should throw BadRequestException for invalid email domain', async () => {
      const email = 'test@invalid.com'

      await expect(userService.requestEmailVerify(email)).rejects.toThrow(
        BadRequestException
      )
    })
  })

  describe('verifyEmail', () => {
    it('should verify email successfully when pin matches', async () => {
      const email = 'test@skku.edu'
      const pin = '123456'

      mockCacheManager.get.mockResolvedValue(pin)

      const result = await userService.verifyEmail(email, pin)

      expect(result).toEqual({ verify: true })
    })

    it('should return false when pin does not match', async () => {
      const email = 'test@skku.edu'
      const pin = '123456'
      const wrongPin = '654321'

      mockCacheManager.get.mockResolvedValue(wrongPin)

      const result = await userService.verifyEmail(email, pin)

      expect(result).toEqual({ verify: false })
    })
  })
})

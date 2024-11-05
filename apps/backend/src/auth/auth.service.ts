import { CACHE_MANAGER } from '@nestjs/cache-manager'
import { Inject, Injectable, UnauthorizedException } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { JwtService, type JwtVerifyOptions } from '@nestjs/jwt'
import { Cache } from 'cache-manager'
import {
  ACCESS_TOKEN_EXPIRE_TIME,
  REFRESH_TOKEN_EXPIRE_TIME
} from 'src/common/costants'
import { refreshTokenCacheKey } from '../common/cache/keys'
import { UserService } from '../user/user.service'
import { LoginUserDto } from './dto/login-user.dto'
import { JwtAuthService } from './jwt/jwt-auth.service'
import type { JwtPayload } from './jwt/jwt.interface'

@Injectable()
export class AuthService {
  constructor(
    private readonly config: ConfigService,
    private readonly jwtService: JwtService,
    private readonly jwtAuthService: JwtAuthService,
    private readonly userService: UserService,
    @Inject(CACHE_MANAGER) private readonly cacheManager: Cache
  ) {}

  async issueJwtTokens(loginUserDto: LoginUserDto) {
    const user = await this.userService.getUserCredential(loginUserDto.username)

    if (!user) {
      throw new UnauthorizedException(
        '아이디 또는 비밀번호가 일치하지 않습니다'
      )
    }

    const isValidUser = await this.jwtAuthService.isValidUser(
      user,
      loginUserDto.password
    )

    if (!isValidUser) {
      throw new UnauthorizedException(
        '아이디 또는 비밀번호가 일치하지 않습니다'
      )
    }

    return await this.createJwtTokens(user.id, user.username)
  }

  async updateJwtTokens(refreshToken: string) {
    const { userId, username } = await this.verifyJwtToken(refreshToken)
    if (!(await this.isValidRefreshToken(refreshToken, userId))) {
      throw new UnauthorizedException('Unidentified refresh token')
    }
    return await this.createJwtTokens(userId, username)
  }

  async verifyJwtToken(token: string, options: JwtVerifyOptions = {}) {
    const jwtVerifyOptions = {
      secret: this.config.get('JWT_SECRET'),
      ...options
    }
    try {
      return await this.jwtService.verifyAsync(token, jwtVerifyOptions)
    } catch (error) {
      throw new UnauthorizedException(error.message)
    }
  }

  async isValidRefreshToken(refreshToken: string, userId: number) {
    const cachedRefreshToken = await this.cacheManager.get(
      refreshTokenCacheKey(userId)
    )
    if (cachedRefreshToken !== refreshToken) {
      return false
    }
    return true
  }

  async createJwtTokens(userId: number, username: string) {
    const payload: JwtPayload = { userId, username }
    const accessToken = await this.jwtService.signAsync(payload, {
      expiresIn: ACCESS_TOKEN_EXPIRE_TIME
    })
    const refreshToken = await this.jwtService.signAsync(payload, {
      expiresIn: REFRESH_TOKEN_EXPIRE_TIME
    })

    await this.cacheManager.set(
      refreshTokenCacheKey(userId),
      refreshToken,
      REFRESH_TOKEN_EXPIRE_TIME * 1000 // milliseconds
    )

    return { accessToken, refreshToken }
  }

  async deleteRefreshToken(userId: number) {
    return await this.cacheManager.del(refreshTokenCacheKey(userId))
  }
}

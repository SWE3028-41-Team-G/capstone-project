import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  Res,
  UnauthorizedException
} from '@nestjs/common'
import type { Request, Response } from 'express'
import { REFRESH_TOKEN_COOKIE_OPTIONS } from 'src/common/costants'
import { Public } from '../common/guard.decorator'
import { AuthService } from './auth.service'
import { AuthenticatedRequest } from './class/authenticated-request.interface'
import { LoginUserDto } from './dto/login-user.dto'
import type { JwtTokens } from './jwt/jwt.interface'

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  setJwtResponse = (res: Response, jwtTokens: JwtTokens) => {
    res.setHeader('authorization', `Bearer ${jwtTokens.accessToken}`)
    res.cookie(
      'refresh_token',
      jwtTokens.refreshToken,
      REFRESH_TOKEN_COOKIE_OPTIONS
    )
  }

  @Public()
  @Post('login')
  async login(
    @Body() loginUserDto: LoginUserDto,
    @Res({ passthrough: true }) res: Response
  ) {
    try {
      const jwtTokens = await this.authService.issueJwtTokens(loginUserDto)
      this.setJwtResponse(res, jwtTokens)
    } catch (error) {
      throw error
    }
  }

  @Post('logout')
  async logout(
    @Req() req: AuthenticatedRequest,
    @Res({ passthrough: true }) res: Response
  ) {
    try {
      await this.authService.deleteRefreshToken(req.user.id)
      res.clearCookie('refresh_token', REFRESH_TOKEN_COOKIE_OPTIONS)
    } catch (error) {
      throw error
    }
  }

  @Public()
  @Get('reissue')
  async reIssueJwtTokens(
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response
  ) {
    const refreshToken = req.cookies['refresh_token']
    if (!refreshToken) throw new UnauthorizedException('Invalid Token')

    try {
      const newJwtTokens = await this.authService.updateJwtTokens(refreshToken)
      this.setJwtResponse(res, newJwtTokens)
    } catch (error) {
      throw error
    }
  }
}

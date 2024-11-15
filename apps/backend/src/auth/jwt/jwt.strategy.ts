import { Injectable } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import { PassportStrategy } from '@nestjs/passport'
import { ExtractJwt } from 'passport-jwt'
import { Strategy } from 'passport-jwt'
import { AuthenticatedUser } from '../class/authenticated-user.class'
import type { JwtObject } from './jwt.interface'

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(readonly config: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: 'asdfsdf'
    })
  }

  async validate(payload: JwtObject): Promise<AuthenticatedUser> {
    return new AuthenticatedUser(payload.userId, payload.username)
  }
}

export interface JwtPayload {
  userId: number
  username: string
  nickname: string
  profileImgUrl?: string
}

export interface JwtObject extends JwtPayload {
  iat: number
  exp: number
  iss: string
}

export interface JwtTokens {
  accessToken: string
  refreshToken: string
}

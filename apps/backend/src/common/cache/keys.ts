export const emailAuthenticationPinCacheKey = (email: string) =>
  `email:${email}:email-auth`

export const refreshTokenCacheKey = (userId: number) =>
  `user:${userId}:refresh_token`

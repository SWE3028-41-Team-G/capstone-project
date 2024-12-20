const SECONDS_PER_MINUTE = 60
const SECONDS_PER_HOUR = 60 * SECONDS_PER_MINUTE
const SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR

/** JWT Token Expiration Settings */
export const ACCESS_TOKEN_EXPIRE_TIME = SECONDS_PER_HOUR
export const REFRESH_TOKEN_EXPIRE_TIME = SECONDS_PER_DAY
export const REFRESH_TOKEN_COOKIE_OPTIONS = {
  maxAge: 1000 * SECONDS_PER_DAY * 7,
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  path:
    process.env.NODE_ENV === 'production'
      ? '/api/auth/reissue'
      : '/auth/reissue'
}

export const IMAGE_SIZE_LIMIT = 10 * 1024 * 1024 // 10mb

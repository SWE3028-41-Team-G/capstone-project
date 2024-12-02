import { Role } from '@prisma/client'

export class AuthenticatedUser {
  #id: number
  #username: string
  #nickname: string
  #profileImgUrl?: string
  #role: Role

  constructor(
    id: number,
    username: string,
    nickname: string,
    profileImgUrl?: string
  ) {
    this.#id = id
    this.#username = username
    this.#nickname = nickname
    this.#profileImgUrl = profileImgUrl
  }

  get id() {
    return this.#id
  }

  get username() {
    return this.#username
  }

  get role() {
    return this.#role
  }

  set role(role) {
    this.#role = role
  }

  isAdmin(): boolean {
    return this.#role === Role.Admin
  }
}

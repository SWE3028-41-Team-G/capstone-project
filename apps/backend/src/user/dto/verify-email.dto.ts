import { IsEmail, IsNotEmpty, IsString } from 'class-validator'

export class RequestVerifyEmailDTO {
  @IsEmail()
  @IsNotEmpty()
  email: string
}

export class VerifyEmailDTO extends RequestVerifyEmailDTO {
  @IsString()
  @IsNotEmpty()
  pin: string
}

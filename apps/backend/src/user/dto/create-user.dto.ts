import {
  IsArray,
  IsBoolean,
  IsEmail,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  Min
} from 'class-validator'

export class CreateUserDTO {
  @IsString()
  @IsNotEmpty()
  username: string

  @IsString()
  @IsNotEmpty()
  password: string

  @IsString()
  @IsNotEmpty()
  nickname: string

  @IsEmail()
  @IsNotEmpty()
  email: string

  @IsBoolean()
  @IsNotEmpty()
  public: boolean

  @Min(1957)
  @Max(new Date().getFullYear())
  @IsNumber()
  @IsNotEmpty()
  admitYear: number

  @IsArray()
  @IsString({ each: true })
  interests: string[]

  @IsNumber()
  @IsNotEmpty()
  majorId: number

  @IsBoolean()
  @IsNotEmpty()
  real: boolean

  @IsNumber()
  @IsOptional()
  dualMajorId?: number

  @IsString()
  @IsOptional()
  profileImageUrl?: string
}

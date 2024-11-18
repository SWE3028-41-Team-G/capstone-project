import {
  IsArray,
  IsBoolean,
  IsNumber,
  IsOptional,
  IsString
} from 'class-validator'

export class UpdateProfileDTO {
  @IsBoolean()
  @IsOptional()
  public?: boolean

  @IsString()
  @IsOptional()
  intro?: string

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  interests?: string[]

  @IsBoolean()
  @IsOptional()
  real?: boolean

  @IsNumber()
  @IsOptional()
  majorId?: number

  @IsNumber()
  @IsOptional()
  dualMajorId?: number

  @IsString()
  @IsOptional()
  nickname?: string
}

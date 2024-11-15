import {
  BadRequestException,
  Body,
  Controller,
  Post,
  Query,
  UploadedFile,
  UseInterceptors
} from '@nestjs/common'
import { FileInterceptor } from '@nestjs/platform-express'
import { Public } from '@/common/guard.decorator'
import { IMAGE_OPTIONS } from '@/storage/options/image-options'
import { CreateUserDTO } from './dto/create-user.dto'
import { RequestVerifyEmailDTO, VerifyEmailDTO } from './dto/verify-email.dto'
import { UserService } from './user.service'

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Public()
  @Post('profile')
  @UseInterceptors(FileInterceptor('image', IMAGE_OPTIONS))
  async uploadProfile(
    @UploadedFile() image: Express.Multer.File
  ): Promise<{ url: string }> {
    if (!image) {
      throw new BadRequestException('이미지가 없습니다')
    }

    return await this.userService.uploadProfile(image)
  }

  @Public()
  @Post('verify-email/request')
  async requestVerifyEmail(
    @Body() userDTO: RequestVerifyEmailDTO
  ): Promise<void> {
    return await this.userService.requestEmailVerify(userDTO.email)
  }

  @Public()
  @Post('verify-email')
  async verifyEmail(
    @Body() userDTO: VerifyEmailDTO
  ): Promise<{ verify: boolean }> {
    return await this.userService.verifyEmail(userDTO.email, userDTO.pin)
  }

  @Public()
  @Post('register')
  async registerUser(
    @Body() userDTO: CreateUserDTO,
    @Query('pin') pin: string
  ): Promise<void> {
    return await this.userService.createUser(userDTO, pin)
  }
}

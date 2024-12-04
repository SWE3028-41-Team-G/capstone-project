import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Query,
  Req,
  UploadedFile,
  UseInterceptors
} from '@nestjs/common'
import { FileInterceptor } from '@nestjs/platform-express'
import type { AuthenticatedRequest } from '@/auth/class/authenticated-request.interface'
import { Public } from '@/common/guard.decorator'
import { IMAGE_OPTIONS } from '@/storage/options/image-options'
import { CreateUserDTO } from './dto/create-user.dto'
import type { UpdateProfileDTO } from './dto/update-profile.dto'
import { RequestVerifyEmailDTO, VerifyEmailDTO } from './dto/verify-email.dto'
import { UserService } from './user.service'

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Public()
  @Post('profile/image')
  @UseInterceptors(FileInterceptor('image', IMAGE_OPTIONS))
  async uploadProfile(
    @UploadedFile() image: Express.Multer.File
  ): Promise<{ url: string }> {
    if (!image) {
      throw new BadRequestException('이미지가 없습니다')
    }

    return await this.userService.uploadProfile(image)
  }

  @Put('profile/image')
  @UseInterceptors(FileInterceptor('image', IMAGE_OPTIONS))
  async updateProfileImage(
    @UploadedFile() image: Express.Multer.File,
    @Req() req: AuthenticatedRequest
  ) {
    if (!image) {
      throw new BadRequestException('이미지가 없습니다')
    }

    return await this.userService.updateProfileImage(image, req.user.id)
  }

  @Get('current/profile')
  async getCurrentUserProfile(@Req() req: AuthenticatedRequest) {
    return await this.userService.getProfile(req.user.id, req.user.id)
  }

  @Get('related/profiles')
  async getSimillarUserProfile(@Req() req: AuthenticatedRequest) {
    return await this.userService.getRelatedUserProfiles(req.user.id)
  }

  @Get('majors/profiles')
  async getUserProfilesByMajors(
    @Query('majorId', new ParseIntPipe({ optional: true })) majorId?: number,
    @Query('dualMajorId', new ParseIntPipe({ optional: true }))
    dualMajorId?: number
  ) {
    return await this.userService.getUserProfilesByMajors(majorId, dualMajorId)
  }

  @Put('profile')
  async updateCurrentUserProfile(
    @Body() userDTO: UpdateProfileDTO,
    @Req() req: AuthenticatedRequest
  ) {
    return await this.userService.updateProfile(userDTO, req.user.id)
  }

  @Get(':userId/profile')
  async getUserProfile(
    @Param('userId', ParseIntPipe) userId: number,
    @Req() req: AuthenticatedRequest
  ) {
    return await this.userService.getProfile(userId, req.user.id)
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

import { Controller, Get } from '@nestjs/common'
import { AppService } from './app.service'
import { Public } from './common/guard.decorator'
import { EmailService } from './email/email.service'

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly email: EmailService
  ) {}

  @Public()
  @Get()
  getHello(): string {
    return this.appService.getHello()
  }

  @Public()
  @Get('/test')
  async emailTest() {
    await this.email.sendEmailAuthenticationPin(
      'idpjs2000@g.skku.edu',
      '123456'
    )

    return 'ok'
  }
}

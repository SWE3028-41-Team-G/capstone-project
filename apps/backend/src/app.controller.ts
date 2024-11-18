import { Controller, Get, Render } from '@nestjs/common'
import { AppService } from './app.service'
import { Public } from './common/guard.decorator'

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Public()
  @Get()
  @Render('index')
  renderRendingPage() {
    return {
      title: 'SKKU-DM'
    }
  }

  @Public()
  @Get('/health-check')
  healthCheck(): string {
    return this.appService.healthCheck()
  }
}

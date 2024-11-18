import { Controller, Get } from '@nestjs/common'
import { AppService } from './app.service'
import { Public } from './common/guard.decorator'

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Public()
  @Get('/health-check')
  healthCheck(): string {
    return this.appService.healthCheck()
  }
}

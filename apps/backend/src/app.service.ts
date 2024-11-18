import { Injectable } from '@nestjs/common'

@Injectable()
export class AppService {
  healthCheck(): string {
    return 'servier is running'
  }
}

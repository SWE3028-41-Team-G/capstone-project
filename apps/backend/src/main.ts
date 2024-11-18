import { ValidationPipe } from '@nestjs/common'
import { NestFactory } from '@nestjs/core'
import type { NestExpressApplication } from '@nestjs/platform-express'
import cookieParser from 'cookie-parser'
import { join } from 'path'
import { AppModule } from './app.module'

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule)
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }))
  app.use(cookieParser())

  app.setBaseViewsDir(join(__dirname, 'views'))
  app.setViewEngine('hbs')

  await app.listen(process.env.PORT ?? 3000)
}
bootstrap()

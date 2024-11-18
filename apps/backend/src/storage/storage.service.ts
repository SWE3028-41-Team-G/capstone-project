import {
  BadRequestException,
  Injectable,
  InternalServerErrorException
} from '@nestjs/common'
import { ConfigService } from '@nestjs/config'
import {
  DeleteObjectCommand,
  PutObjectCommand,
  S3Client
} from '@aws-sdk/client-s3'
import mime from 'mime-types'
import { v4 as uuidv4 } from 'uuid'

@Injectable()
export class StorageService {
  private readonly s3: S3Client

  constructor(private readonly configService: ConfigService) {
    if (this.configService.get('NODE_ENV') === 'production') {
      this.s3 = new S3Client({
        region: this.configService.get('BUCKET_REGION')
      })
    } else {
      this.s3 = new S3Client({
        region: this.configService.get('BUCKET_REGION'),
        endpoint: this.configService.get('BUCKET_URL'),
        forcePathStyle: true,
        credentials: {
          accessKeyId: this.configService.get('BUCKET_ACCESS_KEY') || '',
          secretAccessKey: this.configService.get('BUCKET_SECRET_KEY') || ''
        }
      })
    }
  }

  async uploadObject(
    file: Express.Multer.File,
    src: string
  ): Promise<{ src: string }> {
    try {
      const extension = this.getFileExtension(file.originalname)
      const keyWithoutExtenstion = `${src}/${this.generateUniqueImageName()}`
      const key = keyWithoutExtenstion + `${extension}`
      const fileType = this.extractContentType(file)

      await this.s3.send(
        new PutObjectCommand({
          Bucket: this.configService.get('BUCKET_NAME'),
          Key:
            this.configService.get('NODE_ENV') === 'production'
              ? keyWithoutExtenstion
              : key,
          Body: file.buffer,
          ContentType: fileType
        })
      )

      if (this.configService.get('NODE_ENV') === 'production') {
        return {
          src: keyWithoutExtenstion
        }
      } else {
        return {
          src: key
        }
      }
    } catch (error) {
      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  async deleteObject(url: string): Promise<{ result: string }> {
    try {
      const src = this.parsePathFromUrl(url)

      await this.s3.send(
        new DeleteObjectCommand({
          Bucket: this.configService.get('BUCKET_NAME'),
          Key: src
        })
      )

      return { result: 'ok' }
    } catch (error) {
      console.log(error)
      throw new InternalServerErrorException(error)
    }
  }

  private generateUniqueImageName(): string {
    const uniqueId = uuidv4()

    return uniqueId
  }

  private extractContentType(file: Express.Multer.File): string {
    if (file.mimetype) {
      return file.mimetype.toString()
    }

    return file.originalname
      ? mime.lookup(file.originalname) || 'application/octet-stream'
      : 'application/octet-stream'
  }

  private getFileExtension(filename: string): string {
    const match = filename.match(/\.[^.]+$/)

    if (match) {
      return match[0]
    }

    throw new BadRequestException('Unsupported file extension')
  }

  private parsePathFromUrl(url: string): string {
    const urlObject = new URL(url)
    const pathname = urlObject.pathname
    return pathname.startsWith('/') ? pathname.slice(1) : pathname
  }
}

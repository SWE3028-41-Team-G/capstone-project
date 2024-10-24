import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  // 시드 데이터 - Major
  const major1 = await prisma.major.create({
    data: {
      name: 'Computer Science',
      meta: {
        description: 'The study of computers and computational systems.'
      }
    }
  })

  const major2 = await prisma.major.create({
    data: {
      name: 'Electrical Engineering',
      meta: {
        description: 'The study of electrical systems and circuitry.'
      }
    }
  })

  // 시드 데이터 - User 및 Profile
  const user1 = await prisma.user.create({
    data: {
      username: 'johndoe',
      password: 'securepassword', // 실제 서비스에서는 암호화 필요
      nickname: 'Johnny',
      email: 'john@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id }, // Computer Science 전공 추가
          { majorId: major2.id } // Electrical Engineering 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'http://example.com/johndoe.jpg',
          intro: 'I am John, a passionate developer.',
          public: true
        }
      }
    }
  })

  const user2 = await prisma.user.create({
    data: {
      username: 'janedoe',
      password: 'anotherpassword', // 실제 서비스에서는 암호화 필요
      nickname: 'Janey',
      email: 'jane@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id } // Computer Science 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'http://example.com/janedoe.jpg',
          intro: 'Hello, I am Jane!',
          public: false
        }
      }
    }
  })

  console.log({ user1, user2 })
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })

import { PrismaClient } from '@prisma/client'
import { hash } from 'argon2'

const prisma = new PrismaClient()

async function main() {
  // 시드 데이터 - Major
  const major1 = await prisma.major.create({
    data: {
      name: '소프트웨어학과',
      meta: {
        description: 'The study of computers and computational systems.'
      }
    }
  })

  const major2 = await prisma.major.create({
    data: {
      name: '전자전기공학부',
      meta: {
        description: 'The study of electrical systems and circuitry.'
      }
    }
  })

  // 시드 데이터 - User 및 Profile
  const user1 = await prisma.user.create({
    data: {
      username: 'user01',
      password: await hash('1234'), // 실제 서비스에서는 암호화 필요
      nickname: 'user01',
      email: 'user01@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id }, // Computer Science 전공 추가
          { majorId: major2.id } // Electrical Engineering 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true
        }
      }
    }
  })

  const user2 = await prisma.user.create({
    data: {
      username: 'user02',
      password: await hash('1234'), // 실제 서비스에서는 암호화 필요
      nickname: 'user02',
      email: 'user02@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id } // Computer Science 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: false
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user03',
      password: await hash('1234'), // 실제 서비스에서는 암호화 필요
      nickname: 'user03',
      email: 'user03@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id }, // Computer Science 전공 추가
          { majorId: major2.id } // Electrical Engineering 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user04',
      password: await hash('1234'), // 실제 서비스에서는 암호화 필요
      nickname: 'user04',
      email: 'user04@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id }, // Computer Science 전공 추가
          { majorId: major2.id } // Electrical Engineering 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user05',
      password: await hash('1234'), // 실제 서비스에서는 암호화 필요
      nickname: 'user05',
      email: 'user05@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id }, // Computer Science 전공 추가
          { majorId: major2.id } // Electrical Engineering 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user06',
      password: await hash('1234'), // 실제 서비스에서는 암호화 필요
      nickname: 'user06',
      email: 'user06@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id }, // Computer Science 전공 추가
          { majorId: major2.id } // Electrical Engineering 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: false
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user07',
      password: await hash('1234'), // 실제 서비스에서는 암호화 필요
      nickname: 'user07',
      email: 'user07@example.com',
      UserMajor: {
        create: [
          { majorId: major1.id }, // Computer Science 전공 추가
          { majorId: major2.id } // Electrical Engineering 전공 추가
        ]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: false
        }
      }
    }
  })

  // 시드 데이터 - MockApply
  const mockApply1 = await prisma.mockApply.create({
    data: {
      userId: user1.id,
      majorId: major1.id,
      score: 4.5 // 전체 평점
    }
  })

  const mockApply2 = await prisma.mockApply.create({
    data: {
      userId: user2.id,
      majorId: major1.id,
      score: 4.2 // 전체 평점
    }
  })

  // 시드 데이터 - Square 및 UserSquare
  const square1 = await prisma.square.create({
    data: {
      name: 'Tech Enthusiasts',
      leaderId: user1.id,
      UserSquare: {
        create: [{ userId: user1.id }, { userId: user2.id }]
      }
    }
  })

  // 시드 데이터 - SquarePost
  const squarePost1 = await prisma.squarePost.create({
    data: {
      userId: user1.id,
      squareId: square1.id,
      title: 'Introduction to Tech Enthusiasts',
      content: 'Welcome everyone to the Tech Enthusiasts square!'
    }
  })

  // 시드 데이터 - SquarePostComment
  const squarePostComment1 = await prisma.squarePostComment.create({
    data: {
      userId: user2.id,
      squarePostId: squarePost1.id,
      content: 'This is an awesome square post!'
    }
  })

  const squarePostComment2 = await prisma.squarePostComment.create({
    data: {
      userId: user1.id,
      squarePostId: squarePost1.id,
      content: 'Thank you for the feedback!'
    }
  })

  // 시드 데이터 - Post 및 Tag
  const post1 = await prisma.post.create({
    data: {
      title: 'My First Post',
      content: 'This is the content of my first post.',
      userId: user1.id,
      tags: {
        create: [{ name: 'Tech' }, { name: 'Introduction' }]
      }
    }
  })

  // 시드 데이터 - Comment
  const comment1 = await prisma.comment.create({
    data: {
      userId: user2.id,
      postId: post1.id,
      content: 'Nice post!'
    }
  })

  const comment2 = await prisma.comment.create({
    data: {
      userId: user1.id,
      postId: post1.id,
      content: 'Thank you!',
      parentId: comment1.id // 대댓글
    }
  })

  console.log({
    user1,
    user2,
    major1,
    major2,
    mockApply1,
    mockApply2,
    square1,
    squarePost1,
    squarePostComment1,
    squarePostComment2,
    post1,
    comment1,
    comment2
  })
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })

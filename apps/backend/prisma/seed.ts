import { PrismaClient } from '@prisma/client'
import { hash } from 'argon2'

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
      password: await hash('securepassword'), // 실제 서비스에서는 암호화 필요
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
      password: await hash('anotherpassword'), // 실제 서비스에서는 암호화 필요
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

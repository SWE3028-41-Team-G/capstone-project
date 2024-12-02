import { PrismaClient } from '@prisma/client'
import { hash } from 'argon2'

const prisma = new PrismaClient()

async function main() {
  const majors = [
    '소프트웨어학과',
    '전자전기공학부',
    '인문과학계열',
    '사회과학계열',
    '자연과학계열',
    '공학계열',
    '글로벌융합학부',
    '유학·동양학과',
    '국어국문학과',
    '영어영문학과',
    '프랑스어문학과',
    '중어중문학과',
    '독어독문학과',
    '러시아어문학과',
    '한문학과',
    '사학과',
    '철학과',
    '문헌정보학과',
    '행정학과',
    '정치외교학과',
    '미디어커뮤니케이션학과',
    '사회학과',
    '사회복지학과',
    '심리학과',
    '소비자학과',
    '아동·청소년학과',
    '글로벌리더학부',
    '공익과법연계전공',
    '경제학과',
    '통계학과',
    '글로벌경제학과',
    '경영학과',
    '글로벌경영학과',
    '교육학과',
    '한문교육과',
    '수학교육과',
    '컴퓨터교육과',
    '미술학과',
    '디자인학과',
    '무용학과',
    '영상학과',
    '연기예술학과',
    '의상학과',
    '생명과학과',
    '수학과',
    '물리학과',
    '화학과',
    '반도체시스템공학과',
    '소재부품융합공학과',
    '반도체융합공학과',
    '데이터사이언스융합전공',
    '인공지능융합전공',
    '컬처앤테크놀로지융합전공',
    '자기설계융합전공',
    '지능형소프트웨어학과',
    '화학공학/고분자공학부',
    '신소재공학부',
    '기계공학부',
    '건설환경공학부',
    '시스템경영공학과',
    '건축학과',
    '나노공학과',
    '약학과',
    '식품생명공학과',
    '바이오메카트로닉스학과',
    '융합생명공학과',
    '스포츠과학과',
    '의예과',
    '의학과',
    '글로벌바이오메디컬공학과',
    '응용AI융합학부',
    '에너지학과'
  ]

  // Major 생성
  const majorRecords = await Promise.all(
    majors.map(async (majorName) => {
      return prisma.major.create({
        data: {
          name: majorName,
          meta: {
            description: `${majorName}에 대한 설명입니다.`
          }
        }
      })
    })
  )

  const major1 = majorRecords[0]
  const major2 = majorRecords[1]

  // 시드 데이터 - User 및 Profile
  const user1 = await prisma.user.create({
    data: {
      username: 'user01',
      password: await hash('1234'),
      nickname: 'user01',
      email: 'user01@example.com',
      UserMajor: {
        create: [{ majorId: major1.id }, { majorId: major2.id }]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true,
          interests: ['관심사 1', '관심사 2']
        }
      }
    }
  })

  const user2 = await prisma.user.create({
    data: {
      username: 'user02',
      password: await hash('1234'),
      nickname: 'user02',
      email: 'user02@example.com',
      UserMajor: {
        create: [{ majorId: major1.id }]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: false,
          interests: ['관심사 1', '관심사 2']
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user03',
      password: await hash('1234'),
      nickname: 'user03',
      email: 'user03@example.com',
      UserMajor: {
        create: [{ majorId: major1.id }, { majorId: major2.id }]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true,
          interests: ['관심사 1', '관심사 2']
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user04',
      password: await hash('1234'),
      nickname: 'user04',
      email: 'user04@example.com',
      UserMajor: {
        create: [{ majorId: major1.id }, { majorId: major2.id }]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true,
          interests: ['관심사 1', '관심사 2']
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user05',
      password: await hash('1234'),
      nickname: 'user05',
      email: 'user05@example.com',
      UserMajor: {
        create: [{ majorId: major1.id }, { majorId: major2.id }]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: true,
          interests: ['관심사 1', '관심사 2']
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user06',
      password: await hash('1234'),
      nickname: 'user06',
      email: 'user06@example.com',
      UserMajor: {
        create: [{ majorId: major1.id }, { majorId: major2.id }]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: false,
          interests: ['관심사 1', '관심사 2']
        }
      }
    }
  })

  await prisma.user.create({
    data: {
      username: 'user07',
      password: await hash('1234'),
      nickname: 'user07',
      email: 'user07@example.com',
      UserMajor: {
        create: [{ majorId: major1.id }, { majorId: major2.id }]
      },
      Profile: {
        create: {
          imageUrl: 'https://cdn.skku-dm.site/default.jpeg',
          intro: '',
          public: false,
          interests: ['관심사 1', '관심사 2']
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

  // 시드 데이터 - Post
  const post1 = await prisma.post.create({
    data: {
      title: 'My First Post',
      content: 'This is the content of my first post.',
      userId: user1.id
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

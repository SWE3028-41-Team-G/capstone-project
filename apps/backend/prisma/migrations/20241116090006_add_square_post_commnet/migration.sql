-- CreateTable
CREATE TABLE "SquarePostComment" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "squarePostId" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SquarePostComment_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "SquarePostComment" ADD CONSTRAINT "SquarePostComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SquarePostComment" ADD CONSTRAINT "SquarePostComment_squarePostId_fkey" FOREIGN KEY ("squarePostId") REFERENCES "square_post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

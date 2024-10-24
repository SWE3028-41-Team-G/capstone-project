-- CreateTable
CREATE TABLE "Profile" (
    "id" SERIAL NOT NULL,
    "image_url" TEXT NOT NULL,
    "intro" TEXT NOT NULL,
    "public" BOOLEAN NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

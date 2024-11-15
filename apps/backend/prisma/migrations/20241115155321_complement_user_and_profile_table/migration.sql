/*
  Warnings:

  - A unique constraint covering the columns `[email]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Profile" ADD COLUMN     "interests" TEXT[];

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "admit_year" INTEGER NOT NULL DEFAULT 2024,
ADD COLUMN     "real" BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE "user_major" ADD COLUMN     "origin" BOOLEAN NOT NULL DEFAULT true;

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

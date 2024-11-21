/*
  Warnings:

  - A unique constraint covering the columns `[user_id]` on the table `mock_apply` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "mock_apply_user_id_key" ON "mock_apply"("user_id");
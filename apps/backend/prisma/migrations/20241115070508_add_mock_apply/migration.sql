-- CreateTable
CREATE TABLE "mock_apply" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "major_id" INTEGER NOT NULL,
    "score" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "mock_apply_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "mock_apply" ADD CONSTRAINT "mock_apply_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mock_apply" ADD CONSTRAINT "mock_apply_major_id_fkey" FOREIGN KEY ("major_id") REFERENCES "Major"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_parent_id_fkey";

-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_post_id_fkey";

-- DropForeignKey
ALTER TABLE "Comment" DROP CONSTRAINT "Comment_user_id_fkey";

-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_userId_fkey";

-- DropForeignKey
ALTER TABLE "Profile" DROP CONSTRAINT "Profile_user_id_fkey";

-- DropForeignKey
ALTER TABLE "Square" DROP CONSTRAINT "Square_leader_id_fkey";

-- DropForeignKey
ALTER TABLE "SquarePostComment" DROP CONSTRAINT "SquarePostComment_squarePostId_fkey";

-- DropForeignKey
ALTER TABLE "SquarePostComment" DROP CONSTRAINT "SquarePostComment_userId_fkey";

-- DropForeignKey
ALTER TABLE "Tag" DROP CONSTRAINT "Tag_postId_fkey";

-- DropForeignKey
ALTER TABLE "mock_apply" DROP CONSTRAINT "mock_apply_major_id_fkey";

-- DropForeignKey
ALTER TABLE "mock_apply" DROP CONSTRAINT "mock_apply_user_id_fkey";

-- DropForeignKey
ALTER TABLE "square_post" DROP CONSTRAINT "square_post_square_id_fkey";

-- DropForeignKey
ALTER TABLE "square_post" DROP CONSTRAINT "square_post_user_id_fkey";

-- DropForeignKey
ALTER TABLE "user_major" DROP CONSTRAINT "user_major_major_id_fkey";

-- DropForeignKey
ALTER TABLE "user_major" DROP CONSTRAINT "user_major_user_id_fkey";

-- DropForeignKey
ALTER TABLE "user_square" DROP CONSTRAINT "user_square_square_id_fkey";

-- DropForeignKey
ALTER TABLE "user_square" DROP CONSTRAINT "user_square_user_id_fkey";

-- AddForeignKey
ALTER TABLE "user_major" ADD CONSTRAINT "user_major_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_major" ADD CONSTRAINT "user_major_major_id_fkey" FOREIGN KEY ("major_id") REFERENCES "Major"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Square" ADD CONSTRAINT "Square_leader_id_fkey" FOREIGN KEY ("leader_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_square" ADD CONSTRAINT "user_square_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_square" ADD CONSTRAINT "user_square_square_id_fkey" FOREIGN KEY ("square_id") REFERENCES "Square"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "square_post" ADD CONSTRAINT "square_post_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "square_post" ADD CONSTRAINT "square_post_square_id_fkey" FOREIGN KEY ("square_id") REFERENCES "Square"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SquarePostComment" ADD CONSTRAINT "SquarePostComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SquarePostComment" ADD CONSTRAINT "SquarePostComment_squarePostId_fkey" FOREIGN KEY ("squarePostId") REFERENCES "square_post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tag" ADD CONSTRAINT "Tag_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mock_apply" ADD CONSTRAINT "mock_apply_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mock_apply" ADD CONSTRAINT "mock_apply_major_id_fkey" FOREIGN KEY ("major_id") REFERENCES "Major"("id") ON DELETE CASCADE ON UPDATE CASCADE;

#!/bin/sh
npx prisma migrate deploy
node /app/dist/main.js

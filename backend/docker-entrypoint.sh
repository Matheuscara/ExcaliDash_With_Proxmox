#!/bin/sh
set -e

# Run migrations
npx prisma migrate deploy

# Start the application
node dist/index.js

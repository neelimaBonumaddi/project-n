CRECREATE TABLE "User" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "password" VARCHAR(255) NOT NULL,
  "firstName" VARCHAR(100),
  "lastName" VARCHAR(100),
  "city" VARCHAR(100),
  "state" VARCHAR(100),
  "birthDate" VARCHAR,
  "gender" VARCHAR(20),
  "bio" TEXT,
  "profileImageUrl" VARCHAR(300),
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE "UserFollows" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "followerId" UUID NOT NULL,
  "followingId" UUID NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("followerId") REFERENCES "User"("id") ON DELETE CASCADE,
  FOREIGN KEY ("followingId") REFERENCES "User"("id") ON DELETE CASCADE,
  UNIQUE ("followerId", "followingId")
);

CREATE TABLE "Activity" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "title" VARCHAR(255) NOT NULL,
  "description" TEXT,
  "distance" DECIMAL(10,2) NOT NULL,
  "duration" INTEGER NOT NULL, -- in seconds
  "pace" VARCHAR(20),
  "avgSpeed" DECIMAL(10,2),
  "elevGain" DECIMAL(10,2),
  "startTime" TIMESTAMP NOT NULL,
  "endTime" TIMESTAMP NOT NULL,
  "isPublic" BOOLEAN NOT NULL DEFAULT TRUE,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE
);
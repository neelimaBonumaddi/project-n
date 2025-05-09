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
  "duration" INTEGER NOT NULL, 
  "pace" VARCHAR(20),
  "elevGain" DECIMAL(10,2),
  "startTime" TIMESTAMP NOT NULL,
  "endTime" TIMESTAMP NOT NULL,
  "isPublic" BOOLEAN NOT NULL DEFAULT TRUE,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE
);

CREATE TABLE "RoutePoint" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "activityId" UUID,
  "plannedRouteId" UUID,
  "latitude" DECIMAL(10,8) NOT NULL,
  "longitude" DECIMAL(11,8) NOT NULL,
  "elevation" DECIMAL(10,2),
  "timestamp" TIMESTAMP,
  "sequence" INTEGER NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("activityId") REFERENCES "Activity"("id") ON DELETE CASCADE,
  FOREIGN KEY ("plannedRouteId") REFERENCES "PlannedRoute"("id") ON DELETE CASCADE,
  CHECK (("activityId" IS NULL AND "plannedRouteId" IS NOT NULL) OR ("activityId" IS NOT NULL AND "plannedRouteId" IS NULL))
);

CREATE TABLE "Group" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "name" VARCHAR(255) NOT NULL,
  "description" TEXT,
  "location" VARCHAR(255) NOT NULL,
  "imageUrl" VARCHAR(255),
  "creatorId" UUID NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE CASCADE
);

CREATE TABLE "GroupMember" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "groupId" UUID NOT NULL,
  "role" VARCHAR(20) NOT NULL DEFAULT 'member',
  "joinedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE,
  FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE CASCADE,
  UNIQUE ("userId", "groupId")
);

CREATE TABLE "Post" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "content" TEXT NOT NULL,
  "imageUrl" VARCHAR(255),
  "activityId" UUID,
  "groupId" UUID,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE,
  FOREIGN KEY ("activityId") REFERENCES "Activity"("id") ON DELETE SET NULL,
  FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE SET NULL
);

CREATE TABLE "Comment" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "postId" UUID,
  "activityId" UUID,
  "content" TEXT NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE,
  FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE,
  FOREIGN KEY ("activityId") REFERENCES "Activity"("id") ON DELETE CASCADE,
  CHECK (("postId" IS NULL AND "activityId" IS NOT NULL) OR ("postId" IS NOT NULL AND "activityId" IS NULL))
);

CREATE TABLE "Like" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "postId" UUID,
  "activityId" UUID,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE,
  FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE,
  FOREIGN KEY ("activityId") REFERENCES "Activity"("id") ON DELETE CASCADE,
  UNIQUE ("userId", "postId"),
  UNIQUE ("userId", "activityId"),
  CHECK (("postId" IS NULL AND "activityId" IS NOT NULL) OR ("postId" IS NOT NULL AND "activityId" IS NULL))
);

CREATE TABLE "Notification" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "groupId" UUID,
  "type" VARCHAR(50) NOT NULL, 
  "message" TEXT NOT NULL,
  "isRead" BOOLEAN NOT NULL DEFAULT FALSE,
  "relatedId" UUID,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE,
  FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE CASCADE
);

CREATE TABLE "PlannedRoute" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "description" TEXT,
  "distance" DECIMAL(10,2) NOT NULL, 
  "elevGain" DECIMAL(10,2),
  "isPublic" BOOLEAN NOT NULL DEFAULT FALSE,
  "routeType" VARCHAR(50), 
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE
);

CREATE TABLE "SavedRoute" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "userId" UUID NOT NULL,
  "routeId" UUID NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE,
  FOREIGN KEY ("routeId") REFERENCES "PlannedRoute"("id") ON DELETE CASCADE,
  UNIQUE ("userId", "routeId")
);

CREATE TABLE "PlannedRide" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "groupId" UUID NOT NULL,
  "routeId" UUID NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "datetime" TIMESTAMP NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE CASCADE,
  FOREIGN KEY ("routeId") REFERENCES "PlannedRoute"("id") ON DELETE CASCADE
);
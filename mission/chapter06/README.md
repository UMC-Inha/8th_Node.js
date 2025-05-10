- github 링크
https://github.com/gaaahee/8th_node.js_practice/tree/feature/chapter-06


# 미션 기록

- Prisma schema로 변환
    
    ```jsx
    // This is your Prisma schema file,
    // learn more about it in the docs: https://pris.ly/d/prisma-schema
    
    // Looking for ways to speed up your queries, or scale easily with your serverless or edge functions?
    // Try Prisma Accelerate: https://pris.ly/cli/accelerate-init
    
    generator client {
      provider = "prisma-client-js"
      output   = "../src/generated/prisma"
    }
    
    datasource db {
      provider = "mysql"
      url      = env("DATABASE_URL")
    }
    
    model UserLogin {
      id       Int    @id @default(autoincrement())
      email    String @unique @db.VarChar(50)
      password String @db.VarChar(30)
    
      userInfo       UserInfo?
      alarms         alarm[]
      inquiries      Inquiry[]
      userCategories UserCategory[]
      missionLogs    MissionLog[]
      reviews        Review[]
    
      @@map("userlogin")
    }
    
    model UserInfo {
      id           Int      @id @default(autoincrement())
      user_id      Int      @unique
      gender       String   @db.VarChar(10)
      birthdate    DateTime
      address      String   @db.VarChar(100)
      created_at   DateTime @default(now())
      updated_at   DateTime @updatedAt
      point        Int      @default(0)
      user_name    String   @db.VarChar(20)
      phone_number String   @db.VarChar(20)
    
      userLogin UserLogin @relation(fields: [user_id], references: [id])
    
      @@map("userinfo")
    }
    
    model alarm {
      id         Int      @id @default(autoincrement())
      title      String?
      content    String?
      created_at DateTime @default(now())
      updated_at DateTime @updatedAt
    
      user_id   Int
      userLogin UserLogin @relation(fields: [user_id], references: [id])
    
      @@map("alarm")
    }
    
    model Inquiry {
      id         Int      @id @default(autoincrement())
      user_id    Int
      content    String
      created_at DateTime @default(now())
      updated_at DateTime @updatedAt
      image_url  String?  @db.VarChar(200)
    
      userLogin UserLogin @relation(fields: [user_id], references: [id])
    
      @@map("inquiry")
    }
    
    model UserCategory {
      user_id     Int
      category_id Int
    
      userLogin UserLogin @relation(fields: [user_id], references: [id])
      category  Category  @relation(fields: [category_id], references: [id])
    
      @@id([user_id, category_id])
      @@map("usercategory")
    }
    
    model Category {
      id         Int      @id @default(autoincrement())
      name       String   @db.VarChar(20)
      created_at DateTime @default(now())
      updated_at DateTime @updatedAt
    
      userCategories UserCategory[]
      categoryShops  CategoryShop[]
    
      @@map("category")
    }
    
    model CategoryShop {
      category_id Int
      shop_id     Int
    
      category Category @relation(fields: [category_id], references: [id])
      shop     Shop     @relation(fields: [shop_id], references: [id])
    
      @@id([category_id, shop_id])
      @@map("categoryshop")
    }
    
    model Region {
      id         Int      @id @default(autoincrement())
      name       String   @db.VarChar(20)
      created_at DateTime @default(now())
      updated_at DateTime @updatedAt
    
      shops Shop[]
    
      @@map("region")
    }
    
    model Shop {
      id         Int      @id @default(autoincrement())
      name       String   @db.VarChar(30)
      region_id  Int
      address    String   @db.VarChar(100)
      created_at DateTime @default(now())
    
      region        Region         @relation(fields: [region_id], references: [id])
      missions      Mission[]
      reviews       Review[]
      categoryShops CategoryShop[]
    
      @@map("shop")
    }
    
    model Mission {
      id          Int      @id @default(autoincrement())
      shop_id     Int
      description String?  @db.VarChar(200)
      point       Int
      created_at  DateTime @default(now())
      updated_at  DateTime @updatedAt
      due_date    DateTime
    
      shop        Shop         @relation(fields: [shop_id], references: [id])
      missionLogs MissionLog[]
    
      @@map("mission")
    }
    
    model MissionLog {
      id           Int       @id @default(autoincrement())
      status       String    @db.VarChar(10)
      user_id      Int
      mission_id   Int
      completed_at DateTime?
      created_at   DateTime  @default(now())
      updated_at   DateTime  @updatedAt
    
      userLogin UserLogin @relation(fields: [user_id], references: [id])
      mission   Mission   @relation(fields: [mission_id], references: [id])
    
      @@map("missionlog")
    }
    
    model Review {
      id         Int      @id @default(autoincrement())
      shop_id    Int
      rating     Int
      comment    String?
      created_at DateTime @default(now())
      updated_at DateTime @updatedAt
      user_id    Int
      image_url  String?  @db.VarChar(200)
    
      shop      Shop      @relation(fields: [shop_id], references: [id])
      userLogin UserLogin @relation(fields: [user_id], references: [id])
    
      @@map("review")
    }
    ```
    

0. Repository 함수 Prisma ORM 이용해서 코드 수정
    
    ```jsx
    import { prisma } from "../db.config.js";
    
    // 가게 존재 여부 확인
    export const findShopById = async (shopId) => {
      try {
        const shop = await prisma.shop.findUnique({
          where: { id: parseInt(shopId) },
        });
        return shop;
      } catch (error) {
        console.error("Error in findShopById (review.repository):", error);
        throw error;
      }
    };
    
    // 리뷰 추가
    export const addReview = async (shopId, reviewData) => {
      try {
            const newReview = await prisma.review.create({
           data: {
             shop_id: parseInt(shopId),
             user_id: reviewData.userId,
             rating: reviewData.rating,
             comment: reviewData.comment,
             image_url: reviewData.imageUrl,
           },
         });
         return newReview;
       } catch (err) {
         console.error("Error in addReview:", err);
         throw err;
       }
     };
    ```
    
    ---
    
    변환 후 테스트
    ![alt text](image01.png)

    
1. 내가 작성한 리뷰 목록
![alt text](image02.png)
![alt text](image03.png)
![alt text](image04.png)

2. 특정 가게의 미션 목록 조회
![alt text](image05.png)

3. 내가 진행 중인 미션 목록 조회
MissionLog 테이블에 임의로 데이터 추가
![alt text](image06.png)
도전 중인 미션(status = inProgress)만 조회가 된다!
![alt text](image07.png)
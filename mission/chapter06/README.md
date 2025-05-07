- 미션 기록
    1. Prisma 변환 과정
        1. Schema
            
            ```jsx
            // This is your Prisma schema file,
            // learn more about it in the docs: https://pris.ly/d/prisma-schema
            
            // Looking for ways to speed up your queries, or scale easily with your serverless or edge functions?
            // Try Prisma Accelerate: https://pris.ly/cli/accelerate-init
            
            generator client {
              provider = "prisma-client-js"
            }
            
            datasource db {
              provider = "mysql"
              url      = env("DATABASE_URL")
            }
            
            model User {
              id          Int      @id @default(autoincrement())
              email       String   @unique(map: "email") @db.VarChar(30)
              username    String   @db.VarChar(20)
              gender      Int      @db.TinyInt
              phoneNumber String   @unique(map: "phone_number") @map("phone_number") @db.VarChar(20)
              address     String   @db.VarChar(50)
              point       Int?
              birth       DateTime @db.Timestamp()
            
              UserFoodCategory UserFoodCategory[]
              Review           Review[]
              MissionLog       MissionLog[]
            
              @@map("user")
            }
            
            model UserFoodCategory {
              userId         Int          @map("user_id")
              user           User         @relation(fields: [userId], references: [id])
              foodCategoryId Int          @map("food_id")
              foodCategory   FoodCategory @relation(fields: [foodCategoryId], references: [id])
            
              @@unique([userId, foodCategoryId])
              @@map("user_food_category")
            }
            
            model FoodCategory {
              id   Int    @id @default(autoincrement())
              food String @db.VarChar(10)
            
              UserFoodCategory UserFoodCategory[]
            
              @@map("food_category")
            }
            
            model Shop {
              id           Int    @id @default(autoincrement())
              shopName     String @map("shop_name") @db.VarChar(20)
              shopAddress  String @map("shop_address") @db.VarChar(50)
              shopCategory Int    @map("shop_category")
              areaId       Int    @map("area_id")
            
              area    Area         @relation(fields: [areaId], references: [id])
              shopCat ShopCategory @relation(fields: [shopCategory], references: [id])
            
              Review  Review[]
              Mission Mission[]
            
              @@map("shop")
            }
            
            model Area {
              id       Int    @id @default(autoincrement())
              areaName String @map("area_name") @db.VarChar(10)
            
              shop Shop[]
            }
            
            model ShopCategory {
              id       Int    @id @default(autoincrement())
              category String @db.VarChar(10)
            
              shop Shop[]
            }
            
            model Review {
              id            Int    @id @default(autoincrement())
              userId        Int    @map("user_id")
              shopId        Int    @map("shop_id")
              reviewTitle   String @map("review_title") @db.Text
              reviewContent String @map("review_content") @db.Text
              reviewStars   Int    @map("review_stars") @db.TinyInt
            
              user User @relation(fields: [userId], references: [id])
              shop Shop @relation(fields: [shopId], references: [id])
            
              @@map("review")
            }
            
            model Mission {
              id        Int      @id @default(autoincrement())
              shopId    Int      @map("shop_id")
              shop      Shop     @relation(fields: [shopId], references: [id])
              content   String   @map("content") @db.Text
              point     Int
              createdAt DateTime @map("created_at") @db.Timestamp() @default(now())
              updatedAt DateTime? @map("updated_at") @db.Timestamp()
            
              MissionLog MissionLog[]
            
              @@map("mission")
            }
            
            model MissionLog {
              id        Int     @id @default(autoincrement())
              missionId Int     @map("mission_id")
              userId    Int     @map("user_id")
              user      User    @relation(fields: [userId], references: [id])
              mission   Mission @relation(fields: [missionId], references: [id])
            
              @@map("mission_log")
            }
            
            ```
            
            모든 relation table을 prisma schema로 변환. camelCase 형식으로 모든 컬럼, db명 통일.
            
        2. repository
            
            ```jsx
            export const addReview = async (reviewInfo) => {
                try{
                    const shopExists = await prisma.shop.findUnique({
                        where: { id: reviewInfo.shopId },
                    });
            
                    if(!shopExists){
                        return null;
                    }
            
                    const newReview = await prisma.review.create({
                        data: {
                            userId: reviewInfo.userId,                
                            shopId: reviewInfo.shopId,                
                            reviewTitle: reviewInfo.reviewTitle,      
                            reviewContent: reviewInfo.reviewContent,  
                            reviewStars: reviewInfo.reviewStars,      
                        },
                    });
            
                    return newReview.id;
                } catch(err){
                    throw new Error(
                        `오류 발생. (${err})`
                    );
                }
            };
            ```
            
            모든 repository 함수를 prisma를 사용하도록 변환.
            
        3. dto
            
            ```jsx
            export const responseFromMission = (mission) => {
                return{
                    shopId: mission.shopId,
                    shopName: mission.shop.shopName,
                    content: mission.content,
                    point: mission.point
                }
            };
            ```
            
            Prisma로 join하여 조회하면 join한 relation은 객체 안에 객체 형식으로 존재. 따라서 shopName은 join한 정보이므로 mission 객체 안의 shop 객체에서 빼내어서 사용해야 함.
            
            repository에서 return할 때 map을 사용하여 빼줄 수도 있지만 dto에서 구현함.
            
            마찬가지로 dto에서도 모든 컬럼명을 camelCase로 변환함.
            
        4. 결과
            
            ![prismanewmission.PNG](prismanewmission.png)
            
            ![prismanewreview.PNG](prismanewreview.png)
            
            ![prismanewuser.PNG](prismanewuser.png)
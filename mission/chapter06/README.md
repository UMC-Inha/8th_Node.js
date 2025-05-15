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
            
    2. Prisma Logging
        1. Prisma의 Query 해석본, duration 등을 출력해줄 수 있는 기능.
            
            ```jsx
            export const prisma = new PrismaClient({
                log: [
                    {
                    emit: 'event',
                    level: 'query',
                    },
                    {
                    emit: 'stdout',
                    level: 'error',
                    },
                    {
                    emit: 'stdout',
                    level: 'info',
                    },
                    {
                    emit: 'stdout',
                    level: 'warn',
                    },
                ],
            })
            
            prisma.$on('query', (e) => {
                console.log('Query: ' + e.query)
                console.log('Params: ' + e.params)
                console.log('Duration: ' + e.duration + 'ms')
            })
            ```
            
            ```jsx
            prisma:info Starting a mysql pool with 9 connections.
            Query: SELECT `umc8`.`review`.`id`, `umc8`.`review`.`user_id`, `umc8`.`review`.`shop_id`, `umc8`.`review`.`review_title`, `umc8`.`review`.`review_content`, `umc8`.`review`.`review_stars`, `umc8`.`review`.`created_at`, `umc8`.`review`.`updated_at` FROM `umc8`.`review` WHERE `umc8`.`review`.`user_id` = ?
            Params: [1]
            Duration: 2ms
            ```
            
    3. 유저 미션 조회
        1. dto
            
            ```jsx
            export const responseFromMyReview = (reviews) => {
                const result = reviews.map((review) => {
                    return {
                        id: review.id, 
                        shopId: review.shopId, 
                        reviewTitle: review.reviewTitle, 
                        reviewContent: review.reviewContent, 
                        reviewStars: review.reviewStars,
                        createdAt: review.createdAt.toDateString(), 
                        updatedAt: review.updatedAt
                    }});
                return result;
            }
            ```
            
            Prisma의 findMany 메소드를 이용하면 결과가 객체의 배열로 나오게 된다. 이 정보를 가공하려면 dto 또는 repository 또는 service 차원에서 map을 사용해야 한다.
            
            Parsing, type 변환이나 Date와 같은 자료형을 다룰 때를 대비하여 이러한 dto를 만든다.
            
            ![getReviewById.PNG](attachment:016454a2-69ea-4cb9-8ec0-cf389bc6d831:getReviewById.png)
            
    4. 상점 미션 조회
        1. repository
            
            ```jsx
            export const getMissionByShopId = async (shopId) => {
                try{
                    const missions = await prisma.mission.findMany({
                        where: { shopId: shopId },
                    });
            
                    return missions
                } catch(err){
                    throw new Error(
                        `오류 발생. (${err})`
                    );
                }
            };
            ```
            
            findMany로 여러 튜플 검색.
            
        2. service
            
            ```jsx
            export const serviceGetMissionByShopId = async (shopId) => {
                const missions = await getMissionByShopId(shopId);
            
                if(missions.length === 0){
                    throw new Error(`미션이 존재하지 않습니다. shopId: ${shopId}`);
                }
            
                return missions;
            }
            ```
            
            결과의 길이가 0이면 값이 존재하지 않는 것이므로 예외처리.
            
    5. 유저 미션 조회
        1. repository
            
            ```jsx
            export const getAcceptedUserMission = async (userId) => {
                try{
                    const missions = await prisma.missionLog.findMany({
                        where: { userId: userId, success: 0 },
                        include: {
                            mission: {
                                select: {
                                    content: true,
                                    point: true,
                                    shop: {
                                        select: {
                                            shopName: true,
                                        }
                                    }
                                }
                            },
                        },
                        orderBy: {
                            missionId: 'asc',
                        },
                    });
            
                    console.log(missions);
            
                    return missions;
                }catch(err){
                    throw new Error(
                        `오류가 발생했어요. 요청 파라미터를 확인해주세요. (${err})`
                    );
                }
            }
            ```
            
            include를 활용해서 mission, shop에 있는 필요한 정보도 출력.
            
    6. 미션 완료
        1. repository
            
            ```jsx
            export const completeUserMission = async (userId, missionId) => {
                try{
                    const missionExists = await prisma.missionLog.findUnique({
                        where: { missionId_userId: { missionId: missionId, userId: userId } },
                    });
            
                    if(missionExists === null){
                        throw new Error(`해당 미션이 수락된 목록에 없습니다. ${missionId}`);
                    }
            
                    const mission = await prisma.missionLog.update({
                        where: {
                            missionId_userId: { missionId: missionId, userId: userId }
                        },
                        data: {
                            success: 1,
                        }
                    })
            
                    return mission;
                }catch(err){
                    throw new Error(
                        `오류가 발생했어요. 요청 파라미터를 확인해주세요. (${err})`
                    );
                }
            }
            ```
            
            update로 success를 1로 바꾸어 상태를 표현한다.
            
    7. Prisma Transaction
        1. Nested Write
            
            Prisma는 하나의 Prisma API로 여러 개의 처리를 할 수 있다.
            
            ```jsx
            // Create a new user with two posts in a
            // single transaction
            const newUser: User = await prisma.user.create({
              data: {
                email: 'alice@prisma.io',
                posts: {
                  create: [
                    { title: 'Join the Prisma Discord at https://pris.ly/discord' },
                    { title: 'Follow @prisma on Twitter' },
                  ],
                },
              },
            })
            ```
            
            다음과 같이 하나의 유저를 생성하며 해당 유저의 게시물도 동시에 생성할 수 있다.
            
        2. Batch/bulk Operations
            
            다음의 Prisma API들은 내부적으로 transaction으로 처리된다.
            
            - createMany()
            - createManyAndReturn()
            - updateMany()
            - updateManyAndReturn()
            - deleteMany()
        3. $transaction API
            
            두 가지 방법으로 사용할 수 있다.
            
            - Sequential Operation: Prisma Client 쿼리를 배열의 형태로 전달하여 차례대로 transaction을 수행한다.
                
                ```jsx
                const [posts, totalPosts] = await prisma.$transaction([
                  prisma.post.findMany({ where: { title: { contains: 'prisma' } } }),
                  prisma.post.count(),
                ])
                ```
                
                내부에 raw query로 입력하여도 동작한다.
                
            - Interactive transaction: 유저 코드와 Prisma 코드를 포함한 함수를 전달받아 transaction으로 수행하여, 더 정교한 control flow를 제공한다.
                
                ```jsx
                import { PrismaClient } from '@prisma/client'
                const prisma = new PrismaClient()
                
                function transfer(from: string, to: string, amount: number) {
                  return prisma.$transaction(async (tx) => {
                    // 1. Decrement amount from the sender.
                    const sender = await tx.account.update({
                      data: {
                        balance: {
                          decrement: amount,
                        },
                      },
                      where: {
                        email: from,
                      },
                    })
                
                    // 2. Verify that the sender's balance didn't go below zero.
                    if (sender.balance < 0) {
                      throw new Error(`${from} doesn't have enough to send ${amount}`)
                    }
                
                    // 3. Increment the recipient's balance by amount
                    const recipient = await tx.account.update({
                      data: {
                        balance: {
                          increment: amount,
                        },
                      },
                      where: {
                        email: to,
                      },
                    })
                
                    return recipient
                  })
                }
                
                async function main() {
                  // This transfer is successful
                  await transfer('alice@prisma.io', 'bob@prisma.io', 100)
                  // This transfer fails because Alice doesn't have enough funds in her account
                  await transfer('alice@prisma.io', 'bob@prisma.io', 100)
                }
                
                main()
                ```
                
    8. Prisma N+1
        1. Fluent API
            
            ```jsx
            const postsByUser: Post[] = await client.user
                .findUnique({ where: { id: "1" } })
                .posts({ cursor: "1", skip: 0, take: 10 });
            ```
            
            Prisma 자체적인 API로, 뒤에 .posts와 같이 붙여서 사용한다.
            
            몇가지 조건이 필요하다.
            
            1. Prisma 모델에 연관하려는 모델의 schema가 작성되어야 한다.
            2. findUnique, findFirst와 같은 단일행 쿼리 후 사용한다.
            3. 쿼리의 결과는 최종적으로 호출되는 Fluent API에 의해 결정된다.
            
            Prisma는 Fluent API가 없다면 user 수만큼 쿼리를 늘려서 생성했을 것이다.
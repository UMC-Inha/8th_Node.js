- ORM
    - Object Relational Mapping - 어플리케이션(서버)과 데이터베이스 연결 시 SQL언어가 아닌 어플리케이션 개발 언어로 데이터베이스를 접근해줄 수 있게 해주는 툴
    - 개발 언어의 일관성, 가독성을 챙길 수 있음
    - Java의 JPA와Hibernate, , 파이썬의 FlaskSQLAlchemy와 ORM cookbook, Node.js의 Sequalize, Prisma 등이 대표적이다.
- Prisma 문서 살펴보기
    - Prisma Schema
        - Models
            - 어플리케이션 도메인의 엔티티들을 의미함
            - 데이터베이스 내의 relational table과 매핑됨
            - Prisma 쿼리의 대상이 됨
            - Typescript와 함께 사용하면 type definition으로 정의 가능함
            
            ```jsx
            model User {
              id      Int      @id @default(autoincrement())
              email   String   @unique
              name    String?
              role    Role     @default(USER)
              posts   Post[]
              profile Profile?
            }
            
            model Profile {
              id     Int    @id @default(autoincrement())
              bio    String
              user   User   @relation(fields: [userId], references: [id])
              userId Int    @unique
            }
            
            model Post {
              id         Int        @id @default(autoincrement())
              createdAt  DateTime   @default(now())
              updatedAt  DateTime   @updatedAt
              title      String
              published  Boolean    @default(false)
              author     User       @relation(fields: [authorId], references: [id])
              authorId   Int
              categories Category[]
            }
            
            model Category {
              id    Int    @id @default(autoincrement())
              name  String
              posts Post[]
            }
            
            enum Role {
              USER
              ADMIN
            }
            ```
            
    - ex. Prisma의 Connection Pool 관리 방법
        - Prisma Client가 데이터베이스에 첫 연결을 시도할 때 pool이 생성됨
            - 명시적으로 connect()함수를 통해 호출하는 경우
            - 첫 쿼리를 실행하는 경우 - 암묵적으로 자동으로 connect()가 호출됨
        - connection pool 작동 방식
            1. pool size와 pool time값을 가진 connection pool 생성
            2. 쿼리 엔진이 하나의 connection을 생성하고 pool에 추가
            3. 쿼리가 요청되면, connection을 pool에서 사용
            4. pool에 사용가능한 connection이 없는 경우 connection_limit이 될 때까지 connection을 하나씩 추가한다.
            5. connection_limit까지 connection이 있는 경우에도 사용가능한 connection이 없으면 쿼리 요청은 fifo queue 방식으로 처리됨.
            6. time limit 전에 쿼리 요청이 처리되지 않는다면 예외처리되고 다음 쿼리 요청으로 넘어간다.
        - 기본 Pool size - num_physical_cpus * 2 + 1
            
            ```jsx
            datasource db {
              provider = "postgresql"
              url      = "postgresql://johndoe:mypassword@localhost:5432/mydb?connection_limit=5&pool_timeout=2"
            }
            ```
            
    - ex. Prisma의 Migration 관리 방법
        - Database Migration - 데이터베이스 스키마를 변경할 수 있는 변경 사항의 집합.
        - 스키마의 상태와 구조를 변경할 수 있다.
        - Prisma는 model/entitiy-first migration pattern으로 migration이 이루어진다.
            
            ![image.png](1.png)
            
        - Prisma Migration의 Workflow
            1. Local Development Environment
                1. Prisma Schema 구조 수정
                2. prisma migrate dev나 prisma db push와 같은 명령어로 Prisma schema와 local database의 schema를 동기화한다.
            2. Preview/Staging Environment
                1. 변경사항을 push하여 pull request 생성
                2. GitHub Action과 같은 CI 시스템으로 Prisma schema와 migration history를 preview database와 동기화한다.
            3. Production
                1. main branch와 개발 중인 branch를 merge한다.
                2. CI 시스템을 활용하여 배포한다.
                
                ![image.png](2.png)
                
- ORM(Prisma)을 사용하여 좋은 점과 나쁜 점
    - 장점
        1. 직관적이고 가독성 좋은 코드
        2. 객체 지향적인 DB 접근으로 생산성 증가
        3. 재사용, 유지보수의 용이성
        4. DBMS에 대한 종속성 감소
    - 단점
        1. 잘못 구현된 경우 성능 저하가 발생한다.
            
            직접 작성한 Query보다 느리게 작동하는 경우가 발생할 수 있다.
            
        2. 복잡한 Query문은 직접 SQL을 사용해야 한다.
            
            ORM만으로 모든 Query를 구현할 수는 없다.
            
- 다양한 ORM 라이브러리 살펴보기
    - ex. Sequelize
        - 전체적으로 Prisma와 비슷한 기능들을 제공하지만, 몇몇 기능에서 차이가 있다.
        - find와 같은 함수에서 filtering을 위한 기준이 다르다. Prisma는 where: {}에 여러 필터를 추가하여 조건을 하나씩 늘려갈 수 있고, sequelize는 정해져있는 sequelize operator를 사용한다.
        - Relation filter를 sequelize에서는 지원하지 않는다. 따라서 relation table의 filtering을 위해서는 raw query를 사용해야 한다.
    - ex. TypeORM
        - 테이블을 model 클래스와 매핑한다. model 클래스를 통해 SQL migration을 지원한다.
        - Prisma와 달리 SQL의 문법에 더 가까운 형태를 지닌다.
        - TypeORM은 limit-offset 방식의 pagination만 구현이 가능하다.
        - Schema의 형태가 서로 다르다. TypeORM은 TypeScript의 decorator를 통해 model을 정의한다.
- 페이지네이션을 사용하는 다른 API 찾아보기
    - ex. https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api?apiVersion=2022-11-28
    - ex. https://developers.notion.com/reference/intro#pagination
    - Prisma의 Pagination
        - Offset Pagination
            
            ```jsx
            const results = await prisma.post.findMany({
              skip: 200,
              take: 20,
              where: {
                email: {
                  contains: 'Prisma',
                },
              },
              orderBy: {
                title: 'desc',
              },
            })
            ```
            
        - Cursor-based Pagination
            
            ```jsx
            const firstQueryResults = await prisma.post.findMany({
              take: 4,
              where: {
                title: {
                  contains: 'Prisma' /* Optional filter */,
                },
              },
              orderBy: {
                id: 'asc',
              },
            })
            
            // Bookmark your location in the result set - in this
            // case, the ID of the last post in the list of 4.
            
            const lastPostInResults = firstQueryResults[3] // Remember: zero-based index! :)
            const myCursor = lastPostInResults.id // Example: 29
            ```
            
            ```jsx
            const secondQueryResults = await prisma.post.findMany({
              take: 4,
              skip: 1, // Skip the cursor
              cursor: {
                id: myCursor,
              },
              where: {
                title: {
                  contains: 'Prisma' /* Optional filter */,
                },
              },
              orderBy: {
                id: 'asc',
              },
            })
            
            const lastPostInResults = secondQueryResults[3] // Remember: zero-based index! :)
            const myCursor = lastPostInResults.id // Example: 52
            ```
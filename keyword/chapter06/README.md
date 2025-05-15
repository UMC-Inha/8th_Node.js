- ORM
    
    ORM(Object-Relational Mapping)은 데이터베이스와 자바스크립트 객체 사이를 자동으로 연결해준다.
    
    ORM을 사용함으로써, SQL을 직접 작성하지 않고 자바스크립트 코드로 데이터베이스를 다룰 수 있다.
    
    대표적인 ORM으로는 Sequelize, TypeORM, Prisma 등이 있다.
    
    **ORM의 주요 역할**
    
    - 자바스크립트 객체를 데이터베이스의 테이블 행(row)으로 변환
    - 데이터베이스의 데이터를 자바스크립트 객체로 변환
    - SQL 쿼리를 자동으로 만들어줌
    
    **장점**
    
    - SQL을 몰라도 자바스크립트로 데이터베이스 조작 가능
    - 반복적인 데이터베이스 작업 코드가 줄어듦
    - SQL 인젝션 등 보안 위험이 감소
    
    **예시 코드**
    
    | 방식 | 예시 코드 |
    | --- | --- |
    | SQL 직접 | `SELECT * 
    FROM post 
    WHERE authorId = 12 
    AND status = 'active';` |
    | Sequelize | `models.Post.findAll({ where: { authorId: 12, status: 'active' } })` |
    | TypeORM | `connection.getRepository(Post).find({ where: { authorId: 12, status: 'active' } })` |
    
    → ORM을 쓰면 SQL 대신 자바스크립트 객체와 메서드로 데이터베이스를 다룰 수 있다.
    
- Prisma 문서 살펴보기
    - ex. Prisma의 Connection Pool 관리 방법
        
        Prisma는 자체적인 **커넥션 풀(connection pool)**을 관리한다.
        
        Prisma Client가 데이터베이스에 첫 연결 시에 커넥션 풀이 생성되며, 이 풀의 크기와 타임아웃은 설정에 따라 조정할 수 있다.
        
        - **설정 방법**: 필요하다면, `prisma/schema.prisma` 파일의 데이터베이스 URL에 옵션을 추가해 커넥션 수를 조절할 수 있다.
        
        ```jsx
        datasource db {
          provider = "postgresql"
          url      = "postgresql://user:password@localhost:5432/mydb?connection_limit=5"
        }
        // 커넥션 풀의 최대 연결 수를 5개로 제한한다.
        ```
        
        커넥션 풀이 만들어지면, 쿼리가 들어올 때마다 남는 커넥션을 할당한다.
        
        만약 남는 커넥션이 없으면, 최대치(`connection_limit`)까지 추가로 커넥션을 생성한다.
        
    - ex. Prisma의 Migration 관리 방법
        
        Prisma Migrate는 데이터베이스 스키마 변경 및 관리할 수 있도록 한다.
        
        **마이그레이션**이란? 데이터베이스 구조(테이블, 컬럼 등)가 바뀔 때 그 변경 내역을 기록하고, 실제 데이터베이스에 적용하는 과정
        
        개발 과정에서 테이블 구조가 종종 바뀌게 되는데, 이 때 마이그레이션이 필요하다.
        
        데이터베이스 구조 변경 이력을 안전하게 기록하고 쉽게 적용할 수 있게 해준다.
        
        - **마이그레이션 생성**:
            
            Prisma 스키마 파일을 수정한 뒤, 아래 명령어로 마이그레이션 파일을 생성한다.
            
            ```jsx
            npx prisma migrate dev --name <migration-name>
            ```
            
            이때, `migrations/` 폴더에 SQL 파일이 자동으로 생성되고, 이 폴더에 변경 이력이 저장된다.
            
        - **마이그레이션 적용**:
            
            생성된 마이그레이션을 데이터베이스에 적용하는 명령어
            
            ```
            npx prisma migrate deploy
            ```
            
            위 명령어를 실행하면 변경된 구조가 실제 DB에 반영된다.
            
            같은 마이그레이션 파일을 적용하면 모두 동일한 데이터베이스 구조를 가질 수 있다!
            
        - **마이그레이션 히스토리 관리**
            
            Prisma는 **`prisma/migrations` 폴더**에 각 마이그레이션마다 별도의 폴더와 SQL 파일을 만들어, 데이터베이스 구조 변경 이력을 관리한다.
            
        - **데이터베이스 내 마이그레이션 상태 추적**
            
            Prisma는 데이터베이스 내부에 **`_prisma_migrations`**라는 테이블을 자동으로 만들어, 어떤 마이그레이션이 적용됐는지, 삭제됐는지, 변경됐는지 등을 추적한다.
            
            이를 통해 실제 DB와 코드의 마이그레이션 이력이 일치하는지 쉽게 확인할 수 있다.
            
- ORM(Prisma)을 사용하여 좋은 점과 나쁜 점
    
    <aside>
    
    **Prisma의 장점**
    
    - **타입 안전성**
        
        Prisma는 TypeScript와 통합되어, 쿼리에서 타입 오류를 컴파일 단계에서 잡아준다. 이로 인해, 런타임 에러를 줄일 수 있다!
        
    - **자동 완성 및 개발 편의성**
        
        Prisma Client는 쿼리 작성 시 코드 자동 완성 기능을 제공해 빠르고 정확한 코드를 작성할 수 있다.
        
    - **간결하고 직관적인 API**
        
        복잡한 ORM 객체 대신, 간단한 메서드로 데이터베이스 작업이 가능하다. SQL을 잘 몰라도 데이터베이스를 다룰 수 있다.
        
    - **마이그레이션 관리**
        
        Prisma Migrate를 통해 데이터베이스 스키마 변경을 안전하게 관리할 수 있다.
        
    - **유연한 협업 가능**
        
        Prisma의 스키마 파일 하나로 DB 구조를 한눈에 파악할 수 있다.
        
    </aside>
    
    <aside>
    
    **Prisma의 단점**
    
    - **복잡한 쿼리 한계**
        
        복잡한 SQL 쿼리(복잡한 join, 집계 등)는 Prisma의 추상화 레이어로 인해 직접 작성이 어렵거나, raw SQL을 써야 할 때가 있다.
        
    - **대용량/고성능 환경에서 한계**: 수백만~수천만 행 이상의 대규모 데이터 처리, 성능 튜닝, 세밀한 쿼리 최적화가 필요할 때는 한계가 있을 수 있다.
    - **유연성 부족**: Prisma는 쿼리 빌더가 없고, ORM 추상화로 인해 특수한 DB 작업에는 불편할 수 있다.
    </aside>
    
- 다양한 ORM 라이브러리 살펴보기
    - ex. Sequelize
        - **Sequelize**는 Node.js에서 가장 널리 쓰이는 ORM(Object-Relational Mapping) 라이브러리 중 하나이다.
        - 테이블과 컬럼을 자바스크립트 객체와 속성으로 매핑해서, SQL 쿼리를 직접 쓰지 않고도 데이터 조회, 생성, 수정, 삭제가 가능하다.
        - 모델 정의, 쿼리 생성, 트랜잭션 관리, 데이터 유효성 검사 등 다양한 기능을 제공한다.
        - Promise 기반으로 비동기 작업을 깔끔하게 처리할 수 있다.
    - ex. TypeORM
        - **TypeORM**은 Node.js에서 TypeScript와 자바스크립트 모두를 지원하는 ORM 라이브러리
        - 클래스와 데코레이터를 활용해 데이터베이스 테이블 구조(엔티티)를 정의하고, 객체처럼 데이터를 다룰 수 있다.
        - MySQL, PostgreSQL, MariaDB, SQLite, MS SQL Server, Oracle 등 다양한 데이터베이스를 지원한다.
        - 자동 마이그레이션, 트랜잭션 관리, 쿼리 빌더, 액티브 레코드/데이터 매퍼 패턴 등 다양한 기능을 제공한다.
        - NestJS 등 다양한 프레임워크와도 잘 통합된다.
- 페이지네이션을 사용하는 다른 API 찾아보기
    - ex. https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api?apiVersion=2022-11-28
        
        ### GitHub REST API
        
        - **방식**: 기본 값으로 한 번에 30개의 결과만 반환하고, 추가 데이터는 다음 페이지로 나눠서 제공한다.
        - **사용 방법**:
            - `per_page` : 한 페이지에 받을 데이터 개수를 지정
            - response의 `link` 헤더에 다음, 이전, 첫, 마지막 페이지의 URL이 담겨 있다.
            - 예시:
                
                ```
                GET /repos/octocat/Spoon-Knife/issues?per_page=2&page=2
                ```
                
                ```
                	link: <https://api.github.com/repositories/1300192/issues?page=2>;
                rel="prev",
                				<https://api.github.com/repositories/1300192/issues?page=4>;
                rel="next",
                				<https://api.github.com/repositories/1300192/issues?page=515>;
                rel="last",
                				<https://api.github.com/repositories/1300192/issues?page=1>;
                rel="first"
                ```
                
            - `link` 헤더의 URL을 따라가며 여러 페이지의 데이터를 순차적으로 받아올 수 있다.
    - ex. https://developers.notion.com/reference/intro#pagination
        
        ### **Notion API**
        
        - **방식**: 기본적으로 한 번에 최대 100개까지 반환하며, 더 많은 데이터가 있으면 `has_more: true`와 `next_cursor` 값을 response에 포함한다.
        - **사용 방법**:
            - 다음 페이지를 요청할 때 `start_cursor` 파라미터에 이전 응답의 `next_cursor` 값을 넣어 요청한다.
            - 예시:
                
                ```json
                { 
                	"object": "list",
                	"results": [...],
                	"next_cursor": "abc123",
                	"has_more": true
                }
                ```
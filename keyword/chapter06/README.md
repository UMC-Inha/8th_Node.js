- ORM
    
    ORM(Object-Relational Mapping) : 
    
    프로그래밍 언어의 객체(Object)와 관계형 데이터베이스(Relational Data)를 연결하는 기술이다.
    
    ```jsx
    const result = await connection.query('SELECT * FROM User WHERE id = ?', [1]);
    
    ```
    
    위처럼 node.js에서 동작하지만 schema.prisma에서 다음과 같이 설정을 한뒤 Node.js에서 간편하게 사용할 수 있다.
    
    ```jsx
    model User {
      id    Int    @id @default(autoincrement())
      name  String
      email String @unique
    }
    ```
    
    ```jsx
    const user = await prisma.user.findUnique({
      where: { id: 1 },
    });
    ```
    
    ORM의 핵심 기능
    
    - 모델과 테이블 매핑: 코드의 객체(모델)와 DB 테이블을 자동으로 연결
    - SQL 자동 생성: 객체 조작 → 내부적으로 SQL 쿼리 변환
    - 관계 표현: 모델끼리 관계 설정 → 자동으로 조인 쿼리 생성
    - 마이그레이션 관리: 스키마 변경 시 migration 파일 자동 생성
- Prisma 문서 살펴보기
    - ex. Prisma의 Connection Pool 관리 방법
        - Prisma는 내부적으로 Connection Pool을 사용한다.
        - Connection Pool은 미리 여러 개의 데이터베이스 연결을 만들어두고 요청마다 새 연결을 만드는 것을 방지한다.
        - 이로 인해 데이터베이스 연결 성능이 향상된다.
    - ex. Prisma의 Migration 관리 방법
        
        ![image.png](attachment:ed94cb63-04d5-46e6-8a8e-2367537a0165:image.png)
        
        모델/엔티티 우선 마이그레이션: 이 패턴을 사용하여 데이터베이스 스키마의 구조를 코드로 정의한 다음 마이그레이션 도구를 사용하여 애플리케이션과 데이터베이스 스키마를 동기화하는 등 SQL을 생성합니다.
        
        ![image.png](attachment:1274f0b2-c851-4a34-a7ae-e82cf64ec100:image.png)
        
        데이터베이스 우선 마이그레이션: 이 패턴을 사용하여 데이터베이스의 구조를 정의하고 SQL을 사용하여 데이터베이스에 적용합니다. 그런 다음 데이터베이스를 내부 검사하여 애플리케이션과 데이터베이스 스키마를 동기화하기 위해 데이터베이스의 구조를 설명하는 코드를 생성합니다.
        
- ORM(Prisma)을 사용하여 좋은 점과 나쁜 점
    - 생산성 향상
    개발자가 SQL 쿼리를 직접 작성하지 않고 객체 조작만으로 데이터베이스 작업이 가능하다. 모델 정의만 하면 CRUD(Create, Read, Update, Delete) 작업을 빠르게 개발할 수 있다.
    - 유지보수 편리
    코드가 명확하고 일관되기 때문에, 프로젝트 규모가 커져도 유지보수가 쉬워진다. 스키마 변경이 있을 때도 Prisma migrate 같은 도구로 쉽게 관리할 수 있다.
    - 타입 안전성
    Prisma와 같은 ORM은 TypeScript 타입을 자동 생성해주기 때문에 컴파일 단계에서 오류를 미리 잡을 수 있다. DB 필드 타입이 코드에 바로 반영된다.
    - 추상화와 일관성
    ORM이 데이터베이스 접근 방식을 추상화하기 때문에, 코드가 깔끔하고 일관된 형태로 유지된다. SQL 문법에 종속되지 않고 다양한 데이터베이스(MySQL, PostgreSQL 등)를 비슷한 방법으로 다룰 수 있다.
    - 관계형 데이터 간 매핑
    ORM은 여러 테이블 간의 관계(1:N, N:M)를 모델로 쉽게 표현할 수 있게 도와준다. 조인 쿼리를 직접 작성하지 않아도 관계 데이터를 가져올 수 있다.
- 다양한 ORM 라이브러리 살펴보기
    - ex. Sequelize
        - Sequelize
        
        Node.js에서 가장 많이 사용되는 ORM 중 하나다.
        JavaScript와 TypeScript 모두 지원한다.
        MySQL, PostgreSQL, SQLite, MariaDB, MSSQL 등 다양한 데이터베이스를 지원한다.
        
        - 장점
        1. 문서와 커뮤니티가 크다.
        2. 복잡한 관계 설정과 쿼리를 유연하게 다룰 수 있다.
        3. 트랜잭션, eager loading, lazy loading 같은 고급 기능 지원.
        - 단점
        1. TypeScript 지원은 있지만 Prisma나 TypeORM에 비해 타입 안전성이 낮다.
        2. 마이그레이션 관리가 복잡할 수 있다.
        3. 대형 프로젝트에서 성능 이슈가 보고된 사례가 있다.
    - ex. TypeORM
        - TypeORM은 Node.js와 TypeScript 환경을 위한 ORM이다.
        - 관계형 데이터베이스를 객체처럼 다룰 수 있게 해준다.
        - TypeScript와 자연스럽게 통합된다.
        - 엔티티 클래스(Entity Class)와 데코레이터(Decorator)를 사용해서 모델과 테이블을 정의한다.
        - Active Record 패턴과 Data Mapper 패턴 모두 지원한다.
        - 관계 설정(OneToOne, OneToMany, ManyToOne, ManyToMany)이 쉽다.
        
        ```jsx
        import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";
        
        @Entity()
        export class User {
            @PrimaryGeneratedColumn()
            id: number;
        
            @Column()
            name: string;
        
            @Column()
            email: string;
        }
        // 사용
        const user = await AppDataSource.manager.findOneBy(User, { id: 1 });
        ```
        
- 페이지네이션을 사용하는 다른 API 찾아보기
    - ex. https://docs.github.com/en/rest/using-the-rest-api/using-pagination-in-the-rest-api?apiVersion=2022-11-28
    - 결과가 너무 많으면 서버는 일부 결과만 반환하고 나머지는 페이지로 나눈다. 예를 들어 GitHub 이슈가 1600개면 기본적으로 30개씩 반환된다.
    
    ```bash
    curl --request GET \
    --url "https://api.github.com/repos/octocat/Spoon-Knife/issues"
    // 30개씩 반환됨
    ```
    
    - 링크 헤더 사용
        - 응답 헤더의 link 필드에 다음, 이전, 첫 페이지, 마지막 페이지의 URL이 포함된다. 이 링크를 따라가면서 추가 페이지의 데이터를 가져올 수 있다.
        
        ```bash
        link: <https://api.github.com/repositories/1300192/issues?page=2>; rel="next",
              <https://api.github.com/repositories/1300192/issues?page=515>; rel="last"
              // link 헤더에 다음 페이지와 마지막 페이지의 URL이 포함된다.
        ```
        
    - 페이지당 항목 수 변경
        - per_page 쿼리 매개변수를 사용하면 페이지당 반환할 항목 수를 조절할 수 있다. 예: per_page=2 로 설정하면 두 개씩 반환된다.
        
        ```bash
        curl --request GET \
        --url "https://api.github.com/repos/octocat/Spoon-Knife/issues?per_page=5"
        // 5개씩
        ```
        
    - 페이지 매김을 사용한 스크립팅
        - 수동으로 link 헤더의 URL을 복사하지 않고도 스크립트를 사용해서 여러 페이지의 데이터를 가져올 수 있다. 예를 들어 Octokit.js의 octokit.paginate()를 사용하면 마지막 페이지까지 모든 데이터를 자동으로 가져온다.
    - 페이지 매김 방법 생성
        - Octokit.js 같은 라이브러리를 사용하지 않는 경우 직접 페이지 매김 함수를 만들어 link 헤더의 다음 페이지 URL을 반복적으로 요청할 수 있다.
    - ex. https://developers.notion.com/reference/intro#pagination
    - Notion API는 페이지, 데이터베이스, 사용자 정보에 접근하도록 해주는 인터페이스다. 사용하려면 먼저 Notion에서 통합(integration)을 만들고 토큰을 받아야 한다.
    - 요청 형식
        - REST 방식(GET, POST, PATCH, DELETE) 사용
        - 요청과 응답은 JSON 형식
        
        ```bash
        curl --request GET \
        --url "https://api.notion.com/v1/pages/{page_id}" \
        --header "Authorization: Bearer {integration_token}"
        ```
        
    - JSON 규칙
        - object 속성으로 리소스 유형 구분 (예: "database", "user")
        - id는 UUIDv4 형식, 속성 이름은 snake_case 사용, 빈 문자열은 지원하지 않고 null을 사용해야 한다
        - Notion API는 통합 토큰으로 인증하고 RESTful 방식으로 요청을 보낸다. 페이지네이션은 next_cursor로 다음 데이터를 요청할 수 있다. JSON 포맷은 object, id, snake_case 규칙을 따른다.
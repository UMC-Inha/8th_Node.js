# ORM의 핵심 기능
- 모델과 테이블 매핑: 코드의 객체와 DB 테이블을 자동 연결
- SQL 자동 생성: 객체 조작 → SQL 변환
- 관계 표현: 모델끼리 관계 설정, 조인 쿼리 자동 생성
- 마이그레이션 관리: 스키마 변경 시 migration 파일 자동 생성

#Prisma 특징
##Connection Pool 관리
- 내부적으로 Connection Pool 사용
- 매번 새로운 연결 생성하지 않고 성능 향상
##Migration 관리
- 모델 우선: 코드로 모델 정의 → migration 생성
- DB 우선: DB 구조 정의 → 코드로 반영

#ORM(Prisma)의 장단점
##장점
- 생산성 향상: SQL 작성 없이 객체 조작으로 DB 작업 가능
- 유지보수 편리: 코드가 명확하고 일관됨
- 타입 안전성: TypeScript 타입 자동 생성
- 추상화와 일관성: 다양한 DB 지원
- 관계형 데이터 매핑: 관계 표현이 쉬움
##단점
- 복잡한 쿼리는 성능 이슈 가능성
- ORM 학습 비용 발생

#다양한 ORM 라이브러리
##Sequelize
- Node.js에서 가장 인기

- MySQL, PostgreSQL, SQLite, MariaDB, MSSQL 지원

##장점

- 문서/커뮤니티 활성화

- 복잡한 관계 지원

- 고급 기능 제공 (트랜잭션, eager/lazy loading)

## 단점

- TypeScript 타입 안전성이 낮음

- 대규모 프로젝트에서 성능 이슈 가능

## TypeORM
- Node.js & TypeScript 환경

- 데코레이터를 사용한 모델 정의

- Active Record & Data Mapper 패턴 지원
```
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

const user = await AppDataSource.manager.findOneBy(User, { id: 1 });
```
#페이지네이션 참고 사례
##GitHub REST API
```
curl --request GET \
--url "https://api.github.com/repos/octocat/Spoon-Knife/issues?per_page=5"

```
### Link 헤더: 다음 페이지, 마지막 페이지 URL 포함
```
link: <...page=2>; rel="next", <...page=515>; rel="last"

```

###Notion API
```
curl --request GET \
--url "https://api.notion.com/v1/pages/{page_id}" \
--header "Authorization: Bearer {integration_token}"

```
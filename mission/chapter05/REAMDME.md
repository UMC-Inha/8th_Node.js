## 로그인 처리 플로우

[브라우저/앱] ──► 1. Express 서버 (index.js)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 2. 컨트롤러 (user.controller.js) ← (HTTP Body)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 3. DTO (user.dto.js) ← (body ↔ 자바스크립트 객체 정제)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 4. 서비스 (user.service.js) ← (비즈니스 로직)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 5. 레포지토리 (user.repository.js) ← (SQL 실행)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 6. MySQL 풀 (db.config.js)

## Service 코드 분석

userSignUp 함수는 회원가입이라는 하나의 큰 작업을 처리하는 서비스 계층 함수이다.  
회원가입 로직은 다음 세 가지 단계로 나뉜다.

1. 새로운 사용자(User)를 데이터베이스에 추가한다.
2. 사용자가 선택한 선호(preference) 정보를 추가로 저장한다.
3. 가입한 사용자 정보를 조회하고, 이를 가공하여 클라이언트에 반환한다.

구체적인 흐름은 다음과 같다.

- 먼저 addUser()를 호출하여 user 테이블에 새로운 사용자를 추가한다.  
  삽입에 성공하면 새로 생성된 사용자의 id를 반환하고,  
  만약 null이 반환되면 이미 존재하는 이메일이므로 에러를 발생시킨다.

- 그 다음 사용자가 선택한 음식 카테고리 목록을 순회하면서,  
  각 카테고리에 대해 setPreference()를 호출하여 user_favor_category 테이블에 매핑을 저장한다.

- 마지막으로, 가입이 완료된 사용자의 정보를 getUser()로 조회하고,  
  사용자의 선호 카테고리 정보를 getUserPreferencesByUserId()로 조회하여 가져온다.

- 조회한 정보를 responseFromUser()를 통해 DTO(Data Transfer Object) 형태로 변환하여 최종적으로 반환한다.

정리하면, userSignUp 함수는 데이터 삽입, 비즈니스 로직 처리, 데이터 가공까지 한 번에 담당하는 회원가입 전체 프로세스를 수행한다.

---

## Repository 코드 분석

Repository 계층은 데이터베이스에 실제로 접근하여 SQL 쿼리를 수행하는 역할을 한다.  
코드의 주요 목표는 데이터 조작(CRUD) 작업을 담당하고, 서비스 계층과 분리하여 코드 구조를 깔끔하게 유지하는 것이다.

user.repository.js 파일에는 다음과 같은 네 가지 함수가 정의되어 있다.

1. 사용자 추가 (addUser)  
   - user 테이블에 새로운 사용자 레코드를 추가한다.  
   - 삽입 전에 이메일 중복 여부를 확인하여 이미 존재하는 이메일이면 삽입을 막는다.

2. 사용자 정보 조회 (getUser)  
   - 사용자 id를 기반으로 user 테이블에서 사용자 정보를 조회한다.  
   - 조회된 사용자 객체를 반환하며, 존재하지 않으면 null을 반환한다.

3. 사용자 선호 카테고리 추가 (setPreference)  
   - 특정 사용자와 음식 카테고리 간의 선호 관계를 user_favor_category 테이블에 저장한다.

4. 사용자 선호 카테고리 조회 (getUserPreferencesByUserId)  
   - user_favor_category 테이블과 food_category 테이블을 JOIN하여,  
   - 사용자가 선택한 모든 음식 카테고리 정보를 조회하고 반환한다.

각 함수는 데이터베이스 연결 풀(pool)에서 커넥션을 얻어온 후,  
try-catch-finally 블록을 사용해 오류를 안전하게 처리하고, 작업이 끝난 후 연결을 반환한다.

정리하면, Repository 계층은 직접 SQL 쿼리를 실행하여 데이터베이스와 상호작용하는 모든 책임을 지고 있으며, 서비스 계층은 이 함수를 호출해서 필요한 데이터를 얻거나 저장한다.

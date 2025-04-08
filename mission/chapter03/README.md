시니어챌린지 블로그 링크
<https://velog.io/@seoki180/UMC-API-%EC%84%A4%EA%B3%84>

![초기구상](attachment:c8a6a22a-9841-4f75-8487-4a029af3f2e2:image.png)

초기구상

### 수정사항 1 .  PATCH로 유저정보나 리뷰정보를 수정할때 서버에서는 어떤 값을 받는지 모른다

해결 1.

```sql

if "name" in body:
update_name(user_id, body["name"])
if "password" in body:
update_password(user_id, body["password"])
```

서버에서 하나하나 체크하기

해결2.

```json

{
"updateFields": ["name", "password"],
"name": "새이름",
"password": "새비번"
}
```

업데이트 필드 추가

### 수정사항 2. 어차피 Request Header에 토큰을 넣어서 구현하는데 굳이 PATH 변수{user_index}가 있을 이유가 없다

URI에서 user_index를 삭제

### 기타 1. 미션조회를 내미션과 지역별로 나눠놓은 이유

내 미션은 token의 user_index를 바탕으로 status = 1 or 2를 조회하게 한다. 이때 path variable로 설정하면 /mission/1 이라고 할때 1번 미션을 말하는지, 미션 상태가 1인지를 알 수 없기 떄문에 쿼리스트링으로 바꿨다.

반면 지역별 미션조회는 누가 미션의 상태가 1인(시작전)인 미션을 지역을 기준으로 받아오기때문에 user_index는 필요하지 않다. 따라서 두 api를 분리했다.

| 기능명 | 메서드 | URI | Request Header | 요청 Body / 쿼리스트링 |
| --- | --- | --- | --- | --- |
| **회원가입** | POST | `/signup` | none | `{ id, password, name, email, gender, address, preferred_food }` |
| **로그인** | POST | `/login` | none | `{ id, password }` |
| **유저 정보 조회** | GET | `/user` | `Authorization: Bearer <token>` | none |
| **유저 정보 수정** | PATCH | `/user` | `Authorization: Bearer <token>` | `{ id, password, name, emial, phone, address}`  |
| **회원 탈퇴** | DELETE | `/user` | `Authorization: Bearer <token>` | none |
| **문의 등록** | POST | `/inquiry` | `Authorization: Bearer <token>` | `{ title, content, image, category }` |
| **문의 내역 조회** | GET | `/inquiry` | `Authorization: Bearer <token>` | none |
| **미션 조회 (내 미션)** | GET | `/mission?mission_status` | `Authorization: Bearer <token>` | `{ mission_status? }` |
| **미션 조회 (지역별)** | GET | `/mission/{area_index}` | `Authorization: Bearer <token>` | none |
| **미션 시작** | PATCH | `/mission/{mission_index}/start` | `Authorization: Bearer <token>` | none |
| **미션 완료** | PATCH | `/mission/{mission_index}/complete` | `Authorization: Bearer <token>` | none |
| **리뷰 작성** | POST | `/review` | `Authorization: Bearer <token>` | `{ title, content, rating , image }`  |
| **리뷰 조회 (식당별)** | GET | `/review/{store_index}` | `Authorization: Bearer <token>` | none |
| **리뷰 수정** | PATCH | `/review/{review_index}` | `Authorization: Bearer <token>` | `{ title, content, rating, image }` |
| **리뷰 제거** | DELETE | `/review/{review_index}` | `Authorization: Bearer <token>` | none |
| **작성 리뷰 조회** | GET | `/review` | `Authorization: Bearer <token>` | none |
| **포인트 내역 조회** | GET | `/point` | `Authorization: Bearer <token>` | none |
| **포인트 전환 신청** | POST | `/point/change` | `Authorization: Bearer <token>` | `{ point }` |

---

# 프로젝트 API 명세서

## 목차
1. 홈 화면 조회 (GET)
2. 마이페이지 조회 (GET)
3. 리뷰 작성 (POST)
4. 미션 목록 조회 (GET)
5. 미션 성공 요청 (POST)
6. 회원 가입 (POST)

***

1. 홈 화면 조회 (GET)

- Endpoint: GET /umc/users/{userId}/home
- Path Variable: userId
- Request Header:
    - Authorization: {access_token}
    - Content-Type: application/json
```

***

2. 마이페이지 조회 (GET)

- Endpoint: GET /users/{userId}/mypage
- Path Variable: userId
- Request Header:
- Authorization: {access_token}

***

3. 리뷰 작성 (POST)

- Endpoint: POST /stores/{storeId}/reviews
- Path Variable: storeId
- Request Header: Authorization: {access_token}
- Request Body :
```
{
  "rating": 4.5,
  "review": "음식이 정말 맛있어요!",
  "images": ["image1.png", "image2.png"]
}
```

***


4. 미션 목록 조회 (GET)

- Endpoint: GET /users/{userId}/missions
- Path Variable: userId
- Request Header:
- Request Body:
```
{
  "userId": "mindongil",
  "missions": [
    {
      "missionId": 1,
      "title": "가게이름",
      "description": "12,000원 이상의 식사를 하세요!",
      "points": 500,
      "status": "성공",
    },
    {
      "missionId": 2,
      "title": "가게이름",
      "description": "12,000원 이상의 식사를 하세요!",
      "points": 500,
      "status": "서ㅇ공,
    }
  ]
}
```
- Authorization: {access_token}
- Query String: 미션 상태 (진행중, 진행 완료)

***

5. 미션 성공 요청 (POST)

- Endpoint: POST /missions/{missionId}/success
- Path Variable: missionId
- Request Header: Authorization: {access_token}

***

6. 회원 가입 (POST)
- Endpoint: POST /users/login
- Request Header:
    - Authorization: {access_token}
    - Content-Type: application/json
- Request Body:
```
{
  "username": "hello",
  "email": "dfausf@naver.com",
  "password": "1234567@",
  "gender": "남",
  "birthDate": "2025-04-20",
  "address": "인하대학교",
  "preferences": ["한식", "치킨", "고기/구이"]
}
```
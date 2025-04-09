# 3주차 미션 기록


### 1. 홈 화면 API

- 홈 화면에 필요한 데이터 : 위치 정보, 미션 달성 현황, 미션 기한, 도전 가능한 미션 목록
- **API 엔드포인트:** `GET /users/{userId}/home`
- **Request Header:**
    
    ```
    Authorization: Bearer {access_token}
    Content-Type: application/json
    ```
    
    - **Path Variable:**
        - `userId`: 로그인한 사용자의 ID
- **Response Body:**

```json
{
  "region": "안암동", // 현재 설정된 지역
  "missionProgress": { // 미션 달성 현황
    "completed": 7,   // 완료된 미션 개수
    "total": 10,      // 전체 미션 개수
  },
  "myMissions": [ // 도전 가능한 미션 목록
    {
      "missionId": 1,
      "shopId": 12,
      "shopName": "반이학생마라탕",
      "shopCategory": "중식당",
      "dueDate": 7,
      "point": 500,
      "description": "10,000원 이상의 식사 시 500 포인트 적립",
      "status": "in_progress" // 미션 상태 (in_progress, completed)
    },
    {
      "missionId": 2,
      "shopId": 33,
      "shopName": "상점2",
      "shopCategory": "한식",
      "dueDate": 7,
      "point": 500,
      "description": "미션 설명",
      "status": "in_progress"
    }
  ]
}
```

- **설명:**
    - **Response Body:** 설정된 지역, 미션 진행상황, 도전 가능한 미션 리스트를 반환

### 2. 마이 페이지 리뷰 작성 API

- 사용자가 상점에 대한 리뷰를 작성하고 저장한다.
- **API 엔드포인트:** `POST /shops/{shopId}/reviews`
- **Request Header:**
    
    ```
    Authorization: Bearer {access_token}
    Content-Type: application/json
    ```
    
    - **Path Variable:**
        - `shopId`: 사용자가 리뷰를 작성할 상점의 ID
- **Request Body:**
    
    ```json
    {
      "shopId": 123,
      "rating": 4.5, // 평점(0 ~ 5)
      "comment": "맛있어요!",
      "imageUrls": [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg"
      ]
    }
    ```
    
- **Response Body**
    - **성공:**
        
        ```json
        {
          "reviewId": 456, // 생성된 리뷰 ID
          "message": "리뷰가 등록되었습니다."
        }
        ```
        
    - **오류:**
        
        ```json
        {
          "error": "잘못된 요청",
          "message": "평점은 0.0에서 5.0 사이의 값이어야 합니다."
        }
        ```
        
- **설명:**
    - **Request Body:** 리뷰가 작성된 미션 ID, 평점, 리뷰 내용, 이미지 URL을 포함
    - **오류 처리:** 미션 ID가 유효하지 않을 경우 오류 메시지를 반환

### 3. 미션 목록 조회 API (진행 중)

- 현재 진행 중인 미션 목록 가져오기
- **API 엔드포인트:** `GET /users/{userId}/missions?status=in_progress`
- **Request Header:**
    
    ```
    Authorization: Bearer {access_token}
    Content-Type: application/json
    ```
    
- **쿼리 파라미터:**
    - `status`: `in_progress`
- **Path Variable:**
    - `userId`: 로그인한 사용자의 ID
- **Response Body:**

```json
[ 
	{ 
		"missionId": 3, 
		"title": "진행 중인 미션 제목1", 
		"description": "진행 중인 미션 설명1", 
		"point": 150 
	},
	 { 
		 "missionId": 4, 
		 "title": "진행 중인 미션 제목2", 
		 "description": "진행 중인 미션 설명2", 
		 "point": 100 
	 }
]
```

- **설명:**
    - **쿼리 파라미터:** `status=in_progress`를 통해 진행 중인 미션만 보여줌
    - **Response Body:** 진행 중인 미션의 목록을 반환하고, 미션 ID, 제목, 설명, 리워드를 포함

### 4. 미션 목록 조회 API (진행 완료)

- 완료된 미션 목록 가져오기
- **API 엔드포인트:** `GET /users/{userId}/missions?status=completed`
- **요청 헤더:**
    
    ```
    Authorization: Bearer {access_token}
    Content-Type: application/json
    ```
    
- **쿼리 파라미터:**
    - `status`: `completed`
- **Path Variable:**
    - `userId`: 로그인한 사용자의 ID
- **Response Body:**

```json
[ 
	{ 
		"missionId": 1, 
		"title": "완료된 미션 제목1",
		"description": "미션 설명1", 
		"completedAt": "2025-01-01", 
		"point": 100
	 },
	 { 
		 "missionId": 2,
		 "title": "완료된 미션 제목2",
		 "description": "미션 설명2",
		 "completedAt": "2025-01-01",
		 "point": 200
	 }
]
```

- **설명:**
    - **쿼리 파라미터:** `status=completed`를 통해 완료된 미션만 보여줌
    - **Response Body:** 완료된 미션의 목록을 반환하고, 미션 ID, 제목, 설명, 완료 날짜, 리워드를 포함

### 5. 미션 성공 클릭 API

- 미션 성공 요청 시 인증번호를 확인하고 사용자에게 포인트 지급
- **API 엔드포인트:** `POST /missions/{missionId}/success`
- **요청 헤더:**
    
    ```
    Authorization: Bearer {access_token}
    Content-Type: application/json
    ```
    
- **Path Variable:**
    - `missionId`: 성공으로 표시할 미션의 ID
- Request Body:

```json
{
  "businessRegistrationNumber": "920394810",  // 사업자 구분 번호
  "purchaseAmount": 12000                    // 구매 금액
}
```

- **Response Body (성공):**

```json
{
	"message": "미션이 성공적으로 완료되었습니다.",
	"point": 100,       // 리워드
	"newPoint": 1234,    // 갱신된 총 포인트
	"missionStatus": "completed",
	"reviewAvailable": true        // 리뷰 작성 가능 여부
}
```

- **Response Body (인증번호 불일치):**

```json
{
	"error": "인증 실패",
	"message": "사업자 구분 번호가 일치하지 않습니다."
}
```

- **Response Body (구매 금액 조건 미충족):**

```json
{
  "error": "조건 미충족",
  "message": "일정 금액 이상 결제 시 미션이 완료됩니다."
}
```

- **Response Body (오류):**

```json
{
	"error": "미션 완료 실패",
	"message": "미션을 완료할 수 없습니다."
}
```

- **설명:**
    - **Path Variable:** URL의 엔드포인트에 미션 ID를 포함
    - **Response Body:** 성공 메시지, 리워드, 사용자 포인트 잔액을 반환함

### 6. 회원 가입 API

- 새로운 사용자 등록
- **API 엔드포인트:** `POST /users/login`
- **요청 헤더:**
    
    ```
    Authorization: Bearer {access_token}
    Content-Type: application/json
    ```
    
- **Request Body:**

```json
{
	"email": "user@example.com",
	"password": "password123",
	"name": "사용자 이름",
	"gender": "남",
	"birthdate": "2000-01-01",
	"phoneNumber": "010-1234-1234",
	"address": "인천광역시 미추홀구 용현동"
}
```

- **Response Body (성공):**

```json
{
	"message": "회원가입이 완료되었습니다.",
	"userId": 123
}
```

- **Response Body (오류):**

```json
{
	"error": "회원가입 실패",
	"message": "이미 존재하는 이메일입니다."
}
```

- **설명:**
    - **Request Body:** 사용자의 이메일, 비밀번호, 이름 등 포함
    - **오류 처리:** 이메일이 이미 존재할 경우 오류 메시지를 반환
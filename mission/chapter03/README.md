- 홈 화면 불러오기
    - Endpoint: GET /user/info
    - Request Body: none
    - Request Header: userId - 로그인 된 유저의 ID 정보
    - Query String: area - 유저의 지역 정보
    - Path Variable: none

- 마이 페이지 리뷰 작성
    - Endpoint: POST /review/postReview
    - Request Body:
        
        ```json
        {
        	"review_title": "리뷰 제목",
        	"review_content": "리뷰 내용:",
        	"review_rating": 4
        }
        ```
        
    - Request Header: user.id
    - Query String: none
    - Path Variable: none

- 미션 목록 조회
    - Endpoint: GET /user/{userId}/mission/{status}
    - Request Body: none
    - Request Header: userId - 유저의 ID
    - Query String: none
    - Path Variable: status - 미션의 수락 여부

- 미션 완료
    - Endpoint: PATCH /user/mission/success/{id}
    - Request Body: none
    - Request Header: userId - 유저의 ID
    - Query String: none
    - Path Variable: id - 완료할 미션의 id

- 유저 회원가입
    - Endpoint: POST /user/signUp
    - Request Body:
        
        ```json
        {
        	"username": "유저 이름",
        	"gender": 1,
        	"birth": "2002-02-26 00:00:00",
        	"address": "유저의 주소",
        	"phone": "010-1234-5678",
        	"email": "user@user.net"
        }
        ```
        
    - Request Header: none
    - Query String: none
    - Path Variable: none
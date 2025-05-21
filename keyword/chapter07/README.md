- 미들웨어
    
    ### 미들웨어(Middleware)란?
    
    미들웨어는 요청(Request)과 응답(Response) 사이에서 동작하는 함수이다.
    
    사용자가 서버에 요청을 보내면, 이 요청이 최종 응답을 받기까지 여러 미들웨어를 거치며 필요한 작업을 처리한다.
    
    ---
    
    ### 미들웨어의 역할
    
    - 요청/응답 객체(req, res) 수정
    - 요청을 로그로 남기거나, 인증/권한 검사
    - 요청 데이터 파싱(예: JSON, 폼 데이터)
    - `next()`를 호출해 다음 미들웨어 함수로 제어를 넘김
    - 에러 처리
    - 정적 파일 제공 등
    
    ---
    
    ### 미들웨어의 동작 방식
    
    ```jsx
    function myMiddleware(req, res, next) {
      *// 요청 처리 코드*
      next(); *// 다음 미들웨어로 넘김*
    }
    ```
    
    - `req`: 요청 객체
    - `res`: 응답 객체
    - `next`: 다음 미들웨어를 호출하는 함수
    
    미들웨어는 `app.use(myMiddleware)`처럼 등록해서 사용한다.
    
    여러 개의 미들웨어를 등록하면, 요청이 위에서 아래로 차례대로 미들웨어를 실행한다.
    
    만약 미들웨어에서 응답을 보내면(`res.send()` 등), 그 이후 미들웨어는 실행되지 않는다.
    
    ---
    
    ### **미들웨어의 종류**
    
    Express에서는 다양한 방식으로 미들웨어를 사용할 수 있다.
    
    **1. 애플리케이션 레벨 미들웨어**
    
    - 모든 요청 또는 특정 경로에 대해 동작하는 미들웨어
    - `app.use()` 또는 `app.method()`로 등록
        - `app.method()`(예: `app.get`, `app.post`)
    - **특징:**
        - 마운트 경로를 지정하지 않으면 모든 요청에 대해 실행된다.
        - 특정 경로를 지정하면 그 경로에만 적용된다.
        - 여러 개를 연달아 등록할 수 있으며, **등록 순서대로 실행**된다.
    
    ```jsx
    *// 모든 요청에 대해 실행*
    app.use((req, res, next) => {
      console.log('Time:', Date.now());
      next();
    });
    
    *// 특정 경로에만 실행*
    app.use('/user/:id', (req, res, next) => {
      console.log('Request Type:', req.method);
      next();
    });
    ```
    
    **2. 라우터 레벨 미들웨어**
    
    - `express.Router()` 인스턴스에 바인딩하여 사용
    - 특정 라우터(서브 경로) 단위로 미들웨어를 적용한다.
    - **특징:**
        - 대규모 프로젝트에서 라우터별로 미들웨어를 분리하여 관리할 때 유용하다.
        - 코드의 구조화와 유지보수에 좋음
    
    ```jsx
    const router = express.Router();
    
    router.use((req, res, next) => {
      console.log('Router-level middleware');
      next();
    });
    
    //app.use('/', router); // 전체에 적용됨
    app.use('/api', router); // /api 경로 하위에만 적용
    ```
    
    **3. 오류 처리 미들웨어**
    
    - 요청 처리 중 에러가 발생했을 때만 실행되는 미들웨어
    - 4개의 인수 `(err, req, res, next)`를 가짐
    - 서버 에러 로깅, 사용자에게 에러 메세지 전달, 에러 페이지 렌더링 등
    
    ```jsx
    app.use((err, req, res, next) => {
      console.error(err.stack);
      res.status(500).send('오류 발생!');
    });
    ```
    
    **4. 기본 제공 미들웨어**
    
    - Express 내장 미들웨어(ex: `express.static`)로 Express에서 기본적으로 제공하는 미들웨어
    - 웹사이트의 정적 리소스 제공, 요청 데이터 파싱 등
        - `express.static`: 정적 파일(HTML, CSS, JS, 이미지 등) 제공
            
            ```jsx
            app.use(express.static('public'));
            ```
            
        - `express.json`, `express.urlencoded`: JSON 및 URL-encoded 데이터 파싱
    
    **5. 써드파티(외부) 미들웨어**
    
    - 외부 패키지로 설치하여 사용하는 미들웨어
        
        ```jsx
        const cookieParser = require('cookie-parser');
        app.use(cookieParser());
        ```
        
    - 예시
        - `morgan`: HTTP 요청 로깅
        - `cookie-parser`: 쿠키 파싱
        - `body-parser`: 요청 본문 파싱 (Express 4.16.0 이상에서는 내장)
        - `helmet`: 보안 관련 헤더 설정
        - `cors`: CORS(Cross-Origin Resource Sharing) 활성화
    
    ---
    
    ### 미들웨어 예시:
    
    ```jsx
    // 여러 미들웨어를 한 경로에 연결할 수도 있다.
    app.use('/user/:id',
      (req, res, next) => {
        console.log('Request URL:', req.originalUrl);
        next();
      },
      (req, res, next) => {
        console.log('Request Type:', req.method);
        next();
      }
    );
    ```
    
    이 경우 `/user/:id` 경로로 요청이 들어오면,
    
    1. 첫 번째 미들웨어가 실행되어 `Request URL: ...`이 먼저 출력된다.
    2. `next()`가 호출되면서 두 번째 미들웨어로 넘어가 `Request Type: ...`이 출력된다.
    
    **미들웨어는 등록된 순서대로 차례로 실행**되며, 각 미들웨어에서 `next()`를 호출해야 다음 미들웨어로 넘어간다!
    
- HTTP 상태 코드
    
    웹에서 클라이언트(브라우저, 모바일 앱)가 서버에 요청(Request)을 보냈을 때, 서버가 그 요청을 어떻게 처리했는지 **3자리 숫자**로 알려주는 신호
    
    이 코드를 통해 클라이언트는 요청이 성공했는지, 실패했는지, 추가 행동이 필요한지 등을 쉽게 알 수 있다!
    
    ### HTTP 상태 코드 구조
    
    - **3자리 숫자**(예: 200, 404, 500)
    - 첫 번째 숫자(1~5)는 큰 범주로서, HTTP 응답의 종류를 구분하는데 사용
    - 나머지 2개의 숫자는 세부적인 응답 내용을 구분하기 위한 번호
    - 100~500번 대까지의 상태 코드가 정의됨
    
    상태 코드를 크게 5가지로 보면,
    
    | 상태 코드 | 의미 | 대표 코드 및 설명 |
    | --- | --- | --- |
    | 1xx | 정보(Informational) | 서버가 요청을 잘 받았고, 계속 진행 중임 (예: 100) |
    | 2xx | 성공(Success) | 요청이 정상적으로 처리됨 (예: 200 OK, 201 Created) |
    | 3xx | 리다이렉션(Redirection) | 추가 동작(다른 URL로 이동 등)이 필요함 (예: 301, 302, 304) |
    | 4xx | 클라이언트 오류(Client Error) | 요청에 문제가 있음 (예: 400, 401, 403, 404) |
    | 5xx | 서버 오류(Server Error) | 서버가 요청을 처리하지 못함 (예: 500, 502, 503) |
    
    ### 대표적인 상태 코드 예시
    
    - **`200 OK`**: 요청이 성공적으로 처리됨(정상적인 응답)
    - **`201 Created`**: 요청이 성공적으로 처리되어 새로운 리소스가 생성됨 (예: 회원가입)
    - **`301 Moved Permanently`**: 요청한 페이지가 영구적으로 다른 곳으로 이동됨
    - **`302 Found`**: 요청한 페이지가 임시로 다른 곳에 있음
    - **`304 Not Modified`**: 이전과 변경된 내용이 없으니, 클라이언트가 가진 캐시를 사용해도 됨
    - **`400 Bad Request`**: 잘못된 요청(문법 오류 등)
    - **`401 Unauthorized`**: 인증이 필요함(로그인 필요)
    - **`403 Forbidden`**: 접근 권한이 없음
        - 로그인이 필요한 페이지에 로그인 없이 접근할 때 401 또는 403 발생
    - **`404 Not Found`**: 요청한 페이지나 파일을 찾을 수 없음
        - 브라우저에서 없는 주소로 접속할 때 발생
    - **`500 Internal Server Error`**: 서버 내부에서 오류가 발생함
    - **`503 Service Unavailable`**: 서버가 일시적으로 요청을 처리할 수 없음(점검 중 등)
    
    ### HTTP 상태 코드가 중요한 이유는..
    
    - 사용자는 상태 코드에 따라 알맞은 안내 메시지 볼 수 있다.
    - 개발자는 상태 코드를 통해 문제가 클라이언트 쪽인지, 서버 쪽인지 빠르게 파악할 수 있다.
    - API 개발 측면에서 상태 코드를 통해 성공/실패, 오류 원인을 클라이언트에게 명확히 전달할 수 있다.
- 미들웨어
    - 요청 오브젝트, 응답 오브젝트, 애플리케이션의 요청 - 응답 주기 중 그 다음의 미들웨어 함수에 대한 액세스 권한을 갖는 함수.
    - next라는 이름의 변수로 표시함.
    - 다음과 같은 작업을 수행할 수 있음
        - 모든 코드 실행
        - 요청, 응답 오브젝트에 대한 변경 실행
        - 요청 - 응답 주기 종료
        - 스택 내의 그 다음 미들웨어 함수를 호출
    - 현재의 미들웨어 함수가 요청-응답 주기를 종료하지 않는다면 next()를 호출하여 그 다음 미들웨어 함수로 제어를 전달해야 함.
    - 애플리케이션 레벨 미들웨어
        - app.use(), app.METHOD() 함수를 이용해 애플리케이션 미들웨어를 app 오브젝트의 인스턴스에 바인드 할 수 있음.
        - 마운트 경로가 없는 경우
            
            ```jsx
            const app = express()
            
            app.use((req, res, next) => {
              console.log('Time:', Date.now())
              next()
            })
            ```
            
            모든 요청을 수신할 때마다 실행되는 코드.
            
        - 마운트 경로를 제시한 경우
            
            ```jsx
            app.use('/user/:id', (req, res, next) => {
              console.log('Request Type:', req.method)
              next()
            })
            ```
            
            /user/:id라는 경로에 대한 모든 요청에 대해 실행.
            
        - 라우트 및 라우트의 핸들러 함수(미들웨어 시스템)
            
            ```jsx
            app.get('/user/:id', (req, res, next) => {
              res.send('USER')
            })
            ```
            
            /user/:id라는 경로의 get 요청을 처리함.
            
        - 하나의 마운트 경로로 일련의 미들웨어 함수 로드
            
            ```jsx
            app.use('/user/:id', (req, res, next) => {
              console.log('Request URL:', req.originalUrl)
              next()
            }, (req, res, next) => {
              console.log('Request Type:', req.method)
              next()
            })
            ```
            
        - 라우트 핸들러를 통한 여러 라우트 정의. 하위 미들웨어 스택 구현
            
            ```jsx
            app.get('/user/:id', (req, res, next) => {
              console.log('ID:', req.params.id)
              next()
            }, (req, res, next) => {
              res.send('User Info')
            })
            
            // handler for the /user/:id path, which prints the user ID
            app.get('/user/:id', (req, res, next) => {
              res.end(req.params.id)
            })
            ```
            
            코드상으로는 문제가 없지만 첫번째 라우터에서 요청-응답을 res.send()로 끝낸 상태. 따라서 두 번째 하위 스택 라우터는 호출되지 않는다.
            
        - 스택에서 다음 라우트 미들웨어로 건너뛰기
            
            ```jsx
            app.get('/user/:id', (req, res, next) => {
              // if the user ID is 0, skip to the next route
              if (req.params.id === '0') next('route')
              // otherwise pass the control to the next middleware function in this stack
              else next() //
            }, (req, res, next) => {
              // render a regular page
              res.render('regular')
            })
            
            // handler for the /user/:id path, which renders a special page
            app.get('/user/:id', (req, res, next) => {
              res.render('special')
            })
            ```
            
            next(’route’)를 사용하면, 현 스택의 미들웨어를 건너뛰고 다음 스택의 미들웨어로 제어를 옮길 수 있다.
            
    - 오류 처리 미들웨어
        - (err, req, res, next)라는 4개의 인자가 필요하다.
            
            ```jsx
            app.use((err, req, res, next) => {
              console.error(err.stack)
              res.status(500).send('Something broke!')
            })
            ```
            
        - 오류 처리 미들웨어는 app.use() 및 라우트 호출을 정의한 후에 **마지막으로 정의**해야 한다.
- HTTP 상태 코드
    - 서버의 처리 결과를 상태 코드로 정의하는 것
    - 세 자리 수로 되어 있고 첫째 자리 수는 HTTP 응답의 종류, 나머지 2개의 숫자로 세부적인 응답 내용을 구분함.
        - 1__ - 정보제공. 임시적인 응답으로 클라이언트까지의 요청은 처리되었으나 추가적으로 진행해야 하는 작업이 있음.
        - 2__ - 성공. 서버에서 클라이언트로 응답이 정상적으로 전송됨.
        - 3__ - 리다이렉션. 완전한 처리를 위해서 추가적인 동작이 필요함. 또다른 주소로 이동해야 하는 경우.
        - 4__ - 클라이언트 에러. 없는 페이지 요청, 요청 형식, 권한 등 클라이언트에서의 요청에 에러가 있는 경우.
        - 5__ - 서버 에러. 서버 과부하, DB 에러 등을 의미함.
    - 자주 사용하는 코드들
        - 200 - 성공 코드. 요청이 처리되었으면 반환됨.
        - 400 - Bad Request. 요청의 구문이 잘못되었을 때.
        - 401 - Unauthorized. 리소스에 대한 액세스 권한이 없다.
        - 403 - Forbidden. 리소스에 대한 액세스가 금지되었다.
        - 404 - Not Found. 지정한 리소스가 없다.
        - 500 - Internal Server Error - 서버 내부에서 에러가 발생하였다.
        - 502 - Bad Gateway - 게이트웨이, 프록시 서버가 그 후방의 서버에서 잘못된 응답을 받음.
    - 참고
        
        https://developer.mozilla.org/ko/docs/Web/HTTP/Reference/Status
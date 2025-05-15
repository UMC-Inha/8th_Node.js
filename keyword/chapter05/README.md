- 환경 변수
    - Environment Variable - 프로세스가 컴퓨터에서 동작하는 방식에 영향을 미치는 동적인 값들의 모임.
    - 윈도우, Linux에서 나오는 PATH가 대표적인 환경변수이다.
    - 우리가 워크북에 사용하는 환경변수는 데이터베이스의 이름, 데이터베이스 유저, 비밀번호, 외부 API의 key 등등의 민감한 정보를 담는데 사용한다.
    - 이러한 값들을 .env에 저장하고, dotenv 라이브러리로 관리한다. .gitignore로 github에 민감한 정보가 커밋되고 push되는 것을 막을 수 있다.
- CORS
    - Cross-Origin Resource Sharing
    - 브라우저 동일 출처 정책을 완화하여 다른 도메인, 프로토콜, 포트에서 리소스를 로드할 수 있도록 혀용하는 보안 메커니즘.
    - 서버가 웹 브라우저에서 해당 정보를 읽는 것이 혀용된 출처를 설명할 수 있도록 새로운 HTTP 헤더를 추가하는 방식으로 동작한다.
    - 하나의 출처를 origin이라고 한다. HTTP 요청에 origin 헤더를 추가하여 서버에 요청하고, 서버는 응답 헤더의 Access-Control-Allow-Origin에 응답 리소스에 접근할 수 있는 origin을 명시하여 보낸다. 브라우저가 요청 헤더의 origin과 응답 헤더의 origin이 같은 경우, 응답의 결과를 가져온다.
- DB Connection, DB Connection Pool
    - DB connection - 애플리케이션과 데이터베이스 서버가 통신할 수 있도록 하는 기능.
    - 자바에서는 주로 JDBC와 같은 드라이버를 통해 구현한다. 이거는 mysql, postgresql 등의 데이터베이스 별로 JDBC 드라이버가 존재한다.
    - Node.js에서는 mysql 확장 모듈을 사용하여 DB connection을 구현할 수 있다. 실습에서는 mysql2를 사용함.
    - Connection 객체를 사용하여 DB 관련 작업을 수행할 수 있고, 매 작업을 마칠 때마다 connection을 닫아야 한다.
    - DB 연결마다 connection 객체를 계속 새로 만드는 것은 네트워크 비용, 리소스 사용 비용 측면에서 비효율적이다.
    - 따라서 Connection Pool이 필요하다.
    - DB Connection Pool - 데이터베이스로의 추가 요청이 필요할 때 연결을 재사용할 수 있도록 관리되는 데이터베이스 연결의 캐시.
    - 애플리케이션 시작 시, 일정 수의 Connection 객체를 미리 생성하여 두고 Pool에 저장하고, DB 연결이 필요할 때 마다 Pool에서 꺼내다 쓰고 다시 반납하는 개념. 미리 Pool에 얼마나 많은 Connection을 담을지 결정해야 한다.
    - 연결을 미리 만들고, DB 연결마다 Connection을 만들고 해제하는 과정이 사라져 효율적인 서버 운용이 가능하다.
    - Pool 용량이 너무 크면 메모리 소모가 크고 서버의 성능이 저하될 수 있다. 그렇다고 너무 작으면 동시 접속자가 많은 경우 DB 접근에 딜레이가 생길 수 있다. 따라서 서버 규모와 서비스 규모에 따라 적절한 양의 Connection을 관리해야 한다.
- 비동기 (async, await)
    - Node.js에서는 비동기로 작동되는 함수와 메소드들이 존재한다.
    - setTimeout, setInterval, Ajax, Request, fetch, axios, query 등등
    - 이러한 비동기 프로세스를 처리하기 위한 방식은 대표적으로 3가지가 있다.
        1. 콜백함수
            
            비동기 작업이 끝나고 난뒤 실행되는 함수이다.
            
            하지만 콜백함수 특유의 가독성 떨어지는 문제로 인해 콜백 지옥이라는 악명을 가지고 있다.
            
            따라서 ES6부터 Promise 객체가 등장하였다.
            
        2. Promise (resolve, reject)와 then, catch
            
            Promise의 비동기처리는 반환값이 Promise객체로 반환되고, 비동기 처리 성공시에는 then으로 넘겨서 사용하고 실패시에는 catch로 넘겨서 예외처리를 할 수 있다.
            
        3. async & await
            
            함수 앞에 async를 달고, 함수 내부에서 await로 비동기 함수를 호출하여 바로 사용할 수 있다. 
            
- try/catch/finally
    - 예외처리를 위한 구문
    - 예외(exception)을 catch해서 throw를 하여 에러 처리를 한다.
    - try{} 내부에는 예외가 발생할 가능성이 있는 코드를 넣는다.
    - catch{} 내부에는 try{} 내부에서 예외가 발생한 경우 실행되는 코드를 넣는다.
    - finally{}에는 예외 유무에 상관없이 항상 실행되는 코드가 포함된다.
    - try 절은 단독으로 사용할 수 없고, catch나 finally와 함께 사용해야 한다.
        
        ```jsx
        var i = 0, total = 0;
        while (i < a.length) {
        	try {
        		if(typeof a[i] != 'number' || isNaN(a[i])) { // 만일 이것이 숫자가 아니라면
        			continue; // 이 루프의 다음 반복으로 넘어간다.
        		}
        		total += a[i]; // 숫자라면 total에 이 숫자를 더한다.
        	} finally {
        		i++; // 위에서 continue 를 사용했지만 무조건 i를 증가시키도록 한다.
        	}
        }
        
        //출처: https://webclub.tistory.com/71 [Web Club:티스토리]
        ```
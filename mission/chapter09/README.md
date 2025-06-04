1. 이번 주에는 Google 로그인 외에 다른 소셜 로그인을 하나 더 연동해주세요! 네이버 로그인, 카카오 로그인, Apple 로그인, GitHub 로그인 등 원하시는 로그인 방식을 연동해주시면 됩니다.

   카카오 로그인을 구현해보았다.

   1. 우선 카카오 디벨로퍼 사이트에서 앱을 등록한다. 나는 예전에 했던 프로젝트가 있어서 그 애플리케이션을 사용했다.
      ![1748438791545](image/README/1748438791545.png)
   2. 카카오 로그인을 설정하고, REST API KEY를 .env파일에 추가한다.
   3. 이미 npm 의존성 passport-kakao을 설
   4. 
   5. 치한다.
   6. 구글과 동일하게 kakaoStrategy를 선언하고 passport에 등록한다.

      ![1748438996004](image/README/1748438996004.png)
   7. 
   8. ![1748439147389](image/README/1748439147389.png)
   9. ![1748439178439](image/README/1748439178439.png)
   10. ![1748439226585](image/README/1748439226585.png)
2. 기존에 사용자의 정보를 하드 코딩 했던 부분들이 있다면 수정해주세요! **(ex. 항상 첫 번째 사용자를 가져와 이용했던 부분 등)**

   로그인 할 떄 profile 정보를 받아와 database에 해당 email로 가입 한 정보가 있는지 확인하고 있다면 값을 return 해주고, 없다면 오류를 생성하는 로직을 구현했다.

![1748420716264](image/README/1748420716264.png)

![1748419284006](image/README/1748419284006.png)

![1748419314969](image/README/1748419314969.png)

![1748419324483](image/README/1748419324483.png)

3. 기존 회원 가입 API의 경우, 이메일이 이미 존재하는 사용자는 회원 가입을 막아둔 상태입니다. 일단 Google 로그인 등으로 로그인 한 사용자의 경우 전화번호, 생일 등을 채울 마땅한 방법이 없는 상태입니다.
   user router 아래 update endpoint를 추가하는 로직을 추가했다.

* ![1748439573206](image/README/1748439573206.png)



* ## 이메일과 비밀번호를 이용한 회원가입, 로그인을 구현해주세요. `User` model에 `password` 관련 컬럼을 추가하고, [https://www.passportjs.org/concepts/authentication/password/](https://www.passportjs.org/concepts/authentication/password/) - 문서를 참고하여 구현해주시면 됩니다. (비밀번호는 반드시 암호화되어 DB에 저장되어야 합니다.)

  ```
    ![image.png](attachment:a7f5a57b-07d5-41e0-ae26-d73b32d780c7:image.png)

    ![image.png](attachment:5429e12a-bab4-42b5-833a-3512fe0c806f:image.png)

    ![image.png](attachment:0f524830-6399-416e-a1ac-4bac0263a67c:image.png)

    Crypto 모듈을 사용해 회원가입 할때 salt + hashing password를 구현했고, 로그인 할때 verfyPassword로 해시값 일치여부를 확인했다.
  ```
* ## 사용자가 최초로 회원가입 했을 때 사용한 회원가입 방식을 기록하고, 이 회원가입 방식 외의 다른 소셜 로그인 또는 이메일/비밀번호 로그인 및 비밀번호는 불가능하도록 방지해주세요. (Google 로그인으로 가입했다면 이후로도 Google로만 로그인이 가능하고, 이메일/패스워드로의 로그인은 불가능해야 합니다.)

  ```
    ![image.png](attachment:91aeafc1-5a87-4de1-b884-74f92892497b:image.png)

    Oauth로직에 회원가입을 추가하고, 로그인 방법을 기록했다.

    ![image.png](attachment:b6ccc5ff-e8a0-4151-a827-b5dd049ce312:image.png)
  ```
* ## 워크북에서는 단순 Cookie 기반의 Session을 사용했는데요, 현업에서는 JWT를 주로 사용하고 있습니다. JWT의 개념과 사용하는 이유, 장단점에 대해 찾고 정리해주세요.

  ```
    JWT는 **JSON 기반의 토큰**으로, **서버와 클라이언트 간에 인증 정보를 안전하게 주고받기 위해 사용되는 토큰이다. 토큰은 헤더, 페이로드,서명 세부분으로 나눠져있다.**

    JWT는 세션과 달리 클라이언드의 localstorage 혹은 authorization header에 저장되어 있고, stateless로 구현되어 있다. 즉, 서버가 상태를 기억하지 않아도 되기에 모바일/SPA 앱에서 간편하게 사용된다. 

    | **항목** | **Cookie-Session 기반** | **JWT 기반** |
    | --- | --- | --- |
    | 저장 위치 | 서버 메모리 / DB | 클라이언트 (보통 localStorage 또는 Authorization Header) |
    | 상태 | 상태 유지 (stateful) | 상태 없음 (stateless) |
    | 스케일링 | 세션 공유 필요 → 복잡함 | 서버 확장 쉬움 |
    | 주 목적 | 인증된 사용자 관리 | 인증된 사용자 식별 및 권한 분리 |

    하지만 다음과 같은 장단점이 있다.

    - **장점**
    1. Stateless: 서버에 세션 저장소가 필요 없어 인프라 단순화 가능
    2. 확장성 우수: 서버 간 세션 공유 없이 인증 가능 → 로드 밸런싱 쉬움
    3. 다중 플랫폼 지원: 클라이언트가 토큰을 소유하므로, 웹/모바일/서버 간 인증 공통 처리
    4. Self-contained: 토큰만으로 사용자 정보, 권한 확인 가능

    ---

    - **단점**
    1. 보안 관리 부담: 토큰이 노출되면 탈취자가 정보 접근 가능 → HTTPS 필수
    2. 토큰 폐기 어려움: 로그아웃 시 서버에서 JWT를 쉽게 무효화할 수 없음 (Blacklist 필요)
    3. Payload 정보 노출: 암호화되지 않으면 정보가 base64로 쉽게 디코딩됨 → 민감 정보 금지
    4. 토큰 크기 큼: 쿠키나 헤더에 실을 때 부담될 수 있음 (특히 모바일 환경)
  ```

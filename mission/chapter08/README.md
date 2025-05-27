[https://github.com/seoki180/UMC_Node_Practice](https://github.com/seoki180/UMC_Node_Practice)

시니어 미션


* OpenAPI 버전 별 특징 및 주요 차이점에 대해 찾아 정리해주세요. (2.0, 3.0, 3.1)

  ### **OpenAPI 2.0 (Swagger 2.0)**

  :Swagger 2.0으로 불렸으며, OpenAPI 이전 명세 버전이다.


  * **요청 본문(Request Body)** : 별도의 requestBody 개념이 없으며, 본문 데이터는 parameters 배열 안에 in: body 형태로 포함시킨다. 복잡한 구조 표현이 불편하다.
  * **콘텐츠 타입 지정** : consumes와 produces 필드를 통해 요청 및 응답의 콘텐츠 타입을 정의한다.
  * **JSON Schema 지원** : 자체 정의된 JSON-like 스펙을 사용하며, 공식 JSON Schema와 완전한 호환은 아니다.

  ---

  ### **🔹 OpenAPI 3.0**

  : Swagger에서 OpenAPI로 이름이 변경되며, 명세 구조가 대대적으로 개편됨.

  * **요청 본문(Request Body)** : requestBody라는 독립 키워드가 생기며, 요청 데이터의 구조와 타입을 명확하게 기술할 수 있게 되었다.
  * **콘텐츠 타입 지정** : content 필드를 통해 요청과 응답을 미디어 타입 별로 구분하여 문서화할 수 있다.
  * **JSON Schema 지원** : JSON Schema 기반 구조가 도입되어 유효성 검사 및 복잡한 객체 정의가 수월해졌다. 하지만 완전한 JSON Schema 사양은 아직 지원되지 않는다.

  ---

  ### **🔹 OpenAPI 3.1**

  : OpenAPI 3.1은 최신 명세 버전으로, JSON Schema 2020-12와의 완전한 호환을 달성했다.

  * **요청 본문(Request Body)** : 3.0과 동일하게 requestBody 구조를 사용한다.
  * **콘텐츠 타입 지정** : content 필드 사용은 동일하다.
  * **JSON Schema 지원** : JSON Schema 2020-12를 완전하게 지원하며, 외부 스키마 참조 및 복잡한 유효성 조건을 그대로 사용할 수 있다.
  * **Webhook** : webhooks 키워드가 추가되어, 서버에서 클라이언트로의 푸시 이벤트를 명세화할 수 있게 되었다.
  * **nullable 속성** : 제거되고 JSON Schema의 방식으로 통일됨.

  | **항목** | **OpenAPI 2.0 (Swagger 2.0)** | **OpenAPI 3.0**     | **OpenAPI 3.1**         |
  | -------------- | ----------------------------------- | ------------------------- | ----------------------------- |
  | 명칭           | Swagger 2.0                         | OpenAPI Specification 3.0 | OpenAPI Specification 3.1     |
  | Request Body   | 없음 (parameters로 처리)            | requestBody 명확히 분리   | 동일                          |
  | Content Type   | consumes, produces                  | content 필드              | 동일                          |
  | JSON Schema    | 제한적 호환                         | 부분 지원                 | **완전 지원 (2020-12)** |
  | 논리 조건      | 미지원                              | 일부 지원                 | **완전 지원**           |
  | Webhook 지원   | 없음                                | 없음                      | **지원**                |
  | nullable       | 별도 속성                           | nullable 사용             | JSON Schema 방식으로 통합     |
* 웹 및 모바일 개발자들은 Postman을 더 편하게 사용하는 경우도 있습니다. Postman에서도 Swagger 문서 기반의 API 테스트를 해볼 수 있도록, Swagger 문서를 임포트해보고 과정과 결과에 대해 정리해주세요.
  ![image.png](attachment:bf020bc9-9138-4374-8347-163573671afc:image.png)
  다음처럼 writeOutputFile, outputFile을 설정해두면 swagger에 들어갈때 현재 경로에 openapi.json 파일이 생성된다,
  ![image.png](attachment:512914a8-033a-4791-8140-f767f4bbc615:image.png)
  이제 이 json 파일을 postman 에서 import하면 된다.
  ![image.png](attachment:d10aeb83-00bf-4f98-84d0-c040168d4c7a:image.png)
  import됐다면 다음처럼 api를 기준으로 workspace가 생성된다.
  ![image.png](attachment:bb6366d4-610a-40e9-b334-1f83b79c0f63:image.png)
  ![image.png](attachment:1f8e6247-e8fe-453e-8f12-b8d64c0c67f5:image.png)

open request에 들어가면 내가 설정해놓은 예시대로 request를 보낼 수 있다.

다만 이렇게 구현했을 때 추가가 안된 api가 존재했고, request body에 내가 작성한 그대로 들어가기에 type이나 example도 같이 들어가는 오류가 존재해서 postman연동을 생각한다면 작성을 처음부터 다르게 해야 할 것 같다.

![image.png](attachment:4c8e41a7-9288-44b1-b3e0-8fa557e4a8b9:image.png)

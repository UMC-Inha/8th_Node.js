- Swagger
    - REST API를 문서화 해주는 도구.
    - 프론트와 백엔드 개발 과정에서 API 연동 및 테스트를 도와준다.
    - Basic Structure
        
        ```yaml
        openapi: 3.0.4
        info:
          title: Sample API
          description: Optional multiline or single-line description in [CommonMark](http://commonmark.org/help/) or HTML.
          version: 0.1.9
        
        servers:
          - url: http://api.example.com/v1
            description: Optional server description, e.g. Main (production) server
          - url: http://staging-api.example.com
            description: Optional server description, e.g. Internal staging server for testing
        
        paths:
          /users:
            get:
              summary: Returns a list of users.
              description: Optional extended description in CommonMark or HTML.
              responses:
                "200": # status code
                  description: A JSON array of user names
                  content:
                    application/json:
                      schema:
                        type: array
                        items:
                          type: string
        ```
        
        docs의 yaml 예시. JSON의 형식으로도 작성할 수 있다.
        
    - media types
        
        content 밑에 미디어 타입을 정의할 수 있다. 예시에는 application/json이 사용되었고 다음과 같은 미디어 타입들이 존재한다.
        
        application/json : json type
        application/xml : xml type
        application/x-www-form-urlencoded : 데이터를 url 인코딩 후 전송
        multipart/form-data : 바이너리 데이터를 전송
        text/plain; charset=utf-8
        text/html
        application/pdf
        image/png
        
    - Paths
        - /users/{id} : {}를 통해 path variable을 정의해줄 수 있다.
        - /users?role={role} : 틀린 표현이다. 쿼리는 parameters에 별도로 정의해주어야 한다.
            
            ```yaml
            paths:
              /users:
                get:
                  parameters:
                    - in: query
                      name: role
                      schema:
                        type: string
                        enum: [user, poweruser, admin]
                      required: true
            ```
            
        - endpoint와 responses 사이에 get, patch, post 등등의 메소드를 정의해줄 수 있다.
    - Request Body
        - anyOf, oneOf
            - 여러 body schema 중 하나 선택 가능
            
            ```yaml
            requestBody:
              description: A JSON object containing pet information
              content:
                application/json:
                  schema:
                    oneOf:
                      - $ref: "#/components/schemas/Cat"
                      - $ref: "#/components/schemas/Dog"
                      - $ref: "#/components/schemas/Hamster"
            ```
            
        - multipart request
            - 파일 업로드 이미지 업로드 등의 post 요청에서 사용하는 형식
            
            ```yaml
            requestBody:
              content:
                multipart/form-data: # Media type
                  schema: # Request payload
                    type: object
                    properties: # Request parts
                      id: # Part 1 (string value)
                        type: string
                        format: uuid
                      address: # Part2 (object)
                        type: object
                        properties:
                          street:
                            type: string
                          city:
                            type: string
                      profileImage: # Part 3 (an image)
                        type: string
                        format: binary
            ```
            
            여러 종류의 데이터 타입을 업로드 가능. binary, uuid 등의 특수한 형식의 데이터도 전송할 수 있다.
            
    - Response Body
        - anyOf, oneOf : request body와 같은 기능. 생략
        - pdf, 이미지와 같은 파일을 return 받는 경우
            
            ```yaml
            paths:
              /report:
                get:
                  summary: Returns the report in the PDF format
                  responses:
                    "200":
                      description: A PDF file
                      content:
                        application/pdf:
                          schema:
                            type: string
                            format: binary
            ```
            
            application/pdf나 multipart/form-data 등을 사용하고 format에서 binary 형식으로 지정한다.
            
            또는 이미지를 JSON 형식으로 임베딩하여 받아올 수도 있다. (base64로 엔코딩된 문자열 형식)
            
            ```yaml
            paths:
              /users/me:
                get:
                  summary: Returns user information
                  responses:
                    "200":
                      description: A JSON object containing user name and avatar
                      content:
                        application/json:
                          schema:
                            type: object
                            properties:
                              username:
                                type: string
                              avatar: # <-- image embedded into JSON
                                type: string
                                format: byte
                                description: Base64-encoded contents of the avatar image
            ```
            
        - default
            - default response로 에러들을 하나로 처리할 수 있다. 개별적으로 처리된 에러가 아닌 경우에는 모든 에러가 default에 선언된 대로 처리된다.
                
                ```yaml
                responses:
                  "200":
                    description: Success
                    content:
                      application/json:
                        schema:
                          $ref: "#/components/schemas/User"
                
                  # Definition of all error statuses
                  default:
                    description: Unexpected error
                    content:
                      application/json:
                        schema:
                          $ref: "#/components/schemas/Error"
                ```
                
- OpenAPI
    - OpenAPI Specification - REST API를 위한 API 설명 양식.
    - 엔드포인트, 요청 메소드, 파라미터, 인증 방식 등등의 정보를 모두 설명할 수 있다.
    - 전에는 swagger specification으로 불렸다. 현재는 3.0 버전이 출시되었고, 2.0 버전도 공식 문서에서 확인할 수 있다.
- OpenAPI Component
    - 중복되는 schema처럼 코드를 재활용할 수 있는 곳들이 있다.
    - 이 때 component 기능을 활용해서 간편하게 schema를 정의해줄 수 있다.
        
        ```yaml
        paths:
          /users/{userId}:
            get:
              summary: Get a user by ID
              parameters: ...
              responses:
                "200":
                  description: A single user.
                  content:
                    application/json:
                      schema:
                        $ref: "#/components/schemas/User"
          /users:
            get:
              summary: Get all users
              responses:
                "200":
                  description: A list of users.
                  content:
                    application/json:
                      schema:
                        type: array
                        items:
                          $ref: "#/components/schemas/User"
        
        components:
          schemas:
            User:
              type: object
              properties:
                id:
                  type: integer
                name:
                  type: string
        ```
        
        프로젝트 파일에 별도로 component들을 정의해놓고 import 받아서 사용할 수 있다.
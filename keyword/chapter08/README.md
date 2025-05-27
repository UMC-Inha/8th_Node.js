- Swagger
    
    REST API를 설계, 구축, 문서화하고 사용할 수 있도록 하는 도구
    
    원래는 API 명세와 그 명세를 다루는 도구 모두를 Swagger라고 불렀는데, 현재는 명세 자체는 "OpenAPI Specification(OAS)"로 이름이 바뀌었다.
    
    ### OAS(OpenAPI Specification)
    
    - **OAS**는 RESTful API의 구조, 동작, 입력/출력, 인증 방식 등을 표준화된 형식(YAML 또는 JSON)으로 기술하는 명세서
    - OAS는 API가 어떻게 동작하는지, 어떤 엔드포인트가 있고, 어떤 요청과 응답이 오가는지를 선언적으로 정의하는 문서
    
    그리고 Swagger는 OpenAPI 명세를 다루는 툴로 남아있다.
    
    ### Swagger
    
    - OAS를 작성, 시각화, 테스트하고, 자동으로 문서화할 수 있게 해주는 오픈소스 도구 모음
    - OAS 명세를 기반으로 실제 API 문서를 자동 생성하고, UI를 통해 API를 테스트할 수 있으며, 코드 생성 등 다양한 기능을 제공한다.
    - 대표적인 Swagger 도구
        - **Swagger Editor**: OpenAPI 명세를 작성할 수 있는 웹 기반 에디터
        - **Swagger UI**: API 명세서를 시각적으로 보여주고, API 호출 및 테스트를 할 수 있는 웹 인터페이스
        - **Swagger Codegen**: OpenAPI 명세로부터 다양한 언어의 서버 코드와 클라이언트 SDK를 자동으로 생성해주는 코드 생성기
    - Swagger 도구의 장점:
        - API 문서를 자동으로 생성
        - 다양한 언어의 클라이언트/서버 코드 자동 생성
        - API 테스트 및 통합이 쉬움
- OpenAPI
    
    OpenAPI Specification(OAS)은 RESTful API의 구조와 동작 방식을 표준화된 형식으로 문서화하는 명세
    
    API가 어떤 동작을 하는지, 어떻게 사용해야 하는지, 어떤 요청과 응답이 오가는지 명확하게 이해할 수 있다.
    
    주로 YAML이나 JSON 형식으로 작성됨
    
    ### OpenAPI 명세서의 주요 요소
    
    - **openapi**: 명세서가 따르는 OpenAPI의 버전 정보(예: 3.0.3)
    - **info**: API의 제목, 설명, 버전, 라이선스 등 메타데이터
    - **servers**: API가 배포된 서버의 URL 및 설명. 여러 서버 환경(개발, 운영 등)을 명시할 수 있음
    - **paths**: 실제 API 엔드포인트(경로)와 각 경로에서 지원하는 HTTP 메서드(GET, POST 등), 요청/응답 구조, 파라미터, 설명 등
    - **components**: 여러 곳에서 재사용할 수 있는 스키마(데이터 구조), 응답, 파라미터, 보안 정의 등
    - **security**: 인증 및 권한 부여 방식(예: API 키, OAuth2 등)
    - **tags**: API를 주제별로 그룹화하는 태그
    - **externalDocs**: 외부 문서 링크(추가 설명이나 참고 자료)
    
    ### OpenAPI 예시(JSON)
    
    ```json
    {
    	"openapi": "3.1.0",
    	"info": {
    	"title": "Weather API",
    	"version": "1.0.0",
    	"description": "This API provides weather information."
    	},
    	"servers": [
    		{
    			"url": "https://api.example.com/v1"
    		}
    	],
    	"paths": {
    		"/weather": {
    			"get": {
    				"summary": "Get weather information",
    				"parameters": [
    					{
    						"name": "city",
    						"in": "query",
    						"required": true,
    						"schema": {
    						"type": "string"
    						}
    					}
    				],
    				"responses": {
    					"200": {
    						"description": "Successful response",
    						"content": {
    							"application/json": {
    								"example": {
    									"city": "New York",
    									"temperature": 72
    								}
    							}
    						}
    					},
    					"404": {
    						"description": "City not found",
    						"content": {
    							"application/json": {
    								"example": {
    									"error": "City not found"
    								}
    							}
    						}
    					}
    				}
    			},
    			"post": {
    				"summary": "Submit weather information",
    				"requestBody": {
    					"content": {
    						"application/json": {
    							"schema": {
    								"type": "object",
    								"properties": {
    									"city": { "type": "string" },
    									"temperature": { "type": "number" }
    								}
    							}
    						}
    					}
    				},
    				"responses": {
    					"201": {
    					"description": "Data submitted successfully"
    					}
    				}
    			}
    		}
    	}
    }
    ```
    
- OpenAPI Component
    
    API 명세서 내에서 여러 곳에서 반복적으로 사용되는 정의(데이터 모델, 파라미터, 응답 등)를 한 곳에 모아두고, 필요할 때마다 참조(Reference)해서 사용할 수 있도록 하는 재사용 정의 컨테이너
    
    ### 주요 역할
    
    - **중복 제거**: 여러 엔드포인트에서 동일한 데이터 구조나 파라미터, 응답 등을 사용할 때, `components`에 한 번만 정의하고 필요할 때마다 `$ref`로 참조한다.
    - **유지보수 용이**: 재사용 요소를 한 곳에서 관리하므로, 변경이 필요할 때 한 번만 수정하면 전체에 적용된다.
    - **구조화**: 명세서가 길어질수록 복잡해지는데, `components`를 활용하면 명확하게 구조화할 수 있다.
    
    ### OpenAPI Component 세부 요소
    
    - **schemas**: 데이터 모델(객체, 배열 등) 정의. 요청/응답의 구조를 재사용할 때 사용
    - **parameters**: 경로, 쿼리, 헤더 등에서 반복적으로 쓰이는 파라미터 정의
    - **responses**: 여러 엔드포인트에서 공통으로 쓰이는 응답 객체(HTTP 상태 코드, 응답 본문 등) 정의
    - **requestBodies**: POST, PUT 등에서 공통으로 쓰이는 요청 본문 정의
    - **headers**: 공통 응답 헤더 정의
    - **examples**: 요청/응답 등에 사용할 수 있는 예시 데이터 정의
    - **links**: 응답과 다른 API 호출의 연결 관계 정의
    - **callbacks**: 콜백 URL 및 동작 정의
    - **securitySchemes**: 인증/인가 방식 정의(JWT, OAuth2 등)
    - **pathItems**: 재사용 가능한 경로(엔드포인트) 정의
    
    ### OpenAPI Component 예시(YAML)
    
    ```yaml
    components:
      schemas:
        User:
          type: object
          properties:
            id:
              type: integer
            name:
              type: string
            email:
              type: string
              format: email
      parameters:
        userId:
          name: id
          in: path
          required: true
          schema:
            type: integer
      responses:
        NotFound:
          description: User not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
      securitySchemes:
        bearerAuth:
          type: http
          scheme: bearer
          bearerFormat: JWT
    ```
    
    위 예시에서는 `User` 스키마, `userId` 파라미터, `NotFound` 응답, `bearerAuth` 인증방식 등이 `components`에 정의되어 있다.
    
    ```yaml
    paths:
      /users/{userId}:
        get:
          summary: Get a user by ID
          parameters:
            - name: userId
              in: path
              required: true
              schema:
                type: integer
          responses:
            '200':
              description: A single user.
              content:
                application/json:
                  schema:
                    $ref: '#/components/schemas/User'   # User 스키마 재사용
            '404':
              $ref: '#/components/responses/NotFound'   # NotFound 응답 재사용
    
      /users:
        get:
          summary: Get all users
          responses:
            '200':
              description: A list of users.
              content:
                application/json:
                  schema:
                    type: array
                    items:
                      $ref: '#/components/schemas/User' # User 스키마 재사용
    ```
    
    `#/components/schemas/User` : User 데이터 모델을 참조
    
    `#/components/responses/NotFound` : NotFound 응답을 참조
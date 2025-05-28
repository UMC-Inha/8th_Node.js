- 미션 기록
    
    ```jsx
    export const handleUserSignUp = async (req, res, next) => {
        /*
        #swagger.summary = '회원가입 요청 api';
        #swagger.requestBody = {
            required: true,
            content: {
                "application/json": {
                    schema: {
                        type: "object",
                        properties: {
                            email: { type: "string" },
                            name: { type: "string" },
                            gender: { type: "number" },
                            birth: { type: "string", format: "date" },
                            address: { type: "string" },
                            phoneNumber: { type: "string" },
                            preferences: { type: "array", items: { type: "number"} }
                        }
                    }
                }
            }
        };
        #swagger.responses[200] = {
            description: "회원가입 요청 성공 응답",
            content: {
                "application/json": {
                    schema: {
                        type: "object",
                        properties: {
                            resultType: { type: "string" },
                            error: { type: "object", nullable: true, example: null },
                            result : {
                                type: "object",
                                properties: {
                                    name: { type: "string" },
                                    email: { type: "string" },
                                    gender: { type: "number" },
                                    birth: { type: "string", format: "date" },
                                    address: { type: "string" },
                                    preferences: {
                                        type: "array",
                                        items: { type: "string" }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        };
        #swagger.responses[400] = {
            description: "회원가입 요청 실패 응답",
            content: {
                "application/json": {
                    schema: {
                        type: "object",
                        properties: {
                            resultType: { type: "string", example: "error" },
                            error: {
                                type: "object",
                                properties: {
                                    errorCode: { type: "string" },
                                    reason: { type: "string", example: "이미 존재하는 ~" },
                                    data: { type: "string", example: "중복된 데이터 ~" },
                                }
                            },
                            result: {
                                type: "object", nullable: true, example: null
                            }
                        }
                    }
                }
            }
        };
        #swagger.responses[500] = {
            description: "서버 에러",
            content: {
                "application/json": {
                    schema: {
                        type: "object",
                    properties: {
                        resultType: { type: "string" },
                        error: { 
                            type: "object",
                            properties: {
                                errorCode: { type: "string" },
                                reason: { type: "string" },
                                data: { type: "string" }
                            },
                        },
                        result: {
                            type: "object", nullable: true, example: null
                        }
                    }
                    }
                }
            }
        };
        */
        console.log('회원가입 요청.');
        console.log("body: ", req.body);
        
        try{
            const user = await userSignUp(bodyToUser(req.body));
            res.status(StatusCodes.OK).success(user);
        }catch(err){
            next(err);
        }
    };
    ```
    
    ![image.png](attachment:29df4ac3-1502-41da-8f8e-3beb43d2ff51:image.png)
    
    - OpenAPI 2.0 vs 3.0
        - JSON schema 키워드 추가
            - oneOf, anyOf, allOf - 여러 OpenAPI 형식의 schema를 지정해주고 사용해야 할 때 사용할 수 있는 키워드.
        - example 기능 변경
            - 이전 버전에서는 yaml, json 객체 형식으로만 example 지정이 가능했다.
            - 3.0 부터는 JSON string 형식으로 사용할 수 있고, 객체, properties, parameter, request body, response description 등에 재사용할 수 있다.
            - external example을 참조할 수 있다.
        - Security flow에 대한 변경
            - 모든 http 보안 schema에 대한 지원 추가.
            - basic type이 http로 이름이 변경됨.
            - OpenID Connect Discovery에 대한 지원 추가.
        - Parameter Description 변경
            - body, formData가 requestBody로 변경됨.
            - requestBody에 배열과 객체를 추가할 수 있고, 시리얼화도 가능하다.
            - operation parameter로 path, query, header, cookie가 사용 가능하다.
            - cookie authentication이 추가되었다. 2.0에서는 지원되지 않는 기능이었지만 3.0에서부터는 API를 cookie를 통해 요청할 수 있다. 따라서 API와 OAuth token을 인증할 수 있다.
    - Swagger Postman 연동
        1. swagger json 파일 접근
            
            ![sw1.PNG](attachment:f7431743-e211-4b99-aaef-0f46e133ca6c:sw1.png)
            
            /open.json을 클릭하여 접근한다.
            
        2. json text 복사
            
            ![sw2.PNG](attachment:827d0c85-68f1-4fc6-a88c-67d628187279:sw2.png)
            
            json raw text를 복사한다.
            
        3. postman import
            
            ![sw3.PNG](attachment:4947014f-4e58-43a9-8fa4-f62dbb9b3da3:sw3.png)
            
            raw text를 붙여넣기 한다.
            
        4. 결과
            
            ![sw4.PNG](attachment:c7150663-550c-4950-9a93-ef6e9ec00862:sw4.png)
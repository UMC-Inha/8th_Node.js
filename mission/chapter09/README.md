- 미션 기록
    - 네이버 로그인 구현
        
        passport-naver-v2 npm 패키지 이용
        
        https://github.com/parkoon/passport-naver-v2?tab=readme-ov-file
        
        - 네이버 API 설정
            
            ![1.PNG](attachment:038466a9-5208-47f5-9f04-004e6d19e2ae:1.png)
            
            프로파일에서 이메일, 유저 닉네임, 성별, 생일, 전화번호 등의 데이터까지 모두 받아올 수 있다.
            
        
        ```jsx
        export const naverStrategy = new NaverStrategy(
            {
                clientID: process.env.PASSPORT_NAVER_CLIENT_ID,
                clientSecret: process.env.PASSPORT_NAVER_CLIENT_SECRET,
                callbackURL: "http://localhost:3000/oauth2/callback/naver",
                state: true,
            },
            (accessToken, refreshToken, profile, cb) => {
                return naverVerify(profile)
                .then((user) => cb(null, user))
                .catch((err) => cb(err));
            }
        );
        
        const naverVerify = async (profile) => {
            const email = profile.email;
            const user = await prisma.user.findFirst({where: {email}});
        
            if(user !== null) {
                return {id: user.id, email: user.email, username: user.username};
            }
        
            const created = await prisma.user.create({
                data: {
                    email,
                    username: profile.nickname,
                    gender: -1,
                    address: "추후 수정",
                    phoneNumber: profile.mobile,
                    birth: new Date(1971, 0, 1),
                }
            });
        
            return {id: created.id, email: created.email, username: created.username};
        };
        ```
        
        - 결과
            
            ![2.png](attachment:197cb6ef-a5e2-41ec-b4b9-7ce38831b5f3:2.png)
            
            ![3.PNG](attachment:05355afc-d802-48f1-ac87-1e6757d8a28b:3.png)
            
            유저가 성공적으로 가입되었다.
            
    - 비밀번호 암호화
        - 가장 간단한 방법은 crypto 패키지를 활용하는 것이다.
        
        ```jsx
        import crypto from "crypto";
        
        const createHashedPassword = (password) => {
          return crypto.createHash("sha512").update(password).digest("base64");
        };
        ```
        
        하지만 이 방법은 해시 테이블이 있는 경우 쉽게 털릴 수 있다.
        
        따라서 비밀번호에 랜덤한 문자열을 붙여서 해쉬시켜서 아예 알아볼 수 없게 만들것이다.
        
        소금을 뿌리듯이 입력 값에 특정 값을 붙이므로 salt 방식으라고 한다.
        
        - 보완한 방법
            
            ```jsx
            const createSalt = async () => {
              const buf = await randomBytesPromise(64);
            
              return buf.toString("base64");
            };
            
            export const createHashedPassword = async (password) => {
              const salt = await createSalt();
              const key = await pbkdf2Promise(password, salt, 104906, 64, "sha512");
              const hashedPassword = key.toString("base64");
            
              return { hashedPassword, salt };
            };
            ```
            
            randomBytesPromise라는 함수를 이용해서 랜덤한 salt 값을 생성한다.
            
            그리고 crypto 패키지의 pdkdf라는 메서드를 사용해서 암호화한다.
            
            인자값으로 해싱할 값, salt, 해시 반복 횟수, 해시 값 길이, 해시 알고리즘을 입력한다.
            
            해시 반복 수는 딱 떨어지는 수보다는 위와 같이 예상하기 힘든 수를 넣는것이 더 효과적이다.
            
            - 코드
                
                ```jsx
                import { prisma } from "../db.config.js";
                import crypto from "crypto";
                import { promisify } from "util";
                
                // crypto 함수들을 프로미스화
                const randomBytesPromise = promisify(crypto.randomBytes);
                const pbkdf2Promise = promisify(crypto.pbkdf2);
                
                const createHashedPassword = async (password) => {
                    const saltBuffer = await randomBytesPromise(64);
                    const salt = saltBuffer.toString('hex');
                
                    const key = await pbkdf2Promise(password, saltBuffer, 104906, 64, 'sha512');
                    const hashedPassword = key.toString('base64');
                    return { hashedPassword, salt };
                };
                
                export const addUserByPassword = async (data) => {
                    try{
                        const existingUser = await prisma.user.findUnique({
                            where: { email: data.email },
                        });
                
                        if (existingUser) {
                            return null;
                        }
                
                        // createHashedPassword 호출 시 await 사용 및 결과 구조 분해 할당
                        const p = await createHashedPassword(data.password);
                        const hashedPassword = p.hashedPassword;
                        const salt = p.salt;
                
                        console.log(p);
                
                        const newUser = await prisma.user.create({
                            data: {
                                email: data.email,
                                address: data.address,
                                username: data.name,
                                gender: data.gender,
                                birth: data.birth,
                                phoneNumber: data.phoneNumber,
                                password: hashedPassword, // Prisma 스키마에 hashedPassword 필드 필요
                                salt: salt,                     // Prisma 스키마에 salt 필드 필요
                            },
                        });
                
                        return newUser.id;
                    } catch (err) {
                        console.error("addUserByPassword error: ", err);
                        throw new Error(`사용자 생성 중 오류 발생: ${err.message}`);
                    }
                }
                ```
                
            - 결과
                
                ![4.PNG](4.png)

    - 회원가입 방식 구분
    - 회원 테이블에 type 컬럼을 추가하여 구분한다.
    - 회원가입 시 type을 지정하여 회원가입 되도록 설정한다.
    - 0: 비밀번호 방식 1: 구글 로그인 2: 네이버 로그인
    
    ```jsx
    const naverVerify = async (profile) => {
        const email = profile.email;
        const user = await prisma.user.findFirst({where: {email}});
    
        if(user !== null) {
            return {id: user.id, email: user.email, username: user.username};
        }
    
        const created = await prisma.user.create({
            data: {
                email,
                username: profile.nickname,
                gender: -1,
                address: "추후 수정",
                phoneNumber: profile.mobile,
                birth: new Date(1971, 0, 1),
                type: 2, //타입 지정
            }
        });
    
        return {id: created.id, email: created.email, username: created.username};
    };
    ```
    
    이후 로그인 검증 과정에서 해당 타입을 확인하여 회원가입 방식을 유지한다.
                
    - JWT
        - JWT란 인증에 필요한 정보들을 암호화시킨 JSON 토큰이다.
        - HTTP 헤더에 JWT 토큰을 실어서 서버가 클라이언트를 식별하는 방식.
        - Base64 URL-safe Encode로 인코딩되어 있으며 개인키를 통한 전자서명도 들어있다.
        - 구조
            - Header - JWT에서 사용할 타입과 해시 알고리즘의 종류가 담겨있다.
            - Payload - 서버에서 첨부한 사용자 권한 정보와 데이터가 담겨있다.
            - Signature - 헤더에 명시된 해시함수를 헤더, 페이로드에 적용한 이후 개인키로 서명한 전자서명이 담겨있다.
        - 장점
            - 인증을 위한 별도의 저장소가 필요없음
            - 전자서명 방식을 통한 데이터 위변조 방지
            - 세션과는 달리 서버는 무상태가 되어 서버 확장성이 우수해진다.
            - 다른 로그인 시스템에 접근 및 권한 공유가 가능하다.
            - 모바일 환경에서도 동작한다.
        - 단점
            - 토큰 자체에 정보가 있으므로 약간의 위험성이 존재한다.
            - 토큰에 3종류의 정보가 있으므로 정보가 많아질수록 네트워크 부하가 심해진다.
            - Payload 자체가 암호화된 것이 아니라 인코딩되어 있는 것이므로 탈취당하면 데이터를 조회할 수 있다. 따라서 민감한 정보를 담지 않아야 한다.
            - 토큰이 탈취당하면 대처하기 어렵다.
        - 실제로는 액세스 토큰, 재발급 토큰으로 분리하여 사용한다.
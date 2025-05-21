- 미션 기록
    1. 응답 통일화
        1. index.js
            
            ```jsx
            app.use((req, res, next)=> {
              res.success = (result) => {
                return res.json({
                  resultType: "success",
                  error: null,
                  result: result
                })
              }
            
              res.error = ({
                errorCode = "unknown",
                statusCode,
                reason = null,
                data = null
              }) => {
                return res.json({
                  resultType: "error",
                  error: {
                    errorCode, reason, data
                  },
                  result: null
                })
              }
            
              next();
            });
            ```
            
            app.use 내에서 success, error라는 res 함수를 선언하고 있다. 각각 성공, 실패했을 때 처리를 하고 결과를 json형식으로 반환하고 있다.
            
        2. error.js
            
            ```jsx
            import { StatusCodes } from "http-status-codes";
            export class DuplicateDataError extends Error{
                errorCode = 'E001';
                statusCode = StatusCode.BAD_REQUEST;
                constructor(reason, data){
                    super(reason);
                    this.reason = reason || '이미 존재하는 데이터입니다.';
                    this.data = data;
                }
            }
            
            export class NoDataFoundError extends Error{
                errorCode = 'E002';
                statusCode = StatusCodes.NOT_FOUND
                constructor(reason, data){
                    super(reason);
                    this.reason = reason || '데이터를 찾을 수 없습니다.';
                    this.data = data;
                }
            }
            ```
            
            에러 객체 하나하나를 구현한 것. 생성자에서 이유와 data를 받아서 이유와 어떤 값이 잘못되었는지 출력할 수 있게 하였다.
            
    2. 압축
        1. gzip
            - Jean-Loup, Mark Adler에 의해 만들어진 압축 알고리즘
            - Deflate 알고리즘을 기반으로 하고 있다.
            - 중복되는 string과 data sequence를 찾아서 없애고 다른 symbol로 대체한다. 최대 70%까지 압축된다.
        2. brotli
            - gzip보다 20~26% 이상 압축률이 높음
            - 모든 브라우저에서 지원되는 것이 않으므로 사용 환경을 고려해야 한다.
        - compress 모듈로 압축 구현
            
            ```jsx
            npm i compress --save
            ```
            
            compress 패키지로 구현할 수 있다.
            
            ```jsx
            const compression = require('compression')
            
            app.use(compression());
            ```
            
            이렇게 간단하게 구현하는 방법이 있다.
            
            level, threshold, filter로 압축 조건을 정할 수 있다.
            
            level - 압축 정도를 설정하는 것. -1 ~ 9까지 설정할 수 있고, -1은 압축하지 않은 것이고, 1이 기본 값이다. nodejs 에서는 보편적으로 6으로 설정한다.
            
            threshold - 압축하지 않는 최소한의 크기를 설정하는 것이다. 100 * 1024으로 설정하면 100kb 아래의 데이터는 압축하지 않는 설정이다.
            
            filter - 조건에 따라 압축을 할지 말지 결정할 수 있다.
            
            ```jsx
            app.use(
              compression({
                level: 6,
                threshold: 100 * 1000,
                filter: (req, res) => {
                  if (req.headers["x-no-compression"]) {
                    // header에 x-no-compression이 있으면, 압축하지 않도록 false를 반환한다.
                    return false;
                  }
                  return compression.filter(req, res);
                  // 없는 경우에는 압축허용
                },
              })
            );
            ```
            
            ```jsx
            app.use(
              compression({
                level: 6,
                threshold: 512
              })
            );
            ```
            
            index.js에 구현한 내용.
            
            ![compress.PNG](compress.png)
            
            결과창. response header에 content-encoding에서 압축 방식을 볼 수 있다.
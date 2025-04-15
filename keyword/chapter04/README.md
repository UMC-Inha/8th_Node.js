- ES
    - ECMA Script - Javascript의 표준 규격
    - ECMA Script자체는 ECMA 인터네셔널에 의해 제정된 ECMA-262 기술 규격에 의해 정의된 범용 스크립트 언어이다.
    - Javascript가 ESMA Script 규격을 준수하는 스크립트 언어의 대표.
    - 일종의 표준 스크립트 언어라고 생각하면 된다.
- ES6
    - ES6의 주요 변화 및 특징
        1. let, const 키워드 추가
            
            기존의 var키워드의 호이스팅 문제를 해결하기 위해 let, const 키워드가 추가되었다.
            
            > 호이스팅: 변수를 어디서 선언을 하더라도 항상 컨텍스트 내의 최상의로 끌고 올라온 뒤에 ‘undefined’로 할당한다.
            > 
            
            var은 함수 단위 스코프만을 인정하고, let과 const는 블럭 단위 스코프로 작동한다.
            
        2. Arrow function의 추가
            
            ES6의 함수 선언법
            
            ```jsx
            let func = (arg1, arg2) => {console.log("ES6")}
            ```
            
        3. Template Literal
            
            백틱 (${})으로 문자열을 감싸 변수와 같은 데이터를 표현 가능
            
            ```jsx
            let name = "이름"
            let age = 20
            console.log(`저의 이름은 ${name}이고, 나이는 ${age}살 입니다.`)
            ```
            
        4. Default Parameter
            
            패러미터에 default 값을 설정할 수 있게 되었다.
            
            ```jsx
            let person = function(name="이름") {
              return name
            }
            ```
            
        5. class 키워드 추가
            
            class 키워드 추가로 Javascript에서도 객체처럼 사용가능해졌다.
            
            ```jsx
            class Add {
              constructor(arg1, arg2) {
                this.arg1 = arg1
                this.arg2 = arg2
              }
              calc() {
                return this.arg1 + "+" + this.arg2 + "=" + (this.arg1 + this.arg2)
              }
            }
            let num = new Add(3, 5)
            console.log(num.calc())
            ```
            
        6. module
            
            export, import를 통해 외부의 변수와 클래스를 사용할 수 있게 되었다.
            
            ```jsx
            // lib.js
            export default (x) => x * x;
            
            // app.js
            import myModule from "./lib.js";
            
            console.log(myModule(10)); // 100
            ```
            
        7. Promise, Async, Await
            
            Promise 객체를 통한 비동기 처리가 가능하다.
            
            Promise 객체는 비동기 처리의 결과, 실패, 완료값을 나타낸다. (pending, fulfilled, rejected)
            
            .catch(), .then(), .finally()등의 callback function으로 작업을 처리할 수 있다.
            
            ```jsx
            $.get("https://samslow.github.io/logo.png")
              .then((result) => {
                document.getElementById("Avatar").src = result.data;
              })
              .catch((result) => {
                console.error("Avatar load Fail");
              });
            ```
            
            ES6에선 callback 함수 대신 async, await로 처리 가능하다.
            
            ```jsx
            const url = 'https://samslow.github.io/logo.png';
            const response = await $.get(url);
            const applyLogo = document.getElementById('Avatar').src = response;
            ```
            
    - ES6를 중요시 하는 이유
        - 현대 웹개발에서 Javascript의 활용성이 엄청나게 넓어졌다.
        1. let과 const를 활용한 변수의 스코프 관리 가능
        2. arrow function의 코드 간결화, this 바인딩의 오류 방지
        3. Template Literal로 문자열 내에서 변수를 쉽게 삽입하고, 여러 줄의 문자열도 간편하게 작성 가능하다.
        4. class로 객체 지향 프로그래밍을 Javascript에서 더 간단하게 구현할 수 있다.
        5. Promise의 비동기 작업 처리와 async, await의 callback 지옥 탈출
        6. module의 추가로 코드를 모듈 단위로 분리하여 관리할 수 있게 되었다.
- 프로젝트 아키텍처
    
    소프트웨어 개발 프로젝트의 기본적인 구조이다.
    
    시스템의 구성 요소와 그 관계를 정의하고, 어떻게 상호작용 하는지를 설명하는 설계도라고 할 수 있다.
    
    - 프로젝트 아키텍처가 중요한 이유
        1. 명확한 구조 - 시스템의 전체 구조를 명확하게 정의하여 팀원들이 시스템의 구성 요소와 상호 작용을 이해할 수 있다.
        2. 일관성 유지 - 모든 팀원이 동일한 표준, 규칙을 따르기 때문에 개발 과정에서의 혼란을 줄일 수 있다.
        3. 재사용성 향상 - 코드와 구성 요소의 재사용성을 높여 개발시간과 유지보수 비용을 줄일 수 있다.
        4. 위험 관리 - 잠재적인 위혐 요소에 대비할 계획을 수립할 수 있다.
        5. 성능, 확장성 향상 - 시스템의 성능과 확장성을 보장하고, 프로젝트가 성장하고 더 많은 서비스를 처리할 수 있게 한다.
        6. 보안 강화 - 데이터 보호와 접근 제어를 통해 보안 유지에 도움을 준다.
    - Service-Oriented Architecture(Service Layer Pattern)
        
        서비스 지향 아키텍쳐는 서비스라는 소프트웨어 구성 요소를 사용해 비즈니스 애플리케이션을 생성하는 개발 방식.
        
        각 서비스는 비즈니스 기능을 제공하며, 플랫폼과 언어를 넘나들며 서로 통신할 수 있다.
        
        - SOA의 장점
            - 출시 기간 단축 - 다양한 비즈니스 프로세스에서 서비스를 재사용할 수 있다.
            - 효율적인 유지보수 - 작은 서비스를 생성, 업데이트, 디버깅하기 쉽다. 하나의 서비스를 수정해도 전체 기능에는 영향이 없다.
            - 뛰어난 적응성 - 효과적이고 경제적으로 애플리케이션을 현대화할 수 있다.
        - SOA의 원칙
            - 상호 운용성 - 기본 플랫폼, 프로그래밍 언어에 관계없이 모든 클라이언트의 시스템에서 서비스를 실행할 수 있다.
            - 느슨한 결합 - 서비스는 느슨하게 결합되어 외부 리소스에 대한 종속성이 낮아야 한다. 또한 과거 세션, 트랜잭션의 정보를 유지하지 않는 상태 비저장 서비스여야 한다.
            - 추상화 - .
    - MVC 패턴
        
        ![image.png](1.png)
        
        Model, View, Controller의 약자
        
        하나의 프로젝트를 구성할 때 구성요소를 세가지의 역할로 분리한 패턴.
        
        - Model
            - 애플리케이션의 정보, 데이터를 나타낸다.
            - 사용자가 편집하길 원하는 데이터를 가지고 있어야 한다.
            - View와 Controller에 대해서 어떤 정보도 가지고 있지 않아야 한다.
            - 정보에 변경이 일어나는 처리방법을 구현해야한다. 요청과 결과를 처리하는 과정이 필요하다.
        - View
            - 웹사이트의 텍스트박스, 체크박스 항목과 같은 사용자와 상효작용하는 인터페이스 요소를 의미한다.
            - 모델이 가지고 있는 정보를 저장해서는 안된다.
            - 모델과 컨트롤러에 대한 정보가 없어야 한다.
            - 변경이 일어나는 처리방법을 구현해야한다. 화면에서 사용자가 내용을 변경하게 되면 변경사항을 모델에게 전달해서 변하기 위한 요청을 보내야 한다.
        - Controller
            - 데이터와 사용자 인터페이스를 이어주는 역학을 한다.
            - 다양한 이벤트들을 처리할 수 있는 요소이다.
            - 모델이나 뷰의 처리 방식을 알고 있어야 한다.
            - 모델과 뷰의 변경 사항을 모니터링하고 있어야 한다.
            - 메인 로직은 컨트롤러가 담당하게 된다.
        - MVC 패턴의 의의
            - 각각의 요소가 각자의 역할에만 집중하여 작동을 할 수 있다. 유지보수성, 확장성, 유연성이 증가한다.
            - 각각의 요소가 분리되어 있고 역할이 나뉘어 있기 때문에 중복 코딩 문제가 어느 정도 해결된다.
    - 그 외 다른 프로젝트 구조
        1. 레이어드 아키텍처
            
            내부 컴포넌트는 논리적으로 수평한 레이어들로 구성된다.
            
            ![image.png](image.png)
            
        2. CBD(Component Based Development)
            
            모듈화 단위로 구조화하여 재사용 가능한 컴포넌트들로 구성한다. 각 컴포넌트들을 조립하고 교환하여 하나의 프로젝트를 구성한다.
            
        3. 마이크로서비스
            
            애플리케이션 범위에서 아키텍처를 다룬다. 각 서비스별로 독립적인 환경을 다루고, 느슨하게 연동한다. 서비스별로 애플리케이션이 동작하므로 능동적이고 유연하게 서비스를 확장하고 변경할 수 있다.
            
- 비즈니스 로직
    - 실세계의 규칙에 따라 데이터를 생성,표시,저장,변경하는 부분이다.
    - 유저와 서비스에서 요구하는 결과물을 도출하는 일련의 과정들과 해당하는 로직을 수행하는 코드를 구현하는 것이다.
- DTO
    - Data Transfer Object. 데이터 전송 객체
    - 프로세스 간에 데이터를 전달하는 객체를 의미한다.
    - 비즈니스 로직과 같은 코드와 알고리즘 없이 순수하게 데이터만을 전달하는 역할이다.
    
    ![image.png](image(1).png)
    
    - 일반적인 entity를 사용하지 않고 dto를 사용하는 이유는 관심사의 분리(SoC)가 주요한 이유이다.
    - 모델, 뷰, 컨트롤러 등의 계층의 관심사는 각각 차이가 있고, 모델에서는 비밀번호, 전화번호와 같은 개인 정보를 저장하지만, 뷰 차원에서 외부에 노출되면 안되는 정보가 있다.
    - 이처럼 각 계층간의 관심사가 다르고, 저런 민감한 정보는 모델에서 뷰로 이동하면 안된다.
    - 따라서 DTO를 사용하여 엔티티의 요소를 목적에 맞게 재조정해줄 수 있고 최적화해줄 수 있다.
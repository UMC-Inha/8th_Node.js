- 외래키(Foreign Key)
    
    한 테이블의 필드가 다른 테이블의 기본키와 연결되어 있는 경우 사용한다.
    
    두 테이블 간의 관계를 설정하는데 사용된다.
    
- 기본키(Primary Key)
    
    테이블 내에서 각 행을 고유하게 식별하는 데 사용된다.
    
    기본키는 항상 유일해야 하며(중복 허용 X) null 값을 가질 수 없다.
    
- ER 다이어그램
    
    데이터베이스의 구조를 시각적으로 표현한 도구이다.
    
    **Entity Relationship Diagram**의 약자로 **개체관계도**라고 부름
    
    **Entity, Relationship, Attribute**로 구성됨
    
    데이터베이스 설계 시 각 테이블 간의 관계를 명확히 파악할 수 있다.
    
- 복합 키
    
    두 개 이상의 칼럼으로 구성된 기본 키
    
    한 테이블 내의 특정 칼럼 조합으로 고유성을 보장할 수 있다.
    
    이를 통해 데이터 중복을 방지하고 무결성을 유지할 수 있다.
    
    **SQL 예시:**
    
    ```sql
    -- 대여 정보 테이블 생성
    CREATE TABLE InternationalBookRental (
        libraryCode VARCHAR(10),
        bookCode VARCHAR(10),
        rentalDate DATE,
        returnDate DATE,
    
        PRIMARY KEY (libraryCode, bookCode) -- 복합키 설정
    );
    
    -- 대여 정보 입력 예시
    INSERT INTO InternationalBookRental (libraryCode, bookCode, rentalDate)
    VALUES ('LIB123', 'BK001', '2025-01-01');
    ```
    
    - **`PRIMARY KEY (libraryCode, bookCode)`**:
        
         `libraryCode`와 `bookCode`의 조합으로 복합키를 생성함
        
        어떤 도서관에서든 동일한 도서 코드를 가진 책이 대여되더라도, 도서관 코드를 같이 고려하면 각 대여 정보를 고유하게 구분할 수 있다!
        
- 연관관계
    
    두 개 이상의 테이블 간에 존재하는 관계를 의미한다.
    
    연관관계는 일대일, 일대다, 다대다 관계로 나뉜다.
    
    ER 다이어그램을 통해 시각적으로 표현된다.
    
    - 일대일(1 to 1)
        
        ![image.png](attachment:4093c9c3-9c6b-465b-8edd-a12065fa53c6:image.png)
        
        - 1 to 1 단방향
        - 1 to 1 양방향
    - 일 대 다 (1 to N), 다 대 일 (N to 1)
        
        ![image.png](attachment:331f8729-a88b-4224-8244-305b0b15ef9f:image.png)
        
        - 1 to 0~N : 1개와 0개에서 N개까지 연결됨
        - 1 to 1~N : 1개와 1개에서 N개까지 연결됨
        - 1 to N : 1개와 N개까지 연결됨
    - 다 대 다(N to M)
        
        ![](https://velog.velcdn.com/images/jin5eok5/post/b40d1336-0098-4e2b-97ba-20a18c066802/image.png)
        
        - N to M
        - N to 1 [관계 테이블] 1 to M
            - 두 번째 Relationship이 의미하는 것은?
                1. 다 대 다 관계 사이에 그 둘의 관계를 정리해주는 관계 속성을 만듦
                2. 두 테이블이 해당 속성을 일 대 다, 다 대 일 관계로 참조할 수 있도록 함
- 정규화
    
    [정보처리 실기_데이터베이스06강_정규화](https://youtu.be/RXQ1kZ_JHqg?si=f0OPsoOWnJXSbqca)
    
    테이블 간에 중복되는 데이터가 발생하지 않도록 하기 위해 정규화 과정이 필요하다.
    
    정규화로 테이블을 더 작은 테이블로 분해함으로써, 중복 데이터를 피하고 무결성을 유지할 수 있다. 
    
    데이터 정규화 과정은 크게 3가지로 나눈다.
    
    1. 제 1 정규화(1NF)
        1. 테이블의 각 컬럼이 원자값(=하나의 값)을 갖도록 테이블을 분해
        2. 즉, 어떤 컬럼의 값이 여러 개면 제 1 정규형에 위배
        3. 제 1 정규화 규칙
            
            <aside>
            💡
            
            1. 각 컬럼이 **하나의 속성**(원자값)만을 가져야 한다.
            2. 하나의 컬럼은 **같은 종류나 타입**(type)의 값을 가져야 한다.
            3. 각 컬럼이 **유일한**(unique) 이름을 가져야 한다.
            4. 컬럼의 순서가 상관없어야 한다.
            </aside>
            
        4. 예시
            
            **제 1 정규화 적용 전**
            
            ![image.png](attachment:bcec2420-d725-4099-8db0-6bc138721bb1:image.png)
            
            - **제 1 정규화 적용 후**
                
                ![image.png](attachment:d3f2f3cb-e6db-45ed-a081-97e84cc1a1a3:image.png)
                
                → 각 컬럼이 다중 값을 갖지 않는다!
                
    2. 제 2 정규화
        1. 테이블의 모든 컬럼이 **완전 함수 종속을 만족(=부분 종속이 X)**하도록 하는 과정
            
            <aside>
            🤔
            
            **완전 함수 종속**이란?
            
            기본 키의 부분집합에 의존하는 컬럼이 존재하지 않는 상태
            
            복합 키의 모든 부분에 의존해야 됨, 일부만 의존하면 안 된다
            
            </aside>
            
        2. 완전 함수 종속을 만족하도록 하려면, 테이블의 주제와 관련없는 컬럼을 다른 테이블로 빼주면 된다.
        3. 제 2 정규화 규칙
            
            <aside>
            💡
            
            1. **제 1 정규형**을 만족해야 한다.
            2. 모든 컬럼이 **완전 함수 종속**을 만족해야 한다.
            </aside>
            
        4. 예시
            
            **제 2 정규화 적용 전**
            
            ![image.png](attachment:fb3404cf-5c11-42c0-bd62-de15932041c2:image.png)
            
            - **제 2 정규화 적용 후**
                
                
                ![image.png](attachment:84d776eb-72f0-4bb9-93e3-0eeb13784793:image.png)
                
                ![image.png](attachment:d3158dbf-cdc4-4798-aca1-649e832abf92:image.png)
                
                → 소속학과에 종속되어 있던 학과장을 다른 테이블로 분리시킴으로써 부분 종속을 제거
                
    3. 제 3 정규화
        1. 제2정규화가 진행된 테이블에서 **이행적 종속**을 없애기 위해 테이블을 분리하는 과정
            
            <aside>
            🤔
            
            **이행적 종속**이란?
            
            A → B, B → C 면 A → C 가 성립할 때를 말한다!
            
            </aside>
            
        2. 그러니까 기본 키 외 다른 비주요 속성들은 기본 키에만 의존해야 한다(비주요 속성이 다른 비주요 속성에 의존하면 안 됨)
        3. 제 3 정규화 규칙
            
            <aside>
            💡
            
            1. **제 2 정규형**을 만족해야 한다.
            2. 기본키를 제외한 속성들 간의 **이행 종속성(Transitive Dependency)이 없어야** 한다. 즉, 기본키가 아닌 속성들은 **기본키에 의존**해야 한다.
            </aside>
            
        4. 예시
            
            **제 3 정규화 적용 전**
            
            ![image.png](attachment:27a5ce4f-9369-478b-9b9e-ce937df1a125:image.png)
            
            → [course → department], [course → lecturer], [lecturer → department] 가 종속 관계에 있음
            
            - **제 3 정규화 적용 후**
                
                ![image.png](attachment:c9a53cc5-ca17-4674-a85f-aaa5c49c23ab:image.png)
                
                ![image.png](attachment:36d2fa51-a04e-48c2-8b79-c122f639886d:image.png)
                
- 반 정규화
    
    관계형 데이터베이스에서 데이터의 중복을 일부 허용하여 데이터베이스의 읽기 성능을 향상시키는 작업이다.
    
    - **반정규화가 필요한 경우**
        - 수행 속도가 많이 느린 경우
        - 테이블의 조인 연산을 지나치게 사용하여 데이터 조회가 어려운 경우
        - 테이블에 많은 데이터가 있고, 다량의 범위 혹은 특정 범위를 자주 처리해야 하는 경우
    - **반정규화의 장점과 단점**
        - 장점
            - 데이터를 빠르게 조회할 수 있음
            - 조인을 제거하기 때문에 검색 시간이 최적화
        - 단점
            - 데이터의 삽입, 삭제, 수정 등 갱신 시 비용이 높아짐
            - 데이터간의 일관성이 깨질 수 있음 (서로 다른 데이터가 저장될 수 있음)
            - 많은 저장 공간이 필요함
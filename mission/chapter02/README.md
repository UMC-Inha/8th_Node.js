<https://velog.io/@seoki180/UMC-SQL-쿼리-정리>

- **미션 기록**

    ![UMC_WEEK1.png](attachment:4db35583-339d-4688-833a-4078a8f23e60:UMC_WEEK1.png)

    ![내가 진행중, 진행 완료한 미션 모아서 보는 쿼리(페이징 포함)](attachment:fb2c37cf-9eb2-4e18-b21c-af42c1dd2cc0:Untitled.png)

    내가 진행중, 진행 완료한 미션 모아서 보는 쿼리(페이징 포함)

    1. 내가 진행중, 진행 완료한 미션을 모아서 봐야한다.

    여기서 필요한 정보는

    1. 가게이름
    2. 미션 내용
    3. 미션 포인트
    4. 미션 상태

    이다.

    ```sql
    select 
      M.mission_Contents, 
      S.store_Name, 
      M.mission_Point, 
      M.mission_Status 
    from 
      MISSIONS M 
      inner join STORES as S on M.store_index = S.store_index 
    where 
      M.user_Index = ? 
      AND M.mission_Status = ? 
    limit 
      ? offset ?
    ```

    쿼리를 이렇게 구현해 봤다.

    MISSIONS 테이블과 STORES 테이블을 조인하여 store_name을 찾고, MISSIONS 테이블에 있는 user_index와 mission_status를 기준으로 해당 값을 찾아냈다.

    다음 쿼리를 ts로 시현해봤다

    ![image.png](attachment:37216cd4-80cf-40e7-99ad-5ce4878c703d:image.png)

    ![image.png](attachment:583d7b10-fca6-41b6-b6a6-483e33857821:image.png)

    실제 프론트와 작업을 할때는 프론트에서 해당 페이지 값을 던져주면 현재 몇 페이지에 있는지 offset을 활용해서 계산을 하면 될 것 같다.

    ---

    ![리뷰 작성하는 쿼리,
  - 사진의 경우는 일단 배제](attachment:ff64bece-430c-45e4-96fa-de1e40b984db:Untitled.png)

    리뷰 작성하는 쿼리,
  - 사진의 경우는 일단 배제

    1. 리뷰작성하는 쿼리

    리뷰작성은 내가 리뷰를 작성해서 해당 정보를 REVIEWS 테이블에 insert하는 쿼리를 만들어야 한다. (나와있는 사진은 이미 달려 있는 리뷰를 사장님이 답글 달아주는 것 같은데 일단 나는 고객이 리뷰를 작성하는 쿼리를 작성해보겠다.)

    이때 필요한 정보는

    1. 유저 이름
    2. 작성일자
    3. 별점
    4. 리뷰내용

    이다.

    ```sql
    insert into REVIEWS (
      review_Contents, review_Stars, review_CreatedDay, 
      store_Index, user_Index
    ) 
    values 
      (?, ?, ?, ?, ?)
    
    ```

    다음과 같이 구현해 봤다.

    ![image.png](attachment:feb70ba6-8238-4f29-83cd-77291bc7cdc8:image.png)

    ![image.png](attachment:61468255-1187-4054-9b02-bab8c41aa8b2:image.png)

    ![image.png](attachment:5fc3142a-f98d-4273-b9ea-f186ee5934e4:image.png)

    구현상의 문제 일 수 있는데 user_index와 store_index를 어떻게 관리할지는 고민을 해야할 것 같다.

    user_index는 로그인된 로컬에서 항상 값을 가지고 있다고 해도 store_index를 각 store마다 지정된 값으로 가지고 있고, 연산할때 그 값만 받아와서 쿼리를 날리면 insert 연산이 이렇게 간단 할 수 있지만 그게 아니라면 생각해봐야 할 문제 일 것 같다.

    ---

    ![홈 화면 쿼리
    (현재 선택 된 지역에서 도전이 가능한 미션 목록, 페이징 포함)](attachment:6ad90e83-6e2e-4f56-8779-82d16c7f7303:Untitled.png)

    홈 화면 쿼리
    (현재 선택 된 지역에서 도전이 가능한 미션 목록, 페이징 포함)

    1. 홈화면 쿼리

    이때 필요한 정보는

    1. 현재 동네
    2. 현재 미션 완료 개수
    3. 현재 내가 진행중인 미션 ( paging )
    4. 내 포인트

    ![image.png](attachment:56e0bb36-6698-4e7b-a3c3-2b36b572f2c3:image.png)

    쿼리를 구현하다가 user-area 관계를 다대다로 다시 정의했다.

    추가로 area의 area_missionCount에 다음과 같은 트리거를 추가해 자동으로 해당 지역에 몇개의 미션이 있는지 계산하도록 했다.

  - sql trigger

        ```sql
        
        CREATE TRIGGER update_mission_count_after_update
        AFTER UPDATE ON MISSIONS
        FOR EACH ROW
        BEGIN
            -- Update mission_count in area table for the area_index that was modified
            UPDATE AREAS
            SET area_MissionCount = (SELECT COUNT(*) FROM MISSIONS WHERE area_index = NEW.area_index)
            WHERE area_index = NEW.area_index;
        END;
        
        CREATE TRIGGER update_mission_count_after_insert
        AFTER INSERT ON MISSIONS
        FOR EACH ROW
        BEGIN
            -- Update mission_count in area table for the area_index of the newly inserted mission
            UPDATE AREAS
            SET area_MissionCount = (SELECT COUNT(*) FROM MISSIONS WHERE area_index = NEW.area_index)
            WHERE area_index = NEW.area_index;
        END;
        
        CREATE TRIGGER update_mission_count_after_delete
        AFTER DELETE ON MISSIONS
        FOR EACH ROW
        BEGIN
            -- Update area_MissionCount in area table for the area_index of the deleted mission
            UPDATE AREAS
            SET area_MissionCount = (SELECT COUNT(*) FROM MISSIONS WHERE area_index = OLD.area_index)
            WHERE area_index = OLD.area_index;
        END;
        
        ```

    그리고 현재 동네와 내 포인트는 하나의 쿼리로 구할수 있지만,

    현재 미션완료 개수와 현재 내가 진행중인 미션을 구하는 쿼리는 복잡하기에 셋을 나눠서 구현했다.

    ![image.png](attachment:2a9b0062-21db-4b00-bd09-4c3467638793:image.png)

    ![image.png](attachment:aad360c4-4a3b-48b3-b789-419218c1a355:image.png)

    ---

    ![Untitled](attachment:2d736cd4-e3ab-4c55-9b1d-ad818cc22dbf:Untitled.png)

    마이 페이지 화면 쿼리

    1. 마이페이지

    이때 필요한 정보는

    1. 유저이름
    2. 유저 포인트
    3. 유저 이메일
    4. 유저 휴대전화번호

    ```sql
    select 
      user_Name, 
      user_Point, 
      user_Email, 
      user_Phone 
    from 
      USERS 
    where 
      user_index = ?
    
    ```

    다음과 같이 구현했다

    ![image.png](attachment:cbd3753e-85da-4f84-8d9b-bd8c811713df:image.png)

    ![image.png](attachment:06393ab7-4b0e-48c3-b8fe-b5818ff7579c:image.png)

    여기서도 마찬가지로 클라이언트는 이미 user_index를 로그인할때 저장하도록 구현했다고 생각하고 쿼리를 작성했다.

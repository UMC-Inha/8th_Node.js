# 미션
```
SELECT
    m.mission_id,
    m.mission_title,
    m.mission_description,
    m.point,
    s.store_name,
    m_log.status,
    m_log.created_at
FROM user_mission_log AS m_log
JOIN mission AS m
    ON m_log.mission_id = m.mission_id
JOIN store AS s
    ON m.store_id = s.store_id
WHERE m_log.user_id = 3
  AND m_log.status IN ('진행중', '완료')       
ORDER BY m_log.created_at DESC              
LIMIT 3 OFFSET 0;     

```

# 리뷰 작성
```
INSERT INTO review (
    user_id,
    store_id,
    rating,
    comment,
    created_at
) VALUES (
    3,                     
    10,                  
    5,                      
    '음 너무 맛있어요 포인트도 얻고 맛있는 맛집도 알게 된것 같아 너무나도 행복한 식사였답니다. 다음에 또 올게요!!'',  
    NOW()                    
);
```

# 홈 화면
```
    m.mission_id,
    m.mission_title,
    m.mission_description,
    m.point, 
    s.store_name,
    r.region_name,
    m_log.status AS user_mission_status
FROM mission AS m
JOIN store AS s
    ON m.store_id = s.store_id
JOIN region AS r
    ON s.region_id = r.region_id
LEFT JOIN user_mission_log AS m_log
    ON m_log.mission_id = m.mission_id
   AND m_log.user_id = 3
WHERE r.region_id = 3
  AND (
       m_log.status IS NULL    // 미션 시작 안함
       OR m_log.status != '완료' 
      )
ORDER BY m.mission_id DESC
LIMIT 2 OFFSET 0;
```

# 마이 페이지
```dotnetcli
SELECT
    u.user_id,
    u.user_name AS nickname,         
    u.user_sns_email AS email,       
    u.user_phone,
    CASE 
      WHEN u.user_phone IS NOT NULL THEN '인증됨'
      ELSE '미인증'
    END AS phone_verification_status,
    IFNULL(p.total_points, 0) AS total_points  
FROM user AS u
LEFT JOIN (
    SELECT user_id, SUM(point) AS total_points
    FROM point_log
    GROUP BY user_id
) AS p ON p.user_id = u.user_id
WHERE u.user_id = 3;

```
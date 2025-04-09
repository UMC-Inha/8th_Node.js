-- 진행 중, 진행 완료 미션 조회 쿼리
SELECT 
  m.description,
  m.point,
  ml.status,
  s.id,
  s.name
FROM MissionLog ml
JOIN Mission m
ON ml.mission_id = m.id
JOIN Shop s
ON m.shop_id = s.id
WHERE ml.user_id = 1
ORDER BY ml.updated_at DESC
LIMIT 10;

-- 리뷰 작성 쿼리
INSERT INTO Review 
  (shop_id, 
  user_id, 
  rating, 
  comment, 
  created_at, 
  updated_at)
VALUES (1, 1, 5, '리뷰 내용', NOW(), NOW());

-- 홈 화면 쿼리
SELECT 
  r.name,
  s.name,
  m.description,
  m.point
FROM Mission m
JOIN Shop s ON m.shop_id = s.id
JOIN Region r ON s.region_id = r.id
LEFT JOIN MissionLog ml ON m.id = ml.mission_id
AND ml.user_id = 1
WHERE r.id = 1
  AND (
    ml.id IS NULL
    OR ml.status
    NOT IN ('completed', 'in_progress')
    )
  AND (
    m.due_date IS NULL
    OR m.due_date >= CURRENT_TIMESTAMP
    )
ORDER BY m.created_at DESC
LIMIT 10;

-- 마이페이지 화면 쿼리
SELECT 
  ui.username,
  ul.email,
  ui.phone_number,
  ui.point
FROM UserInfo ui
JOIN UserLogin ul ON ui.id = ul.id
WHERE ui.id = 1;
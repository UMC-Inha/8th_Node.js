-- 진행 중, 진행 완료 미션 조회 쿼리
SELECT 
  m.description,
  m.point,
  ml.status,
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
WHERE r.id = 1
AND 
  m.id NOT IN (
      SELECT mission_id
      FROM MissionLog
      WHERE user_id = 1
      AND status = 'completed'
  );
ORDER BY m.created_at DESC
LIMIT 10;

-- 마이페이지 화면 쿼리
SELECT 
    ui.username,
    ul.email,
    ui.phone_number,
    (SELECT SUM(m.point) 
     FROM MissionLog ml 
     JOIN Mission m
     ON ml.mission_id = m.id 
     WHERE ml.user_id = ui.id
     AND ml.status = 'completed') AS total_points
FROM UserInfo ui
JOIN UserLogin ul ON ui.id = ul.id
WHERE ui.id = 1;
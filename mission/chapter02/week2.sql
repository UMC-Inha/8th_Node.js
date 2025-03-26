SELECT m.content, m.point, m.status, s.shop_name
FROM mission AS m
JOIN shop AS s
ON m.shop_id = s.id
JOIN user AS u
ON m.user_id = u.id
WHERE u.id = 1 AND m.id > 1
AND m.status IN (2, 3)
ORDER BY m.created_at DESC
LIMIT 10;

INSERT INTO review
    (user_id,
    shop_id,
    review_title,
    review_content,
    review_stars)
VALUES(1, 1, '리뷰1', '리뷰1 내용', 9);

SELECT
    a.area_name,
    area_shop.shop_name,
    area_mission.content,
    area_mission.point
FROM area AS a
JOIN shop AS area_shop
ON a.id = area_shop.area_id
JOIN mission AS area_mission
ON area_shop.id = area_mission.shop_id
JOIN user AS u
ON area_mission.user_id = u.id
WHERE a.area_name = '송도'
AND u.id = 2
AND area_mission.id > 1
AND area_mission.status = 1
ORDER BY area_shop.shop_name
LIMIT 10;

SELECT
    u.username,
    u.email,
    u.phone_number,
    u.point
FROM user AS u
WHERE u.id = 1;
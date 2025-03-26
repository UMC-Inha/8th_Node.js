CREATE TABLE `mission` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`user_id`	INT	NOT NULL,
	`shop_id`	INT	NOT NULL,
	`content`	TEXT	NULL,
	`point`	INT	NULL,
	`created_at`	DATETIME(6)	NOT NULL	DEFAULT now(),
	`updated_at`	DATETIME(6)	NULL	DEFAULT on update now(),
	`status`	TINYINT	NOT NULL	DEFAULT 1
);

CREATE TABLE `user` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`username`	VARCHAR(20)	NULL,
	`gender`	TINYINT	NULL,
	`address`	VARCHAR(50)	NULL,
	`email`	VARCHAR(30)	NULL,
	`phone_number`	VARCHAR(20)	NULL,
	`point`	INT	NOT NULL	DEFAULT 0
);

CREATE TABLE `shop` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`shop_category`	INT	NOT NULL,
	`area_id`	INT	NOT NULL,
	`shop_name`	VARCHAR(20)	NOT NULL,
	`shop_address`	VARCHAR(50)	NOT NULL
);

CREATE TABLE `shop_category` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`category`	VARCHAR(10)	NOT NULL
);

CREATE TABLE `alarm` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`user_id`	INT	NOT NULL,
	`alarm_title`	TEXT	NOT NULL	DEFAULT 알람 이름입니다.,
	`alarm_content`	TEXT	NULL,
	`created_at`	DATETIME(6)	NOT NULL	DEFAULT now(),
	`updated_at`	DATETIME(6)	NULL	DEFAULT on update now()
);

CREATE TABLE `review` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`user_id`	INT	NOT NULL,
	`shop_id`	INT	NOT NULL,
	`review_title`	TEXT	NOT NULL	DEFAULT 리뷰 제목입니다.,
	`review_content`	TEXT	NOT NULL,
	`review_stars`	TINYINT	NULL	DEFAULT 0,
	`created_at`	DATETIME(6)	NOT NULL	DEFAULT now(),
	`updated_at`	DATETIME(6)	NULL	DEFAULT on update now()
);

CREATE TABLE `user_food_category` (
	`user_id`	INT	NOT NULL,
	`food_id`	INT	NOT NULL
);

CREATE TABLE `food_category` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`food`	VARCHAR(10)	NOT NULL
);

CREATE TABLE `area` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`area_name`	VARCHAR(10)	NOT NULL
);

CREATE TABLE `user_area_mission` (
	`id`	INT	NOT NULL	DEFAULT auto increment,
	`id2`	INT	NOT NULL	DEFAULT auto increment,
	`required_mission`	INT	NULL,
	`completed_mission`	INT	NULL
);

ALTER TABLE `mission` ADD CONSTRAINT `PK_MISSION` PRIMARY KEY (
	`id`
);

ALTER TABLE `user` ADD CONSTRAINT `PK_USER` PRIMARY KEY (
	`id`
);

ALTER TABLE `shop` ADD CONSTRAINT `PK_SHOP` PRIMARY KEY (
	`id`
);

ALTER TABLE `shop_category` ADD CONSTRAINT `PK_SHOP_CATEGORY` PRIMARY KEY (
	`id`
);

ALTER TABLE `alarm` ADD CONSTRAINT `PK_ALARM` PRIMARY KEY (
	`id`
);

ALTER TABLE `review` ADD CONSTRAINT `PK_REVIEW` PRIMARY KEY (
	`id`
);

ALTER TABLE `food_category` ADD CONSTRAINT `PK_FOOD_CATEGORY` PRIMARY KEY (
	`id`
);

ALTER TABLE `area` ADD CONSTRAINT `PK_AREA` PRIMARY KEY (
	`id`
);


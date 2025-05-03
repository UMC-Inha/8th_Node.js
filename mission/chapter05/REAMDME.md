## 로그인 처리 플로우

[브라우저/앱] ──► 1. Express 서버 (index.js)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 2. 컨트롤러 (user.controller.js) ← (HTTP Body)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 3. DTO (user.dto.js) ← (body ↔ 자바스크립트 객체 정제)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 4. 서비스 (user.service.js) ← (비즈니스 로직)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 5. 레포지토리 (user.repository.js) ← (SQL 실행)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─ 6. MySQL 풀 (db.config.js)

# review.controller.js 코드 분석
```
import { addReviewService } from "../services/review.service.js";
export const handleAddReview = async (req, res) => {
  const storeId = parseInt(req.params.storeId);

  // userId, rating, content, images 전부 body에서 받기
  const { userId, rating, content, images } = req.body;

  if (!userId) {
    return res.status(401).json({ message: "userId가 없습니다." });
  }

  try {
    const review = await addReviewService({
      storeId,
      userId: parseInt(userId),
      rating,
      content,
      images
    });

    return res.status(201).json(review);
  } catch (err) {
    console.error(err);
    return res.status(400).json({ message: err.message });
  }
};

```
- 컨트롤러이다. 클라이언트에서 요청을 받고 service에 넘기는 역할이다.
- HTTP 요청을 받는다.(POST)
- Body에 JSON형태의 리뷰 내용 데이터가 있을것이다.
- 서비스 계층의 HTTP 응답을 반환한다.

# review.service.js 분석
```
import { responseFromReview } from "../dto/review.dto.js";
import {
  getStoreById,
  saveReview,
  saveReviewImages,
  getReviewById,
  getReviewImagesByReviewId
} from "../repositories/review.repository.js";

export const addReviewService = async ({ storeId, userId, rating, content, images }) => {

  const store = await getStoreById(storeId);
  if (!store) {
    throw new Error("존재하지 않는 가게입니다.");
  }

  const reviewId = await saveReview({ storeId, userId, rating, content });

  let savedImages = [];
  if (images && images.length > 0) {
    for (const imageUrl of images) {
      await saveReviewImages(reviewId, imageUrl);
      savedImages.push(imageUrl);
    }
  }

  const review = await getReviewById(reviewId);
  const imageRecords = await getReviewImagesByReviewId(reviewId);

  return responseFromReview({ review, images: imageRecords });
};

```
- 비즈니스 로직담당 계층이다.
- 컨트롤러에서 받은 데이터를 저장소로 보낸다.
- DTO 변환을 통해 컨트롤러에 데이터를 반환
- 예외 처리가 중요하다.

# review.repository.js 분석
```
import { pool } from "../db.config.js";

export const getStoreById = async (storeId) => {
  const conn = await pool.getConnection();
  try {
    const [store] = await pool.query(
      `SELECT * FROM store WHERE id = ?;`,
      storeId
    );

    if (store.length === 0) {
      return null;
    }

    return store[0];
  } catch (err) {
    throw new Error(`가게 조회 중 오류 발생: ${err}`);
  } finally {
    conn.release();
  }
};

export const saveReview = async ({ storeId, userId, rating, content }) => {
  const conn = await pool.getConnection();
  try {
    const [result] = await pool.query(
      `INSERT INTO review (store_id, user_id, rating, content, created_at) VALUES (?, ?, ?, ?, NOW());`,
      [storeId, userId, rating, content]
    );

    return result.insertId;
  } catch (err) {
    throw new Error(`리뷰 추가 중 오류 발생: ${err}`);
  } finally {
    conn.release();
  }
};

export const saveReviewImages = async (reviewId, imageUrl) => {
  const conn = await pool.getConnection();
  try {
    await pool.query(
      `INSERT INTO review_image (review_id, url) VALUES (?, ?);`,
      [reviewId, imageUrl]
    );
    return;
  } catch (err) {
    throw new Error(`리뷰 이미지 추가 중 오류 발생: ${err}`);
  } finally {
    conn.release();
  }
};

export const getReviewById = async (reviewId) => {
  const conn = await pool.getConnection();
  try {
    const [review] = await pool.query(
      `SELECT * FROM review WHERE id = ?;`,
      reviewId
    );

    if (review.length === 0) {
      return null;
    }

    return review[0];
  } catch (err) {
    throw new Error(`리뷰 조회 중 오류 발생: ${err}`);
  } finally {
    conn.release();
  }
};

export const getReviewImagesByReviewId = async (reviewId) => {
  const conn = await pool.getConnection();
  try {
    const [images] = await pool.query(
      `SELECT * FROM review_image WHERE review_id = ?;`,
      reviewId
    );

    return images;
  } catch (err) {
    throw new Error(`리뷰 이미지 조회 중 오류 발생: ${err}`);
  } finally {
    conn.release();
  }
};

```
### getStoreById : store 테이블에서 단일 행 조회
- null 또는 id, name을 반환
### saveReview
- 리뷰를 INSERT하는 역할
- 리뷰와 이미지를 함께 저장할 때 전체가 성공하거나 롤백되도록 트랜잭션 적용 고려
### saveReviewImage
- 리뷰 이미지 INSERT
### getReviewById
- 단일 리뷰 조회
- getStoreById와 동일한 패턴
### getReviewImagesByReviewId
- 특정 리뷰의 이미지 목록 조회
https://github.com/codie0226/UMC8Practice/tree/feature/chapter05

1. addShop
    
    ![addshop.PNG](addshop.png)
    
    ![addshopfail.PNG](addshopfail.png)
    
2. addReview
    
    ![addReview.PNG](addReview.png)
    
    ![addReviewfail.PNG](addReviewfail.png)
    
3. addMission
    
    ![newmission.PNG](newmission.png)
    
    ![newmissionfail.PNG](newmissionfail.png)
    
4. acceptMission
    
    ![acceptmissionfail.PNG](acceptmissionfail.png)
    
5. 구현 방식
    1. dto
        
        ```jsx
        export const responseFromUser = (user, preference) => {
            return {
                name: user.username,
                email: user.email,
                gender: user.gender,
                birth: user.birth,
                address: user.address,
                phone_number: user.phone_number,
                preferences: preference.map((pref) => pref.food)
            }
        }
        ```
        
        평범한 dto 코드. mapping을 활용하여 preference의 food 내용만 빼와서 저장한다.
        
    2. repository
        
        ```jsx
        export const acceptMission = async (missionId, userId) => {
            const conn = await pool.getConnection();
        
            try{
                const [confirm] = await conn.query('SELECT EXISTS(SELECT 1 FROM mission WHERE id = ?) as isExistMission',
                    [missionId]
                );
        
                if(!confirm[0].isExistMission){
                    return null;
                }
        
                const [result] = await conn.query('INSERT INTO mission_log(mission_id, user_id) VALUES(?, ?)',
                    [missionId, userId]
                );
        
                return result.insertId;
            }catch(err){
                throw new Error(
                    `오류 발생. (${err})`
                );
            } finally{
                conn.release();
            }
        };
        ```
        
        DB 작업 중 에러처리를 위해 try-catch-finally문 사용. finally에는 connection을 release해주는 것이 필요하다.
        
        confirm에서 반환값이 배열이므로 confirm.[0]으로 하나의 값에서 읽어오도록 해야한다.
        
    3. controller
        
        ```jsx
        export const handleAcceptMission = async(req, res, next) => {
            console.log("미션 수락");
            console.log("Mission: ", req.params.id);
        
            try{
                await serviceAcceptMission(req.params.id, 1);
                res.status(StatusCodes.OK).json({result: "success"});
            }catch(err){
                res.status(StatusCodes.BAD_REQUEST).json({error: err.message});
            }
        };
        ```
        
        평범한 컨트롤러 코드. console.log()로 요청 정보를 다시 볼 수 있게 하고 service로 req.body와 params정보를 넘긴다. 시니어 미션으로 에러 처리를 status.json()으로 json형식으로 나올 수 있도록 했다.
        
        사실 미들웨어로 구현할 수 있지만 아직 진도 안나가서 안함.
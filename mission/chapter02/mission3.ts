import db from "./db.ts"

let q_CountMissions = `
select 
  count(*)
from USERS U
  inner join USER_AREA UA on UA.user_index = U.user_index
  inner join AREAS A on A.area_index = UA.area_index
  inner join MISSIONS M on M.user_index = U.user_index
where 
  U.user_index = ?
  AND M.mission_Status = ?`

let q_UserInfo = `
select 
  U.user_Point, 
  A.area_Name
from USERS U
  inner join USER_AREA UA on UA.user_index = U.user_index
  inner join AREAS A on A.area_index = UA.area_index
where 
  U.user_index = ?`

let q_PagingMissions = `
select 
  M.mission_Contents, 
  S.store_Name, 
  mission_Point, 
  mission_Status 
from 
  MISSIONS M 
  inner join STORES as S on M.store_index = S.store_index 
where 
  M.user_Index = ? 
  AND M.mission_Status = ? 
limit 
  ? offset ?
`


db.query(q_CountMissions,[1,1],(err,res)=>{
    if(err) throw err
    console.log(res)
})

db.query(q_UserInfo,1,(err,res)=>{
  if(err) throw err
  console.log(res)
})

db.query(q_PagingMissions,[1,1,2,0],(err,res)=>{
  if(err) throw err
  console.log(res)
})

db.end()
import db from "./db.ts"

let q1 = `
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

db.query(q1,[1,1,4,0],(err,res)=>{
  if(err) throw err
  console.log(res)
})

db.end()


import db from "./db.ts"

let q = `
select user_Name, user_Point, user_Email, user_Phone
from USERS
where user_index = ?`

db.query(q,1,(err,res)=>{
    if(err) throw err
    console.log(res)
})
db.end()
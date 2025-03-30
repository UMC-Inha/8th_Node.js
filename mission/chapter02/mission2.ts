import db from "./db.ts"

let reviews = `음 너무 맛있고 다음에도 올거 같아요`
let star = 4
let date = new Date()

let q = `
insert into REVIEWS (review_Contents, review_Stars, review_CreatedDay,store_Index, user_Index)
values (?,?,?,?,?)
`

db.query(q,[reviews,star,date,1,1],(err,res)=>{
    if(err) throw err
    console.log(res)
})

db.end()
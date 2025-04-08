import express, {Request,Response, NextFunction, Application } from "express"
import morgan from "morgan"
import db from "./db.ts"
import jwt from "jsonwebtoken";

const SECRET_KEY = "1234"

const generateToken = (payload: object) => {
  return jwt.sign(payload, SECRET_KEY, { expiresIn: "1h" });
};

// // 인증 미들웨어
// const authenticateJWT = (req: Request, res: Response, next: NextFunction) : Response => {
//   const authHeader = req.headers.authorization;

//   if (!authHeader || !authHeader.startsWith("Bearer ")) {
//     return res.status(401).json({ message: "No token provided" });
//   }

//   const token = authHeader!.split(" ")[1];

//   try {
//     const decoded = jwt.verify(token, SECRET_KEY);
//     (req as any).user = decoded;
//     next();
//   } catch (err) {
//     return res.status(403).json({ message: "Invalid token" });
//   }
//   return res.json({message : "wrong"})
// };

let app :Application= express()

app.use(express.json()); 
app.use(express.urlencoded( {extended : false } ));
app.use(morgan("dev"))


app.post("/login",(req : Request,res : Response) =>{
    const {id,password} = req.body
    // 로그인하면 db에서 user_index를 받아올거임, 그걸 token에 넣어 서 만들면 됨
    // 일단 성공해서 user_index를 받아왔다고 가정
    const user_index = {"user_index" : 1}
    const token = generateToken(user_index)
    res.json({token})
})

app.get("/me",(req:Request,res:Response)=>{
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      res.status(401).json({ message: "No token provided" });
    }
    const token = authHeader!.split(" ")[1];
    try {
      const decoded = jwt.verify(token, SECRET_KEY);
      (req as any).user = decoded;
      const user = (req as any).user;

      res.json({ message: "Access granted!",decoded});

    } catch (err) {
      res.status(403).json({ message: "Invalid token" ,err});
    }

})

app.listen(3000)
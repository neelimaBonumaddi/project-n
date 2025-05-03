import express, { json } from 'express';
import cors from 'cors';
import { Client } from 'pg';
const client =  new Client({connectionString: "postgresql://neondb_owner:npg_yHbvXoK0CAt6@ep-lingering-mouse-a1lgdbf5-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require"});
 
await client.connect((err)=>{
    if (err){
        console.log("failed to connect Neon")
    }else{
        console.log("Succesfully connected to Nen")
    }
})
const app = express();
app.use(cors());
app.use(json());

app.get('/', (req,res)=>{
    console.log('default Route');
})

app.get('/users',async(req,res)=>{
    const result= await client.query('select * from customer');
    console.log(result.rows);
    res.send(JSON.stringify(result.rows))
})

app.post('/add-item',  (req,res)=>{
    console.log(req.body);
    req.send("added succesfully")
})


app.listen(3000,()=>{
    console.log('server started running on port 3000');
})
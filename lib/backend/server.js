require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express()
app.use(cors())
app.use(express.json())

mongoose.connect(process.env.MONGO_URI,{useNewUrlParser: true,useUnifiedTopology: true,})

const User = mongoose.model('User',new mongoose.Schema({
    name : String,
    email : String,
}));

const Trip = mongoose.model('Trip', new mongoose.Schema({
    name : String,
    createdBy : mongoose.Schema.Types.ObjectId,
    members : [mongoose.Schema.Types.ObjectId],
}));

const Transaction = mongoose.model('Transaction', new mongoose.Schema({
    tripId : mongoose.Schema.Types.ObjectId,
    paidBy : mongoose.Schema.Types.ObjectId,
    amount : Number,
    distributedTo : [
        {
            userId : mongoose.Schema.Types.ObjectId,
            amount : Number
        }
    ],
}));


//for add user
app.post('/users',async (req,res)=>{
    try{
        const user = await User.create(req.body);
        res.status(201).json(user);
    }catch(error){
        res.status(400).json({error: error.message});
    }
})

//create a trip
app.post('/trips',async (req,res) => {
    try{
        const trip = await Trip.create(req.body);
        res.status(201).json(trip);
    }catch(error){
        res.status(400).json({error: error.message});
    }
})

//get specific trip
app.get('/trips/:tripId',async (req,res) =>{
    try{
        const trip = await Trip.findById({_id : req.params.tripId}).populate('createdBy', '_id name').populate('members', '_id name')
        res.json(trip);
    }catch(error){
       res.status(400).json({error : error.message})
    }
})

//create a transaction
app.post('/transactions',async (req,res) => {
    try{
        const transaction = await Transaction.create(req.body);
        res.status(201).json(transaction)
    }catch(error){
        res.status(400).json({error : error.message})
    }
})

//fetch data from transactions
app.get('/transactions/:tripId',async (req,res) =>{
    try{
        const transactions = await Transaction.find({tripId : req.params.tripId});
        res.json(transactions);
    }catch(e){
        print(e);
    }
})

//fetch all users
app.get('/users/',async (req,res) =>{
    try{
        const users = await User.find();
        res.json(users);
    }catch(e){
        print(e);
    }
})

app.listen(2000,()=>{
    console.log('Server is working!!!')
})
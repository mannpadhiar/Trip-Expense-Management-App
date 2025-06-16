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
}));

const Trip = mongoose.model('Trip', new mongoose.Schema({
    name : String,
    createdBy : { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    members: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }]
}));

const Transaction = mongoose.model('Transaction', new mongoose.Schema({
    tripId : { type: mongoose.Schema.Types.ObjectId, ref: 'Trip' },
    paidBy : { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    amount : Number,
    description : String,
    distributedTo : [
        {
            userId : { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
            amount : Number
        }
    ],
    createdDate: {
        type : Date,
        default : Date.now
    }
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
        const transactions = await Transaction.find({tripId : req.params.tripId}).populate('paidBy', '_id name').populate("distributedTo.userId", "_id name");
        res.json(transactions);
    }catch(e){
        print(e);
    }
})

//add a member of a trip // someone join the group
app.post("/trip/:tripId/addMember", async (req, res) => {
    try {
        const { tripId } = req.params;
        const { userId } = req.body;

        if (!mongoose.Types.ObjectId.isValid(tripId) || !mongoose.Types.ObjectId.isValid(userId)) {
            return res.status(400).json({ message: "Invalid tripId or userId" });
        }
        const tripObjectId = new mongoose.Types.ObjectId(tripId);
        const userObjectId = new mongoose.Types.ObjectId(userId);

        const trip = await Trip.findByIdAndUpdate(
            tripObjectId,
            { $addToSet: { members: userObjectId } }, // Prevents duplicate members
            { new: true }
        ).populate("members");

        if (!trip) {
            return res.status(404).json({ message: "Trip not found" });
        }

        res.json({ message: "Member added successfully", trip });
    } catch (error) {
        console.error("Error adding member:", error);
        res.status(500).json({ message: "Error adding member", error: error.message });
    }
});

//fetch all users
app.get('/users/',async (req,res) =>{
    try{
        const users = await User.find();
        res.json(users);
    }catch(e){
        print(e);
    }
})

app.get('/ping',async (req,res) =>{
    res.status(200).send('pong');
})

app.listen(2000,()=>{
    console.log('Server is working!!!')
})
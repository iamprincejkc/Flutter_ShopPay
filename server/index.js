//Import from packages
const express = require('express');
const mongoose = require('mongoose');

//Import from another files
const authRouter = require('./routes/auth');

//Initialize
const PORT = 3000;
const app = express(authRouter);
const DB = "mongodb+srv://iamprincejkc:herozone1@cluster0.dkqt4q3.mongodb.net/ShopPay?retryWrites=true&w=majority";

//Middleware
app.use(express.json());
app.use(authRouter);

mongoose.connect(DB).then(() => {
    console.log('Connection Successful')
}).catch((e) => { console.log(e); });

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT} . . .`)
});

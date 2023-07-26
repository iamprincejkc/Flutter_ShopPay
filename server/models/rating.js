const mongoose = require('mongoose');

const ratingSchema = mongoose.Schema({
    userId: {
        type: String,
    },
    rating: {
        type: Number,
    }
});


module.exports = ratingSchema;
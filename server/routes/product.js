const express = require('express');
const productRouter = express.Router();
const auth = require('../middlewares/auth');
const Product = require('../models/product');


productRouter.get('/api/products', auth, async (req, res) => {
    try {

        const products = await Product.find({ category: req.query.category });
        if (products.length == 0) {
            return res.status(404).json({ msg: 'No Products' });
        }
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});



productRouter.get('/api/products/search/:name', auth, async (req, res) => {
    try {
        const products = await Product.find({ name: { $regex: req.params.name, $options: "i" } });
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


productRouter.post('/api/rate-product', auth, async (req, res) => {
    try {
        console.log(req.body);
        const { id, rating } = req.body;
        let product = await Product.findById(id);
        console.log(product);
        for (let index = 0; index < product.ratings.length; index++) {
            if (product.ratings[index].userId == req.userId) {
                product.ratings.splice(index, 1);
                break;
            }
        }

        const ratingSchema = {
            userId: req.userId,
            rating
        }
        console.log(ratingSchema);

        product.ratings.push(ratingSchema);
        product = await product.save();
        res.json(product);

    } catch (error) {
        console.log(error);
        res.status(500).json({ error: error.message });
    }
});


productRouter.get('/api/deal-of-day', auth, async (req, res) => {
    try {
        let products = await Product.find({});
        products.sort((product1, product2) => {
            let product1Sum = 0;
            let product2Sum = 0;
            for (let i = 0; i < product1.ratings.length; i++) {
                product1Sum += product1.ratings[index].rating;
            }
            for (let i = 0; i < product2.ratings.length; i++) {
                product2Sum += product2.ratings[index].rating;
            }
            return product1 < product2 ? 1 : -1;
        });
        res.json(products[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


module.exports = productRouter;
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



productRouter.get('/api/products/search:name', auth, async (req, res) => {
    try {
        const products = await Product.find({ name: { $regex: req.params.name, $options: "i" } });
        res.json(products);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


productRouter.post('/api/rate-product', auth, async (req, res) => {
    try {
        const { id, rating } = req.body;
        let product = await Product.findById(id);
        for (let index = 0; index < product.ratings.length; index++) {
            if (product.ratings[index].userId == req.user) {
                product.ratings.splice(index, 1);
                break;
            }
        }

        const ratingSchema = {
            userId: req.user,
            rating
        }

        product.ratings.push(ratingSchema);
        product = await product.save();
        res.json(product);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


module.exports = productRouter;
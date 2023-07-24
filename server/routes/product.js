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


module.exports = productRouter;
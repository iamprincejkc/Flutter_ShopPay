const express = require('express');
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
const Product = require('../models/product');

adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try {
        const { name, description, images, quantity, price, category } = req.body;
        let product = new Product({
            name,
            description,
            images, quantity,
            price,
            category,
        });
        product = await product.save();
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

adminRouter.get('/admin/get-products', admin, async (req, res) => {
    try {
        let product = await Product.find();
        if (product.length() == 0) {
            return res.status(404).json({ msg: 'No Products' });
        }
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


module.exports = adminRouter;
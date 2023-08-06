const express = require('express');
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
const { Product } = require('../models/product');
const Order = require('../models/order');

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
        if (product.length == 0) {
            return res.status(404).json({ msg: 'No Products' });
        }
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

adminRouter.post('/admin/delete-product', admin, async (req, res) => {
    try {
        const { id } = req.body;
        let product = await Product.findByIdAndDelete(id);
        res.json(product);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

adminRouter.get('/admin/get-orders', admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        res.json(orders);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
})

adminRouter.post('/admin/changer-order-status', admin, async (req, res) => {
    try {
        const { id, status } = req.body;
        let order = await Order.findById(id);
        order.status = status;
        order = await order.save();
        res.json(order);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


adminRouter.get('/admin/analytics', admin, async (req, res) => {
    try {
        const orders = await Order.find({});
        let totalEarnings = 0;

        for (let i = 0; i < orders.length; i++) {
            for (let index = 0; index < orders[i].products.length; index++) {
                totalEarnings += orders[i].products[index].quantity * orders[i].products[index].product.price;
            }
        }

        //Fetch Mobile Category
        let mobilesEarnings = await fetchCategoryWiseProduct('Mobiles');
        let essentailsEarnings = await fetchCategoryWiseProduct('Essentails');
        let appliancesEarnings = await fetchCategoryWiseProduct('Appliances');
        let booksEarnings = await fetchCategoryWiseProduct('Books');
        let fashionEarnings = await fetchCategoryWiseProduct('Fashion');


        let earnings = {
            totalEarnings,
            mobilesEarnings,
            essentailsEarnings,
            appliancesEarnings,
            booksEarnings,
            fashionEarnings
        };
        console.log(earnings);
        res.json(earnings);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


async function fetchCategoryWiseProduct(category) {

    let categoryOrders = await Order.find({ 'products.product.category': category });
    let earnings = 0;
    for (let i = 0; i < categoryOrders.length; i++) {
        for (let index = 0; index < categoryOrders[i].products.length; index++) {
            earnings += categoryOrders[i].products[index].quantity * categoryOrders[i].products[index].product.price;
            console.log(categoryOrders[i].products[index].quantity);
            console.log(categoryOrders[i].products[index].product.price);
            console.log(earnings);
        }
    }
    return earnings;
}

module.exports = adminRouter;
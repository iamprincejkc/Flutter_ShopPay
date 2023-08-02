const express = require('express');
const userRouter = express.Router();
const auth = require('../middlewares/auth');
const Order = require('../models/order');
const { Product } = require('../models/product');
const User = require('../models/user');


userRouter.post('/api/add-to-cart', auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);
        let user = await User.findById(req.userId);

        let isProductFound = false;
        if (user.cart.length == 0) {
            user.cart.push({ product, quantity: 1 });
        } else {
            for (let index = 0; index < user.cart.length; index++) {
                if (user.cart[index].product._id.equals(product._id)) {
                    isProductFound = true;

                }
            }
        }

        if (isProductFound) {
            let productCart = user.cart.find((findProduct) => findProduct.product._id.equals(product._id));
            productCart.quantity++;
        }

        user = await user.save();
        res.json(user);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});




userRouter.delete('/api/remove-from-cart/:id', auth, async (req, res) => {
    try {
        const { id } = req.params;
        const product = await Product.findById(id);
        let user = await User.findById(req.userId);

        for (let index = 0; index < user.cart.length; index++) {
            if (user.cart[index].product._id.equals(product._id)) {
                if (user.cart[index].quantity == 1) {
                    user.cart.splice(index, 1);
                } else {
                    user.cart[index].quantity -= 1;
                }
            }
        }

        user = await user.save();
        res.json(user);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});



userRouter.post('/api/save-user-address', auth, async (req, res) => {
    try {
        const { address } = req.body;
        let user = await User.findById(req.userId);
        user.address = address;
        user = await user.save();
        res.json(user);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


userRouter.post('/api/order', auth, async (req, res) => {
    try {
        const { cart, totalPrice, address } = req.body;
        let products = [];

        for (let index = 0; index < cart.length; index++) {
            let product = await Product.findById(cart[index].product._id);
            if (product.quantity >= cart[index].quantity) {
                product.quantity -= cart[index].quantity;
                products.push({ product, quantity: cart[index].quantity });
                await product.save();
            } else {
                return res.status(400).json({ msg: `${product.name} is out of stock` });
            }
        }
        console.log(req);
        let user = await User.findById(req.userId);
        console.log(user);
        user.cart = [];
        user = await user.save();

        let order = new Order({
            products,
            totalPrice,
            address,
            userId: user._id,
            orderedAt: new Date().getTime(),
        });

        order = await order.save();

        res.json(order);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

userRouter.get('/api/orders/me', auth, async (req, res) => {
    try {
        const orders = await Order.find({ userId: req.userId });
        res.json(orders);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


module.exports = userRouter;
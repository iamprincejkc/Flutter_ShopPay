const express = require('express');
const userRouter = express.Router();
const auth = require('../middlewares/auth');
const { Product } = require('../models/product');
const User = require('../models/user');


userRouter.post('/api/add-to-cart', auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);
        let user = await User.findById(req.userId);

        if (user.cart.length == 0) {
            user.cart.push({ product, quantity: 1 });
        } else {
            let isProductFound = false;
            for (let index = 0; index < user.cart.length; index++) {
                if (user.cart[index].product._id.equals(product._id)) {
                    isProductFound = true;

                }
            }
        }

        if (isProductFound) {
            let productCart = user.cart.find((findProduct) => findProduct.product._id.equals(product._id));
            productCart.quantity++;
        } else {
            user.cart.push({ product, quantity: 1 });
        }

        user = await user.save();
        res.json(user);

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


module.exports = userRouter;
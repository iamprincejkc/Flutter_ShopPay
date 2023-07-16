const jwt = require('jsonwebtoken');

const auth = async (req, res, next) => {
    try {
        const token = req.header('x-auth-token');
        if (!token)
            return res.status(401).json({ msg: 'User not authorized, access denied!' });
        const verified = jwt.verify(token, 'ShopPayPassKey');
        if (!verified)
            return res.status(401).json({ msg: 'Token verification failed, authorization denied!' })
        req.userId = verified.id;
        req.token = token;
        next();
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}
module.exports = auth;
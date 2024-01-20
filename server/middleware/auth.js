const { User } = require("../models/User");

let auth = (req, res, next) => {
    let token = req.cookies.x_auth;

    // User.findByToken을 프로미스로 처리
    User.findByToken(token)
        .then((user) => {
            if (!user) return res.json({ isAuth: false, error: true });
            req.token = token;
            req.user = user;
            next();
        })
        .catch((err) => {
            console.error(err);
            return res.status(400).json({ isAuth: false, error: true });
        });
};
module.exports = { auth };

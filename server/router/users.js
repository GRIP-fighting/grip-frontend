var express = require("express");
var router = express.Router();
const { User } = require("../models/User.js"); // 모델 스키마 가져오기
const { auth } = require("../middleware/auth.js");
const { Map } = require("../models/Map.js");

// 미들웨어 체크
router.use("/", (req, res, next) => {
    console.log("users-middleware");
    next();
});

// 회원가입
router.post("/register", async (req, res) => {
    const user = new User(req.body); // body parser를 이용해서 json 형식으로 정보를 가져온다.
    user.score = 0;
    try {
        await user.save();
        res.status(200).json({ success: true });
    } catch (error) {
        res.json({ success: false, err: error });
    }
});

//로그인
router.post("/login", async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        if (!user) {
            return res.json({
                loginSuccess: false,
                message: "이메일에 해당하는 유저가 없습니다.",
            });
        }

        const isMatch = await user.comparePassword(req.body.password);
        if (!isMatch) {
            return res.json({
                loginSuccess: false,
                message: "비밀번호가 틀렸습니다.",
            });
        }

        const tokenUser = await user.generateToken();
        res.cookie("x_auth", tokenUser.token)
            .status(200)
            .json({ loginSuccess: true, userId: tokenUser._id });
    } catch (err) {
        res.status(400).send(err);
    }
});

// auth 미들웨어를 통과해야 다음으로 넘어감
router.get("/auth", auth, (req, res) => {
    // 여기까지 미들웨어를 통과해 왔다는 얘기는 Authentication이 true라는 말
    res.status(200).json({
        _id: req.user._id,
        isAdmin: req.user.role === 0 ? false : true,
        isAuth: true,
        email: req.user.email,
        name: req.user.name,
        lastname: req.user.lastname,
        role: req.user.role,
        image: req.user.image,
    });
});

router.get("/logout", auth, (req, res) => {
    console.log(req.user);
    User.findOneAndUpdate({ _id: req.user._id }, { token: "" }, (err, user) => {
        if (err) return res.json({ success: false, err });
        return res.status(200).send({ success: true });
    });
});

module.exports = router;

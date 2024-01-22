var express = require("express");
var router = express.Router();
const { auth } = require("../middleware/auth.js");
const { User } = require("../models/User.js"); // 모델 스키마 가져오기
const { Map } = require("../models/Map.js");
const { Counter } = require("../models/Counter.js");

// 회원가입
router.post("/register", async (req, res) => {
    const user = new User(req.body); // body parser를 이용해서 json 형식으로 정보를 가져온다.
    try {
        await user.save();
        res.status(200).json({ success: true });
    } catch (error) {
        res.json({ success: false, err: error });
    }
});

// 로그인
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

// 로그아웃
router.get("/logout", auth, async (req, res) => {
    try {
        const updatedUser = await User.findOneAndUpdate(
            { _id: req.user._id },
            { token: "" }
        );
        res.status(200).send({ success: true });
    } catch (err) {
        res.json({ success: false, err });
    }
});

// 유저 리스트 가져오기
router.get("/", auth, async (req, res) => {
    try {
        const users = await User.find({}).select("-password -token -__v");
        return res.status(200).json({
            success: true,
            users: users,
        });
    } catch (error) {
        res.status(500).json({ success: false, error });
    }
});

// 특정 유저 디테일 가져오기
router.get("/:userId", auth, async (req, res) => {
    try {
        const userId = req.params.userId;
        const user = await User.findDetailsByUserId(userId);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: "사용자를 찾을 수 없습니다.",
            });
        }
        res.status(200).json({
            success: true,
            likedMaps: user.likedMapId,
            solutions: user.solutionId,
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error });
    }
});

module.exports = router;

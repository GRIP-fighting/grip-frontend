const express = require("express"); // express를 가져온다.
const app = express(); // express를 이용해서 app을 만들어준다.
const port = 8000; // port 번호를 5000번으로 설정

const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const { User } = require("./models/User.js"); // 모델 스키마 가져오기
const { auth } = require("./middleware/auth.js");
require("dotenv").config();

const config = require("./config/key.js"); // config 폴더에 있는 key.js를 가져온다.
app.listen(port, () => console.log(`Example app listening on port ${port}!`));

// application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));
// application/json
app.use(bodyParser.json());
app.use(cookieParser());

const mongoose = require("mongoose");
mongoose
    .connect(config.mongoURI, {})
    .then(() => console.log("MongoDB Connected..."))
    .catch((err) => console.log(err));

// get 되는지 체크
app.get("/api/users/", (req, res) => res.send("Hello World! 안녕하세요~"));

// 회원가입
app.post("/api/users/register", async (req, res) => {
    const user = new User(req.body); // body parser를 이용해서 json 형식으로 정보를 가져온다.
    try {
        await user.save();
        res.status(200).json({ success: true });
    } catch (error) {
        res.json({ success: false, err: error });
    }
});

//로그인
app.post("/api/users/login", async (req, res) => {
    try {
        // User.findOne을 사용하여 유저를 찾습니다.
        const user = await User.findOne({ email: req.body.email });

        if (!user) {
            return res.json({
                loginSuccess: false,
                message: "이메일에 해당하는 유저가 없습니다.",
            });
        }
        // 비밀번호 비교
        const isMatch = await user.comparePassword(req.body.password);

        if (!isMatch) {
            return res.json({
                loginSuccess: false,
                message: "비밀번호가 틀렸습니다.",
            });
        }

        // 비밀번호까지 맞다면 토큰 생성
        const tokenUser = await user.generateToken();
        res.cookie("x_auth", tokenUser.token)
            .status(200)
            .json({ loginSuccess: true, userId: tokenUser._id });
    } catch (err) {
        res.status(400).send(err);
    }
});

// auth 미들웨어를 통과해야 다음으로 넘어감
app.get("/api/users/auth", auth, (req, res) => {
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

app.get("/api/users/logout", auth, (req, res) => {
    console.log(req.user);
    User.findOneAndUpdate({ _id: req.user._id }, { token: "" }, (err, user) => {
        if (err) return res.json({ success: false, err });
        return res.status(200).send({ success: true });
    });
});

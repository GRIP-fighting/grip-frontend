var express = require("express");
var router = express.Router();
const { User } = require("../models/User.js"); // 모델 스키마 가져오기
const { auth } = require("../middleware/auth.js");
const { Map } = require("../models/Map.js");

// 미들웨어 체크
router.use("/", (req, res, next) => {
    console.log("maps-middleware");
    next();
});

module.exports = router;

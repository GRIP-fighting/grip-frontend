var express = require("express");
var router = express.Router();
const { auth } = require("../middleware/auth.js");
const { User } = require("../models/User.js"); // 모델 스키마 가져오기
const { Map } = require("../models/Map.js");
const { Solution } = require("../models/Solution.js");

// 미들웨어 체크
router.use("/", (req, res, next) => {
    console.log("maps-middleware");
    next();
});

module.exports = router;

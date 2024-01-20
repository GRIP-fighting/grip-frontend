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

// 로그인한 사용자가 해결한 맵들의 정보를 가져오는 엔드포인트
router.get("/solvedmaps", auth, async (req, res) => {
    try {
        // 인증된 사용자의 ID를 사용하여 사용자 정보를 가져온다.
        const user = await User.findById(req.user._id).populate("solvedMapId");
        if (!user) {
            return res.status(404).json({
                success: false,
                message: "사용자를 찾을 수 없습니다.",
            });
        }

        // 사용자가 해결한 맵들의 정보를 가져온다.
        const solvedMaps = user.solvedMapId;
        return res.status(200).json({ success: true, solvedMaps });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ success: false, error });
    }
});

module.exports = router;

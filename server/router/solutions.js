var express = require("express");
var router = express.Router();
const { auth } = require("../middleware/auth.js");
const { User } = require("../models/User.js"); // 모델 스키마 가져오기
const { Map } = require("../models/Map.js");
const { Solution } = require("../models/Solution.js");

// solution 추가
router.post("/", auth, async (req, res) => {
    const solution = new Solution(req.body);
    const user = req.user;
    try {
        if (user) {
            user.solutionId.push(solution._id);
            await user.save();
        } else {
            return res.status(404).json({
                success: false,
                message: "사용자를 찾을 수 없습니다.",
            });
        }
        await solution.save();
        res.status(200).json({ success: true });
    } catch (error) {
        res.json({ success: false, err: error });
    }
});

// 솔루션 좋아요
router.patch("/:solutionId/liked", auth, async (req, res) => {
    const user = req.user;
    const solutionId = req.params.solutionId;

    try {
        const solution = await Solution.findOne({ solutionId: solutionId });

        if (!user || !solution) {
            return res.status(404).send("User or Map not found");
        }
        if (!user.likedSolutionId.includes(solution._id)) {
            solution.liked = solution.liked + 1;
            await solution.save();
            user.likedSolutionId.push(solution._id);
            await user.save();
        } else {
            solution.liked = solution.liked - 1;
            await solution.save();
            user.likedSolutionId.pull(solution._id);
            await user.save();
        }

        res.status(200).send({
            success: true,
            mapLikes: solution.likes,
            userLikedMaps: user.likedSolutionId,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send("An error occurred");
    }
});

module.exports = router;

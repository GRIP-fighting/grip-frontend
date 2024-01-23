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
        solution.userId = user.userId;
        await solution.save();
        res.json({ success: true });
    } catch (error) {
        res.json({ success: false, err: error });
    }
});

// solution 추가
router.get("/", auth, async (req, res) => {
    try {
        const solutions = await Solution.find({}).select("-__v");
        return res.status(200).json({
            success: true,
            solutions: solutions,
        });
    } catch (error) {
        res.status(500).json({ success: false, error });
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
        if (!user.likedSolutionId.includes(solutionId)) {
            solution.liked = solution.liked + 1;
            await solution.save();
            user.likedSolutionId.push(solutionId);
            await user.save();
        } else {
            solution.liked = solution.liked - 1;
            await solution.save();
            user.likedSolutionId.pull(solutionId);
            await user.save();
        }

        res.status(200).send({
            success: true,
            mapLikes: solution.liked,
            userLikedMaps: user.likedSolutionId,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send("An error occurred");
    }
});

// 맵 삭제 - 자기 자신만
router.delete("/:solutionId/delete", auth, async (req, res) => {
    try {
        const solutionId = req.params.solutionId;
        const solution = await Solution.findOne({ solutionId: solutionId });
        const userId = req.user.userId;
        const user = req.user;

        if (!solution) {
            return res
                .status(404)
                .json({ success: false, message: "Solution not found." });
        }

        if (solution.userId != userId) {
            return res.status(404).json({
                success: false,
                message: "No Permission",
            });
        }
        await Solution.findByIdAndDelete(solution._id);

        user.solutionId = user.solutionId.filter(
            (mySolutionId) => mySolutionId !== solutionId
        );
        await user.save();

        return res.status(200).json({
            success: true,
            message: "User has been successfully removed from the map.",
        });
    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});

module.exports = router;

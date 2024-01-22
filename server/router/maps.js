var express = require("express");
var router = express.Router();
const { auth } = require("../middleware/auth.js");
const { User } = require("../models/User.js"); // 모델 스키마 가져오기
const { Map } = require("../models/Map.js");
const { Counter } = require("../models/Counter.js");

// map 추가
router.post("/", async (req, res) => {
    const map = new Map(req.body);
    try {
        await map.save();
        res.status(200).json({ success: true });
    } catch (error) {
        res.json({ success: false, err: error });
    }
});

// 특정 맵 디테일 가져오기
router.get("/:mapId", auth, async (req, res) => {
    try {
        const mapId = req.params.mapId;
        const map = await Map.findDetailsByMapId(mapId);
        if (!map) {
            return res.status(404).json({
                success: false,
                message: "사용자를 찾을 수 없습니다.",
            });
        }
        res.status(200).json({
            success: true,
            designer: map.designer,
            solutions: map.solutions,
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error });
    }
});

// 맵 좋아요
router.patch("/:mapId/liked", auth, async (req, res) => {
    const user = req.user;
    const mapId = req.params.mapId;

    try {
        const map = await Map.findOne({ mapId: mapId });

        if (!user || !map) {
            return res.status(404).send("User or Map not found");
        }
        if (!user.likedMapId.includes(map._id)) {
            map.liked = map.liked + 1;
            await map.save();
            user.likedMapId.push(map._id);
            await user.save();
        } else {
            map.liked = map.liked - 1;
            await map.save();
            user.likedMapId.pull(map._id);
            await user.save();
        }

        res.status(200).send({
            success: true,
            mapLikes: map.liked,
            userLikedMaps: user.likedMapId,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send("An error occurred");
    }
});

// 맵 정보 수정
router.patch("/:mapId", auth, async (req, res) => {
    const mapId = req.params.mapId;
    const { mapName, designer } = req.body;
    try {
        const validDesignerIds = await User.find({
            _id: { $in: designer },
        }).select("_id");
        if (validDesignerIds.length !== designer.length) {
            return res.status(400).json({
                message: "잘못된 사용자 ObjectId가 포함되어 있습니다.",
            });
        }
        const map = await Map.findOne({ mapId: mapId });
        map.mapName = mapName;
        map.designer = designer;
        await map.save();
        res.status(200).send({
            success: true,
            map: map,
        });
    } catch (error) {
        res.status(500).send("An error occurred");
    }
});

module.exports = router;

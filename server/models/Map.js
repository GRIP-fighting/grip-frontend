const mongoose = require("mongoose"); // 몽구스를 가져온다.
const Schema = mongoose.Schema;

const mapSchema = mongoose.Schema({
    mapId: {
        type: Number,
        unique: true,
    },
    mapName: {
        type: String,
        maxlength: 50,
    },
    mapPath: {
        type: String,
    },
    level: {
        type: Number,
    },
    liked: {
        type: Number,
        default: 0,
    },
    designer: [
        {
            type: Schema.Types.ObjectId,
            ref: "Map",
        },
    ],
    solutionId: [
        {
            type: Schema.Types.ObjectId,
            ref: "Map",
        },
    ],
});

const Map = mongoose.model("Map", mapSchema); // 스키마를 모델로 감싸준다.

module.exports = { Map }; // 다른 곳에서도 사용할 수 있도록 export 해준다.

const mongoose = require("mongoose"); // 몽구스를 가져온다.
const Schema = mongoose.Schema;

const solutionSchema = mongoose.Schema({
    solutionId: {
        type: Number,
        unique: true,
    },
    userId: {
        type: Schema.Types.ObjectId,
        ref: "User",
    },
    mapId: {
        type: Schema.Types.ObjectId,
        ref: "Map",
    },
    liked: {
        type: Number,
        default: 0,
    },
    evalutedLevel: {
        type: Number,
        default: 0,
    },
    solutionPath: {
        type: String,
    },
});

const Solution = mongoose.model("Solution", solutionSchema); // 스키마를 모델로 감싸준다.

module.exports = { Solution }; // 다른 곳에서도 사용할 수 있도록 export 해준다.

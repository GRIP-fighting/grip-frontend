const mongoose = require("mongoose"); // 몽구스를 가져온다.
const Schema = mongoose.Schema;
const { Counter } = require("./Counter.js");

const solutionSchema = mongoose.Schema({
    solutionId: {
        type: Number,
        unique: true,
    },
    userId: {
        type: Number, // 또는 Integer로 변경
    },
    mapId: {
        type: Number, // 또는 Integer로 변경
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

solutionSchema.pre("save", async function (next) {
    const solution = this;
    try {
        if (this.isNew) {
            const counter = await Counter.findByIdAndUpdate(
                { _id: "solutionId" },
                { $inc: { seq: 1 } },
                { new: true, upsert: true }
            );
            solution.solutionId = counter.seq;
        }
        next();
    } catch (error) {
        next(error);
    }
});

const Solution = mongoose.model("Solution", solutionSchema); // 스키마를 모델로 감싸준다.

module.exports = { Solution }; // 다른 곳에서도 사용할 수 있도록 export 해준다.

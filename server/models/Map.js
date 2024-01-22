const mongoose = require("mongoose"); // 몽구스를 가져온다.
const Schema = mongoose.Schema;
const { Counter } = require("./Counter.js");

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
        default: 0,
    },
    liked: {
        type: Number,
        default: 0,
    },
    designer: [
        {
            type: Number, // 또는 Integer로 변경
        },
    ],
    solutionId: [
        {
            type: Number, // 또는 Integer로 변경
        },
    ],
});

mapSchema.pre("save", async function (next) {
    const map = this;
    try {
        if (this.isNew) {
            const counter = await Counter.findByIdAndUpdate(
                { _id: "mapId" },
                { $inc: { seq: 1 } },
                { new: true, upsert: true }
            );
            map.mapId = counter.seq;
        }
        next();
    } catch (error) {
        next(error);
    }
});

mapSchema.statics.findDetailsByMapId = async function (mapId) {
    try {
        const user = await this.findOne({ mapId: mapId });
        // .populate({
        //     path: "designer",
        //     select: "-password -token -__v",
        // })
        // .populate("solutionId");
        return user;
    } catch (error) {
        throw error;
    }
};

const Map = mongoose.model("Map", mapSchema);

module.exports = { Map };

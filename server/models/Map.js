const mongoose = require("mongoose"); // 몽구스를 가져온다.
const bcrypt = require("bcrypt"); // 비밀번호를 암호화 시키기 위해
const saltRounds = 10; // salt를 몇 글자로 할지
const jwt = require("jsonwebtoken"); // 토큰을 생성하기 위해

const mapSchema = mongoose.Schema({
    mapName: {
        type: String,
        maxlength: 50,
    },
    level: {
        type: Number,
    },
    imagePath: {
        type: String,
    },
});

const Map = mongoose.model("Map", mapSchema); // 스키마를 모델로 감싸준다.

module.exports = { Map }; // 다른 곳에서도 사용할 수 있도록 export 해준다.

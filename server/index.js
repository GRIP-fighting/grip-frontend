const express = require("express"); // express를 가져온다.
const app = express(); // express를 이용해서 app을 만들어준다.
var usersRouter = require("./router/users.js");
var mapsRouter = require("./router/maps.js");

const port = 8000; // port 번호를 5000번으로 설정
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
require("dotenv").config();

const config = require("./config/key.js"); // config 폴더에 있는 key.js를 가져온다.
app.listen(port, () => console.log(`Example app listening on port ${port}!`));

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());

const mongoose = require("mongoose");
mongoose
    .connect(config.mongoURI, {})
    .then(() => console.log("MongoDB Connected..."))
    .catch((err) => console.log(err));
mongoose.set("debug", true);
app.use("/api/users", usersRouter);
app.use("/api/maps", mapsRouter);

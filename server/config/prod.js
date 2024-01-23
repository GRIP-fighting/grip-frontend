// 개발환경이 아닌 실제 배포환경
module.exports = {
    mongoURI: process.env.MONGO_URI,
    ID: process.env.ID,
    SECRET: process.env.SECRET,
    BUCKET_NAME: process.env.BUCKET_NAME,
};

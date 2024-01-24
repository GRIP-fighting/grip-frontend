const multer = require("multer");
const multerS3 = require("multer-s3");
const s3 = require("../config/s3.js");
const config = require("./key.js"); // config 폴더에 있는 key.js를 가져온다.
const { S3Client, GetObjectCommand } = require("@aws-sdk/client-s3");

const uploadImage = multer({
    storage: multerS3({
        s3: s3,
        bucket: config.BUCKET_NAME,
        contentType: multerS3.AUTO_CONTENT_TYPE,
        key: function (req, file, callback) {
            callback(null, `${Date.now()}_${file.originalname}`);
        },
    }),
    limits: { fileSize: 1 * 1024 * 1024 },
});

const getImage = async (imageName) => {
    const params = {
        Bucket: config.BUCKET_NAME, // Bucket 이름을 지정
        Key: imageName, // 파일의 Key (파일 이름)
    };
    try {
        // GetObjectCommand를 사용하여 객체를 가져옵니다.
        const command = new GetObjectCommand(params);
        const data = await s3.send(command);
        return data.Body;
    } catch (error) {
        console.log("Error in getImage:", error);
        throw error;
    }
};

module.exports = { uploadImage, getImage };

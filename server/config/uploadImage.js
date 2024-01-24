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
            const userId = req.user.userId;
            callback(null, `profile_${userId}`);
        },
    }),
});

const getImage = async (imageName) => {
    const params = {
        Bucket: config.BUCKET_NAME,
        Key: imageName,
    };
    try {
        const command = new GetObjectCommand(params);
        const data = await s3.send(command);
        return data.Body;
    } catch (error) {
        console.log("Error in getImage:", error);
        throw error;
    }
};

module.exports = { uploadImage, getImage };

import dotenv from "dotenv";

import multer from "multer";
import multerS3 from "multer-s3";

import s3 from "../config/s3.js";

dotenv.config();

const uploadImage = multer({
    storage: multerS3({
        s3,
        bucket: process.env.S3_BUCKET_NAME,
        contentType: multerS3.AUTO_CONTENT_TYPE,
        key: function (req, file, cb) {
            cb(null, `${Date.now()}_${file.originalname}`);
        },
    }),
    limits: { fileSize: 1 * 1024 * 1024 },
});

export default uploadImage;

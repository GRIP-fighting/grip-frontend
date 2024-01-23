const config = require("../config/key.js"); // config 폴더에 있는 key.js를 가져온다.

const {
    S3Client,
    HeadBucketCommand,
    CreateBucketCommand,
    PutObjectCommand,
} = require("@aws-sdk/client-s3");

const s3Client = new S3Client({
    region: "ap-northeast-2",
    credentials: {
        accessKeyId: config.ID,
        secretAccessKey: config.SECRET,
    },
});

// const headBucket = async () => {
//     try {
//         const data = await s3Client.send(new HeadBucketCommand(bucketParams));
//         console.log("Bucket exists and is accessible", data);
//     } catch (err) {
//         if (err.name === "NotFound") {
//             // 버킷이 존재하지 않으므로 생성
//             try {
//                 const createParams = {
//                     Bucket: BUCKET_NAME,
//                     CreateBucketConfiguration: {
//                         LocationConstraint: "ap-northeast-2",
//                     },
//                 };
//                 const data = await s3Client.send(
//                     new CreateBucketCommand(createParams)
//                 );
//                 console.log("Bucket Created Successfully", data.Location);
//             } catch (err) {
//                 console.log("Error in createBucket", err, err.stack); // createBucket 에러 로깅
//             }
//         } else {
//             console.log("Error in headBucket", err, err.stack); // headBucket 에러 로깅
//         }
//     }
// };
// headBucket();

const fs = require("fs");
const uploadFile = async (fileName) => {
    try {
        // Read content from the file
        const fileContent = fs.readFileSync(fileName);

        // Setting up S3 upload parameters
        const params = {
            Bucket: BUCKET_NAME,
            Key: "child.jpg", // File name you want to save as in S3
            Body: fileContent,
        };

        // Uploading files to the bucket
        const data = await s3Client.send(new PutObjectCommand(params));
        console.log(`File uploaded successfully. ${data.Location}`);
    } catch (err) {
        console.error("Error in uploadFile", err);
        throw err;
    }
};
uploadFile("../child.jpeg");

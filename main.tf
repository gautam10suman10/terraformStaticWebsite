provider "aws" {

  region = "us-west-1"
}
module "s3-web-hosting" {
  source         = "./s3Module"
  bucket_name    = "bucketName"
  folderLocation = "inYourDevice"
  zoneId         = "ZoneID"
  certificateArn = "certicatearn"
  error          = ["400", "403", "500"]
}
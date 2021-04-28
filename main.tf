provider "aws" {

  region = "us-west-1"
}
module "s3-web-hosting" {
  source         = "./s3Module"
  bucket_name    = "terraform-bucket-fm"
  folderLocation = "/home/gautam10/Desktop/POHTML/"
  zoneId         = "Z03427593K0DD0VDHTESG"
  certificateArn = "arn:aws:acm:us-east-1:549847039622:certificate/29a1d027-e055-4ebf-9ae6-d4ca3f4aadf9"
  # for_each       = toset(["400", "403", "500"])
  error          = ["400", "403", "500"]
}
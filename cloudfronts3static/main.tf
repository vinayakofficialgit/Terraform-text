
##### Create bucket
resource "aws_s3_bucket" "cloudbucket" {
  bucket = var.bucket_name


  tags = {
    Environment = "${var.env}"
  }
}

############
resource "aws_s3_bucket_website_configuration" "vblog" {
  bucket = aws_s3_bucket.cloudbucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}



## Assign policy to allow CloudFront to reach S3 bucket
resource "aws_s3_bucket_policy" "origin" {
  depends_on = [
    aws_cloudfront_distribution.clouddistribution
  ]
  bucket = aws_s3_bucket.cloudbucket.bucket
  policy = data.aws_iam_policy_document.origin.json
}

## Create policy to allow CloudFront to reach S3 bucket
data "aws_iam_policy_document" "origin" {
  depends_on = [
    aws_cloudfront_distribution.clouddistribution,
    aws_s3_bucket.cloudbucket
  ]

  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.cloudbucket.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.clouddistribution.arn
      ]
    }
  }
}

## Enable AWS S3 file versioning
resource "aws_s3_bucket_versioning" "Site_Origin" {
  bucket =  aws_s3_bucket.cloudbucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

## Upload file to S3 bucket
resource "aws_s3_object" "content" {
  depends_on = [
    aws_s3_bucket.cloudbucket
  ]
  bucket                 =  aws_s3_bucket.cloudbucket.bucket
  key                    = "index.html"                              #########if you give /demo/index.html then  you give on browser --> cloudfronturl/demo/index.html
  source                 = "./index.html"                            ######### location of your root dir or index file
  server_side_encryption = "AES256"

  content_type = "text/html"
}

## Create CloudFront distrutnion group
resource "aws_cloudfront_distribution" "clouddistribution" {
  
  depends_on = [
     aws_s3_bucket.cloudbucket,
    aws_cloudfront_origin_access_control.Site_Access
  ]

  origin {
    
    domain_name              =  aws_s3_bucket.cloudbucket.bucket_regional_domain_name
    origin_id                =  aws_s3_bucket.cloudbucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.Site_Access.id
  }

  enabled             = true
  default_root_object = "index.html"

 #restrictions {
 #  geo_restriction {
 #    restriction_type = "whitelist"
 #     locations        = ["US", "CA","IN"]
 #  }
    
 # }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }



  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.cloudbucket.id
    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


## Create Origin Access Control as this is required to allow access to the s3 bucket without public access to the S3 bucket.
resource "aws_cloudfront_origin_access_control" "Site_Access" {
  name                              = "myorigibsetting"
  description                       = "it allow CF to fetch data privately from origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}







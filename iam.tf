data "aws_iam_policy_document" "policy_document" {
  statement {
    effect = "Allow"
    sid = "BucketPermission"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObjectMetaData",
      "s3:GetObject",
      "s3:GetBucketACL",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::${var.backup_restore_bucket}",
      "arn:aws:s3:::${var.backup_restore_bucket}/*",
    ]
  }
  statement {
    effect = "Allow"
    sid = "ListBuckets"
    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*"
    ]
  }
}

resource "aws_iam_policy" "rds_to_s3_policy" {
  name    = local.rds_s3_policy
  policy  = data.aws_iam_policy_document.policy_document.json
}

data "aws_iam_policy_document" "rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_role" {
  name               = local.rds_s3_role
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role.json
}

resource "aws_iam_role_policy_attachment" "rds-role-attach" {
  role        = aws_iam_role.rds_role.id
  policy_arn  = aws_iam_policy.rds_to_s3_policy.arn
}

# IAM Role Definition for RDS Enhanced Monitoring
data "aws_iam_policy_document" "rds_assume_role_monitor" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# Create RDS Enhanced Monitoring role
resource "aws_iam_role" "rds_role_monitoring" {
  name               = local.monitor_role
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role_monitor.json
}

# Attach RDS Enhanced Monitoring role policy(ies)
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
    role       = aws_iam_role.rds_role_monitoring.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
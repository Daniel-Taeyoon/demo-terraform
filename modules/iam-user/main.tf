resource "aws_iam_user" "this" {
  name = var.name
  force_destroy        = var.force_destroy
}

resource "aws_iam_access_key" "example_user_key" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_login_profile" "example" {
  user = aws_iam_user.this.name
  password_reset_required = true
  password_length = 12
}

resource "aws_iam_user_policy_attachment" "attach_S3Policy" {
  user       = aws_iam_user.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "attach_IAMUserChangePwd" {
  user       = aws_iam_user.this.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

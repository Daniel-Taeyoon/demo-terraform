
resource "aws_iam_user" "Add-Users" {
  count = length(var.users)
  name = "tf-iam-user-${count.index + 1}"
}

resource "aws_iam_user" "user" {
  name = "iam-${var.account_name}"
}

resource "aws_iam_group" "group" {
  name = "iam-${var.account_name}"
}

resource "aws_iam_group_policy_attachment" "ec2_full_access" {
  group      = aws_iam_group.group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_membership" "membership" {
  name  = "iam-${var.account_name}-membership"
  group = aws_iam_group.group.name

  users = [
    aws_iam_user.user.name
  ]
}

resource "aws_iam_user" "lb2" {
  name = "hello"
}

resource "aws_iam_user" "lb1" {
  name = "hello1"
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.lb2.name, # == hello
    aws_iam_user.lb1.name, # == helo1
  ]

  group = aws_iam_group.developers.name # == developers
}

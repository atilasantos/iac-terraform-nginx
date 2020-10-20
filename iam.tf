provider "aws" {
    region = "us-east-2"
}


data "aws_iam_policy_document" "nginx-doc-policy" {
  statement {
    sid = "1"

    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "nginx-iam_role" {
  name               = "nginx-iam_role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.nginx-doc-policy.json}"
}

resource "aws_iam_group_policy" "nginx-group-policy" {
  name  = "my_developer_policy"
  group = "${aws_iam_group.nginx-iam-group.name}"
  policy = "${data.aws_iam_policy_document.nginx-doc-policy.json}"
}

resource "aws_iam_group" "nginx-iam-group" {
  name = "nginx-iam-group"
  path = "/"
}


resource "aws_iam_user" "nginx-user" {
  name = "nginx-user"
  path = "/"
}

resource "aws_iam_user_group_membership" "nginx-membership" {
  user = "${aws_iam_user.nginx-user.name}"

  groups = ["${aws_iam_group.nginx-iam-group.name}"]
}


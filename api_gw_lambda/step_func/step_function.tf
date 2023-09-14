terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket = "bibi-s3-v4"
    key    = "ftstate/backup"
    region = "eu-west-1"
  }
}

provider "aws" {
  profile = "default"
  region = "eu-west-1"
}



# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunctionSampleStepFunctionExecutionIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "policy_publish_sns" {
  name        = "stepFunctionSampleSNSInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "sns:Publish",
              "sns:SetSMSAttributes",
              "sns:GetSMSAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "policy_invoke_lambda" {
  name        = "stepFunctionSampleLambdaFunctionInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = "${aws_iam_role.iam_for_sfn.name}"
  policy_arn = "${aws_iam_policy.policy_invoke_lambda.arn}"
}

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_sns" {
  role       = "${aws_iam_role.iam_for_sfn.name}"
  policy_arn = "${aws_iam_policy.policy_publish_sns.arn}"
}



// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "sample-state-machine"
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"

  definition = <<EOF

{
  "StartAt": "get items from db",
  "States": {

    "get items from db": {
    "Comment": "get items from DB.",
    "Type": "Task",
    "InputPath": "$",
    "ResultPath": null,
    "Resource": "arn:aws:states:::lambda:invoke",
    "Parameters": {
    "FunctionName": "aws_lambda_function.apigw_lambda_ddb_get.arn",
    "Payload.$": "$"
    },
    "Next": "delete item"
    },

    "delete item": {
    "Comment": "delete item from DB",
    "Type": "Task",
    "InputPath": "$",
    "ResultPath": null,
    "Resource": "aws_lambda_function.apigw_lambda_ddb_get.arn",
    "Parameters": {
    "FunctionName": "",
    "Payload.$": "$"
    },
    "End": true
    }



  }
}
EOF

  //depends_on = [aws_lambda_function.apigw_lambda_ddb, aws_lambda_function.apigw_lambda_ddb_get, aws_lambda_function.apigw_lambda_ddb_delete, aws_lambda_function.apigw_lambda_sqs_dequeue]

}




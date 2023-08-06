# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import boto3
import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
  my_table = os.environ.get('DDB_TABLE')
  logging.info(f"## Loaded table name from environemt variable DDB_TABLE: {my_table}")
  # Determine the HTTP method of the request
  http_method = event["httpMethod"]
  if http_method == "GET":
      # Return the data in the response
      table = dynamodb.Table(my_table)
      response = table.scan()
      logging.info(f"Items: {response['Items']}")
      return {
          "statusCode": 200,
          "headers": {
              "Content-Type": "application/json"
          },
          "body": json.dumps({"message": str(response['Items'])})
      }
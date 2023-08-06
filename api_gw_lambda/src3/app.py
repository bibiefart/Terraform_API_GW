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
  if http_method == "DELETE":
      # Return the data in the response
      table = dynamodb.Table(my_table)
      if event["body"]:
          logging.info(f"event --> {event}")
          item = json.loads(event["body"])
          logging.info(f"## Received payload: {item}")
          year = str(item["year"])
          title = str(item["title"])
          logging.info(f"item to delete --> {item}")
          response = table.delete_item(Key=item)

      status_code = response['ResponseMetadata']['HTTPStatusCode']
      print(status_code)
      logging.info(f"delete response: {response}")
      return {
          "statusCode": status_code,
          "headers": {
              "Content-Type": "application/json"
          },
          "body": json.dumps({"message": response})

      }

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
  logging.info(f"the event: {event}")
  # Determine the HTTP method of the request
  try:
      http_method = event["httpMethod"]
  except:
      http_method = None
  if http_method == "DELETE" or http_method == None:
      # Return the data in the response
      table = dynamodb.Table(my_table)
      try:
          if event["body"]:
              logging.info(f"event --> {event}")
              item = json.loads(event["body"])
              logging.info(f"## Received payload: {item}")
              year = str(item["year"])
              title = str(item["title"])
              logging.info(f"item to delete --> {item}")
              response = table.delete_item(Key=item)
      except:
          logging.info(f"event --> {event}")
          item = json.loads(event['Payload']['body'])
          item = item["message"]
          year = item[item.find("('") + 2:item.rfind("')")]
          title = item[item.find("'title': ")+10:item.rfind("'}'")-2]
          item = json.dumps({'year': int(year), 'title': title})
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

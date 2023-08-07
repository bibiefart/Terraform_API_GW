# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import boto3
import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb_client = boto3.client('dynamodb')



def get_queue_url(queue_name):
    """Get the URL of the SQS queue to send events to."""
    region = os.environ.get('REGION')
    client = boto3.client("sqs", region)
    queue = client.get_queue_url(QueueName=queue_name)
    return queue["QueueUrl"]


def sqs_send_message(body):
    queue_name = os.environ.get('SQS_NAME')
    sqs = boto3.client('sqs')


    queue_url = get_queue_url(queue_name)
    # Send message to SQS queue
    response = sqs.send_message(
        QueueUrl=queue_url,
        DelaySeconds=10,
        MessageAttributes={
            'Title': {
                'DataType': 'String',
                'StringValue': 'The Whistler'
            },
            'Author': {
                'DataType': 'String',
                'StringValue': 'John Grisham'
            },
            'WeeksOn': {
                'DataType': 'Number',
                'StringValue': '6'
            }
        },
        MessageBody=(f"{body}")
    )

    logging.info(f"SQS message ID: --->>>> {response['MessageId']}")


def lambda_handler(event, context):
  table = os.environ.get('DDB_TABLE')
  logging.info(f"## Loaded table name from environemt variable DDB_TABLE: {table}")
  if event["body"]:
      item = json.loads(event["body"])
      logging.info(f"## Received payload: {item}")
      year = str(item["year"])
      title = str(item["title"])
      dynamodb_client.put_item(TableName=table,Item={"year": {'N':year}, "title": {'S':title}})
      sqs_send_message(item)
      message = "Successfully inserted data!"
      return {
          "statusCode": 200,
          "headers": {
              "Content-Type": "application/json"
          },
          "body": json.dumps({"message": message})
      }
  else:
      logging.info("## Received request without a payload")
      dynamodb_client.put_item(TableName=table,Item={"year": {'N':'2012'}, "title": {'S':'The Amazing Spider-Man 2'}})
      message = "Successfully inserted data!"
      return {
          "statusCode": 200,
          "headers": {
              "Content-Type": "application/json"
          },
          "body": json.dumps({"message": message})
      }
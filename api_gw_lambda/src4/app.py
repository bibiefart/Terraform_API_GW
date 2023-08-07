# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
from datetime import datetime
import boto3
import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_queue_url(queue_name):
    """Get the URL of the SQS queue to send events to."""
    region = os.environ.get('REGION')
    client = boto3.client("sqs", region)
    queue = client.get_queue_url(QueueName=queue_name)
    return queue["QueueUrl"]

def sqs_get_message():
    queue_name = os.environ.get('SQS_NAME')
    sqs = boto3.client('sqs')
    queue_url = get_queue_url(queue_name)
    # Receive message from SQS queue
    response = sqs.receive_message(
        QueueUrl=queue_url,
        AttributeNames=[
            'SentTimestamp'
        ],
        MaxNumberOfMessages=1,
        MessageAttributeNames=[
            'All'
        ],
        VisibilityTimeout=0,
        WaitTimeSeconds=0
    )

    message = response['Messages'][0]
    receipt_handle = message['ReceiptHandle']

    # Delete received message from queue
    sqs.delete_message(
        QueueUrl=queue_url,
        ReceiptHandle=receipt_handle
    )
    logging.info('Received and deleted message: %s' % message)

def lambda_handler(event, context):
  logging.info(f"## LAMBDA RECEIVED MSG FROM SQS")
  sqs_get_message()
  now = datetime.now()
  date_time = now.strftime('%m/%d/%Y, %H:%M:%S:%p')

  return {
      'statusCode': 200,
      'body': json.dumps(date_time)
  }
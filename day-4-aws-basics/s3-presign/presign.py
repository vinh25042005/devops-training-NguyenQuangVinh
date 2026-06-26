#!/usr/bin/env python3
import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "private-presigned-13572"
OBJECT_KEY = "private.pdf"
EXPIRES_IN = 300 

def generate_presigned_url(bucket, key, expires_in):
    s3_client = boto3.client('s3')
    
    try:
        url = s3_client.generate_presigned_url(
            'get_object',
            Params={
                'Bucket': bucket,
                'Key': key
            },
            ExpiresIn=expires_in
        )
        return url
    except ClientError as e:
        print(f"Error: {e}")
        return None


if __name__ == "__main__":
    url = generate_presigned_url(BUCKET_NAME, OBJECT_KEY, EXPIRES_IN)
    
    if url:
        print(f"Presigned URL (expires in {EXPIRES_IN}s):")
        print(url)
    else:
        print("Failed to generate presigned URL.")
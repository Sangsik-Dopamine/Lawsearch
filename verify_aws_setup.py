#!/usr/bin/env python3
"""
AWS Setup Verification Script
Run this script after completing AWS setup to verify everything is configured correctly.
"""

import boto3
import sys
from botocore.exceptions import ClientError, NoCredentialsError

def print_status(message, status):
    """Print colored status message"""
    colors = {
        'success': '\033[92m✓\033[0m',
        'fail': '\033[91m✗\033[0m',
        'warning': '\033[93m⚠\033[0m',
        'info': '\033[94mℹ\033[0m'
    }
    print(f"{colors.get(status, '•')} {message}")

def check_credentials():
    """Check if AWS credentials are configured"""
    print("\n1. Checking AWS Credentials...")
    try:
        session = boto3.Session()
        credentials = session.get_credentials()
        if credentials:
            print_status("AWS credentials found", "success")
            print(f"   Access Key ID: {credentials.access_key[:10]}...")
            return True
        else:
            print_status("No AWS credentials found", "fail")
            print("   Run: aws configure")
            return False
    except Exception as e:
        print_status(f"Error checking credentials: {str(e)}", "fail")
        return False

def check_bedrock():
    """Check Bedrock access and model availability"""
    print("\n2. Checking AWS Bedrock Access...")
    try:
        bedrock = boto3.client('bedrock', region_name='us-east-1')

        # List available models
        response = bedrock.list_foundation_models()
        models = response.get('modelSummaries', [])

        # Check for Nova Pro
        nova_pro = [m for m in models if 'nova-pro' in m['modelId']]
        titan_embed = [m for m in models if 'titan-embed' in m['modelId']]

        if nova_pro:
            print_status("Bedrock API access successful", "success")
            print_status(f"Nova Pro model found: {nova_pro[0]['modelId']}", "success")
        else:
            print_status("Nova Pro model not found or access not granted", "fail")
            print("   Enable model access in Bedrock console")
            return False

        if titan_embed:
            print_status(f"Titan Embeddings model found: {titan_embed[0]['modelId']}", "success")
        else:
            print_status("Titan Embeddings not found", "warning")

        return True

    except ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == 'AccessDeniedException':
            print_status("Access denied to Bedrock", "fail")
            print("   Check IAM permissions")
        else:
            print_status(f"Bedrock error: {error_code}", "fail")
        return False
    except Exception as e:
        print_status(f"Error: {str(e)}", "fail")
        return False

def check_s3(bucket_name=None):
    """Check S3 access"""
    print("\n3. Checking S3 Access...")
    try:
        s3 = boto3.client('s3', region_name='us-east-1')

        if bucket_name:
            # Check specific bucket
            try:
                s3.head_bucket(Bucket=bucket_name)
                print_status(f"Bucket '{bucket_name}' accessible", "success")

                # Check if we can list objects
                s3.list_objects_v2(Bucket=bucket_name, MaxKeys=1)
                print_status("Can read bucket contents", "success")
                return True
            except ClientError as e:
                error_code = e.response['Error']['Code']
                if error_code == '404':
                    print_status(f"Bucket '{bucket_name}' not found", "fail")
                elif error_code == '403':
                    print_status(f"Access denied to bucket '{bucket_name}'", "fail")
                else:
                    print_status(f"S3 error: {error_code}", "fail")
                return False
        else:
            # Just check if we can list buckets
            response = s3.list_buckets()
            buckets = response.get('Buckets', [])
            print_status(f"S3 access successful ({len(buckets)} buckets found)", "success")

            # Look for lawsearch buckets
            lawsearch_buckets = [b['Name'] for b in buckets if 'lawsearch' in b['Name'].lower()]
            if lawsearch_buckets:
                print_status(f"Found project buckets: {', '.join(lawsearch_buckets)}", "info")
            else:
                print_status("No 'lawsearch' buckets found", "warning")
                print("   Create bucket: aws s3 mb s3://lawsearch-pdf-storage-YOUR-ID")
            return True

    except Exception as e:
        print_status(f"Error: {str(e)}", "fail")
        return False

def check_opensearch(endpoint=None):
    """Check OpenSearch access"""
    print("\n4. Checking OpenSearch Access...")
    try:
        opensearch = boto3.client('opensearch', region_name='us-east-1')

        if endpoint:
            # Extract domain name from endpoint
            domain_name = endpoint.split('//')[1].split('.')[0] if '//' in endpoint else None
            if domain_name:
                try:
                    response = opensearch.describe_domain(DomainName=domain_name)
                    domain = response['DomainStatus']
                    print_status(f"OpenSearch domain '{domain_name}' found", "success")
                    print(f"   Endpoint: {domain['Endpoint']}")
                    print(f"   Status: {domain['Processing']}")
                    return True
                except ClientError:
                    print_status(f"Domain '{domain_name}' not found", "fail")
                    return False
        else:
            # List all domains
            response = opensearch.list_domain_names()
            domains = response.get('DomainNames', [])

            if domains:
                print_status(f"OpenSearch access successful ({len(domains)} domains found)", "success")
                for domain in domains:
                    print(f"   - {domain['DomainName']}")
                return True
            else:
                print_status("No OpenSearch domains found", "warning")
                print("   Create domain in OpenSearch console")
                return False

    except Exception as e:
        print_status(f"Error: {str(e)}", "fail")
        return False

def test_bedrock_inference():
    """Test actual Bedrock inference"""
    print("\n5. Testing Bedrock Inference...")
    try:
        bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-east-1')

        import json

        # Try Nova Pro
        request_body = {
            "messages": [
                {
                    "role": "user",
                    "content": [{"text": "Say 'Hello' in one word."}]
                }
            ],
            "inferenceConfig": {
                "max_new_tokens": 10,
                "temperature": 0.7
            }
        }

        response = bedrock_runtime.invoke_model(
            modelId='amazon.nova-pro-v1:0',
            body=json.dumps(request_body)
        )

        response_body = json.loads(response['body'].read())
        output = response_body.get('output', {}).get('message', {}).get('content', [{}])[0].get('text', '')

        print_status("Nova Pro inference successful", "success")
        print(f"   Response: {output.strip()}")
        return True

    except ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == 'AccessDeniedException':
            print_status("Model access denied", "fail")
            print("   Enable Nova Pro in Bedrock console")
        else:
            print_status(f"Inference error: {error_code}", "fail")
        return False
    except Exception as e:
        print_status(f"Error: {str(e)}", "fail")
        return False

def main():
    """Run all verification checks"""
    print("=" * 60)
    print("AWS Setup Verification for Lawsearch Chatbot")
    print("=" * 60)

    checks = []

    # Run checks
    checks.append(("Credentials", check_credentials()))
    checks.append(("Bedrock", check_bedrock()))
    checks.append(("S3", check_s3()))
    checks.append(("OpenSearch", check_opensearch()))
    checks.append(("Bedrock Inference", test_bedrock_inference()))

    # Summary
    print("\n" + "=" * 60)
    print("Verification Summary")
    print("=" * 60)

    passed = sum(1 for _, status in checks if status)
    total = len(checks)

    for name, status in checks:
        print_status(f"{name}: {'PASSED' if status else 'FAILED'}", "success" if status else "fail")

    print(f"\n{passed}/{total} checks passed")

    if passed == total:
        print_status("\n🎉 All checks passed! You're ready to start development.", "success")
        return 0
    else:
        print_status(f"\n⚠️  {total - passed} check(s) failed. Please review the AWS setup guide.", "warning")
        return 1

if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n\nVerification cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"\n\nUnexpected error: {str(e)}")
        sys.exit(1)

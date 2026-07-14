#!/usr/bin/env bash
# Run this ONCE per environment before the first `terragrunt apply`.
# It creates the S3 bucket and DynamoDB table that Terragrunt uses to store state.
#
# Usage:
#   ./scripts/bootstrap-state-backend.sh staging us-east-1 pryata-staging-tf
#   ./scripts/bootstrap-state-backend.sh prod    us-east-1 pryata-prod-tf

set -euo pipefail

ENV="${1:?Usage: $0 <env> <region> <aws-profile>}"
REGION="${2:?Usage: $0 <env> <region> <aws-profile>}"
PROFILE="${3:?Usage: $0 <env> <region> <aws-profile>}"

BUCKET="pryata-terraform-state-${ENV}"
TABLE="pryata-terraform-locks-${ENV}"

echo "==> Creating S3 state bucket: ${BUCKET}"
if [ "${REGION}" = "us-east-1" ]; then
  # us-east-1 does not accept a LocationConstraint
  aws s3api create-bucket \
    --bucket "${BUCKET}" \
    --region "${REGION}" \
    --profile "${PROFILE}"
else
  aws s3api create-bucket \
    --bucket "${BUCKET}" \
    --region "${REGION}" \
    --create-bucket-configuration LocationConstraint="${REGION}" \
    --profile "${PROFILE}"
fi

echo "==> Enabling versioning on ${BUCKET}"
aws s3api put-bucket-versioning \
  --bucket "${BUCKET}" \
  --versioning-configuration Status=Enabled \
  --profile "${PROFILE}"

echo "==> Enabling server-side encryption on ${BUCKET}"
aws s3api put-bucket-encryption \
  --bucket "${BUCKET}" \
  --server-side-encryption-configuration '{
    "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
  }' \
  --profile "${PROFILE}"

echo "==> Blocking public access on ${BUCKET}"
aws s3api put-public-access-block \
  --bucket "${BUCKET}" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" \
  --profile "${PROFILE}"

echo "==> Creating DynamoDB lock table: ${TABLE}"
aws dynamodb create-table \
  --table-name "${TABLE}" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${REGION}" \
  --profile "${PROFILE}"

echo ""
echo "Bootstrap complete for environment: ${ENV}"
echo "  S3 bucket:      ${BUCKET}"
echo "  DynamoDB table: ${TABLE}"
echo ""
echo "Next steps:"
echo "  1. Update infrastructure-live/${ENV}/account.hcl with your account ID"
echo "  2. cd infrastructure-live/${ENV}/us-east-1/shared_infra/vpc && terragrunt apply"
echo "  3. Request an ACM certificate, then update the service terragrunt.hcl"
echo "  4. cd infrastructure-live/${ENV}/us-east-1/services/sample-api && terragrunt apply"

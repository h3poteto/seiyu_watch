#!/bin/bash

export AWS_DEFAULT_REGION=ap-northeast-1
export DB_HOST=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.db_host --region $AWS_DEFAULT_REGION`
export DB_USER=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.db_user --region $AWS_DEFAULT_REGION`
export DB_PASSWORD=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.db_password --region $AWS_DEFAULT_REGION`
export SECRET_KEY_BASE=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.secret_key_base --region $AWS_DEFAULT_REGION`
export S3_BUCKET=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.s3_bucket --region $AWS_DEFAULT_REGION`
export GOOGLE_API_KEY=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.google_api_key --region $AWS_DEFAULT_REGION`
export GOOGLE_CUSTOM_SEARCH_ID=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.google_custom_search_id --region $AWS_DEFAULT_REGION`
export SLACK_WEBHOOK_URL=`myaws ssm parameter get seiyu_watch.$SERVICE_ENV.slack_webhook_url --region $AWS_DEFAULT_REGION`
export RELX_REPLACE_OS_VARS=true

exec "$@"

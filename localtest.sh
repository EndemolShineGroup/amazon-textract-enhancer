#!/usr/local/bin/bash
export timestamp=`(date +%s)`
export codefilename=$timestamp-textract-lambda-code.zip
cd functions && zip -r textract-lambda-code.zip * && cd ../
aws s3 --profile textract cp functions/textract-lambda-code.zip s3://esg-textract-code/$codefilename
rm functions/textract-lambda-code.zip
aws cloudformation deploy --profile textract --region us-east-1 --template-file ./templates/textract-api-stack.json --stack-name Textract-Enhancer-Stack --s3-bucket esg-textract-cfn-templates --capabilities CAPABILITY_NAMED_IAM --parameter-overrides "DocumentBucketName=esg-scanned-documents" --parameter-overrides "LambdaCodeFile=$codefilename"

curl -i -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <TOKEN_VALUE>" \
    -H "Accept: application/json" \
    -H "User-Agent: myApplicationName/1.0" \
    -d "@request-body.json" \
    "https://<ORGNAME-ACCOUNTNAME>.snowflakecomputing.com/api/v2/statements"
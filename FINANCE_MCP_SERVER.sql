CREATE OR REPLACE MCP SERVER COPILOT_DB.STATS.FINANCE_MCP_SERVER
FROM SPECIFICATION $$
tools:
  - name: "invoice_search"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    identifier: "COPILOT_DB.STATS.INVOICE_SEARCH_SERVICE"
    description: "A tool that performs keyword and vector search over invoices."
    title: "Invoice Search Service"
  - name: "add_invoice"
    type: "GENERIC"
    identifier: "COPILOT_DB.STATS.ADD_INVOICE"
    description: "Adds a new invoice to the table"
    title: "Add Invoice"
    config:
      type: "procedure"
      warehouse: "COMPUTE_WH"
      input_schema:
        type: "object"
        properties:
          invoice_name:
            description: "Invoice file name"
            type: "string"
          invoice_content:
            description: "Invoice content"
            type: "string"
$$

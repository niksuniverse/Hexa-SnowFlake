-- 1. Create storage integration
CREATE STORAGE INTEGRATION ittechgenie_azure_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID = '7540734b-e567-46c3-9ad3-ec9fb9e50140'
  STORAGE_ALLOWED_LOCATIONS = ('azure://ittechgeniestore.blob.core.windows.net/sales-data');

-- 2. Describe to get the AZURE_CONSENT_URL (copy/paste the URL and follow the instructions in your browser)
DESC INTEGRATION ittechgenie_azure_integration;

CREATE DATABASE ITTECHGENIE_DB;
USE DATABASE ITTECHGENIE_DB;
USE SCHEMA PUBLIC;

-- 3. After granting consent in Azure, create an external stage
CREATE OR REPLACE STAGE sales_stage_azure
  URL = 'azure://ittechgeniestore.blob.core.windows.net/sales-data'
  STORAGE_INTEGRATION = ittechgenie_azure_integration
  FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);




CREATE OR REPLACE FILE FORMAT csv_sales_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  NULL_IF = ('NULL', '')
  TRIM_SPACE = TRUE;



CREATE OR REPLACE DATABASE RETAIL_DB;
USE DATABASE RETAIL_DB;
CREATE OR REPLACE SCHEMA SALES;

CREATE OR REPLACE TABLE SALES.MONTHLY_SALES (
  sales_id STRING,
  sale_date DATE,
  product_id STRING,
  product_name STRING,
  store_id STRING,
  region STRING,
  quantity NUMBER,
  price NUMBER,
  total_amount NUMBER
);
-- Create stage (this part looks good)
CREATE OR REPLACE STAGE RETAIL_DB.SALES.SALES_STAGE_AZURE
  URL='azure://ittechgeniestore.blob.core.windows.net/sales-data'
  CREDENTIALS=(AZURE_SAS_TOKEN='sp=r&st=2025-10-22T09:46:11Z&se=2025-10-22T18:01:11Z&spr=https&sv=2024-11-04&sr=c&sig=jgHDKZ1paOJFY3XPlTKyMsWQPnzBLvCpDDZ6HS3P4lA%3D')
  FILE_FORMAT=(TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);

-- Verify stage creation
SHOW STAGES IN SCHEMA RETAIL_DB.SALES;

--  Use full stage reference
COPY INTO SALES_DB.MONTHLY_SALES
FROM @RETAIL_DB.SALES.SALES_STAGE_AZURE/sales_2025_10.csv
FILE_FORMAT = (FORMAT_NAME = 'csv_sales_format')
ON_ERROR = 'CONTINUE';

SHOW CURRENT_REGION();

CREATE OR REPLACE PIPE sales_pipe_auto
  AUTO_INGEST = TRUE
  AS
  COPY INTO SALES.MONTHLY_SALES
  FROM @sales_stage_azure
  FILE_FORMAT = (FORMAT_NAME = 'csv_sales_format')
  ON_ERROR = 'CONTINUE';

SELECT * FROM TABLE(INFORMATION_SCHEMA.LOAD_HISTORY_BY_PIPE(PIPE_NAME => 'SALES_PIPE_AUTO', START_TIME => DATEADD('hour', -1, CURRENT_TIMESTAMP())));


  SELECT COUNT(*) FROM SALES.MONTHLY_SALES WHERE sale_date >= '2025-10-01';

USE DATABASE MY_PRACTICE_DB;

-- Create a stage for Azure Blob Storage
CREATE OR REPLACE STAGE azure_stage
  url='azure://snowflak.blob.core.windows.net/sales'
  credentials=(AZURE_SAS_TOKEN='sv=2024-11-04&ss=b&srt=co&sp=rwltfx&se=2025-10-25T12:27:19Z&st=2025-10-15T04:12:19Z&spr=https&sig=K4FzZIZhwGj%2FYUT3xFKhxhxhtzIG0XO9%2BUFlTQmr0iM%3D');

-- Create a table
CREATE OR REPLACE TABLE sales_data (
  order_id STRING,
  amount NUMBER,
  region STRING
);
INSERT INTO sales_data (order_id, amount, region) VALUES
  ('ORD001', 150.75, 'North'),
  ('ORD002', 299.99, 'South'),
  ('ORD003', 89.50,  'East'),
  ('ORD004', 450.00, 'West'),
  ('ORD005', 120.25, 'North');

  SELECT * FROM MY_PRACTICE_DB.PUBLIC.SALES_DATA;
--Load data
COPY INTO sales_data
FROM @azure_stage/sales_oct.csv
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
);


--Type 2 (Contiuous ingestion)

CREATE OR REPLACE PIPE azure_sales_pipe
AS
COPY INTO sales_data
FROM @azure_stage
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER=',' SKIP_HEADER=1);

select * from MY_PRACTICE_DB.PUBLIC.AZURE_SALES_PIPE;


SELECT 
  raw_data:customer.id::string AS customer_id,
  raw_data:order.amount::number AS order_amount
FROM sales_json;

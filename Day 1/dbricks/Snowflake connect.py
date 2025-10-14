options = {
    "sfURL": "ioijmaj-rr68892.snowflakecomputing.com",
    "sfDatabase": "TRAINING_DB",
    "sfSchema": "RAW",
    "sfWarehouse": "COMPUTE_WH",
    "sfRole": "ACCOUNTADMIN",
    "sfUser": "nikitha",
    "sfPassword": "*"
}
df = spark.read.format("snowflake").options(**options).option("dbtable", "SALES").load()
df.show()
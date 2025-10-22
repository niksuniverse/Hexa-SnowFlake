CREATE OR REPLACE TABLE users(
    id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR,
    last_name VARCHAR DEFAULT 'no last name'
);

INSERT INTO users 
VALUES 
    (1, 'Nikitha', NULL);

SELECT * FROM users;

SELECT CURRENT_REGION();

CREATE OR REPLACE SHARE users_data_share;

GRANT USAGE ON DATABASE sales TO SHARE users_data_share;

GRANT USAGE ON SCHEMA day_7 TO SHARE users_data_share;

GRANT SELECT ON TABLE users TO SHARE users_data_share;

SHOW SHARES;

DESCRIBE SHARE users_data_share;

CREATE MANAGED ACCOUNT sharing 
    ADMIN_NAME = 'nikitha'
    ADMIN_PASSWORD = '*'
    TYPE = READER;

ALTER SHARE users_data_share ADD ACCOUNT = *******;

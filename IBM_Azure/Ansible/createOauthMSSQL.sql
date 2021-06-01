-- Manually create DATABASE using object explorer and provide name as oath2db;

CREATE SCHEMA OAUTHDBSCHEMA;
GO

---- CREATE TABLES ----
CREATE TABLE OAUTHDBSCHEMA.OAUTH20CACHE
(
LOOKUPKEY VARCHAR(256) NOT NULL, 
UNIQUEID VARCHAR(128) NOT NULL,
COMPONENTID VARCHAR(256) NOT NULL,
TYPE VARCHAR(64) NOT NULL, 
SUBTYPE VARCHAR(64), 
CREATEDAT BIGINT,
LIFETIME INT, 
EXPIRES BIGINT, 
TOKENSTRING NVARCHAR(MAX) NOT NULL,
CLIENTID VARCHAR(64) NOT NULL,
USERNAME VARCHAR(64) NOT NULL, 
SCOPE VARCHAR(512) NOT NULL, 
REDIRECTURI VARCHAR(2048), 
STATEID VARCHAR(64) NOT NULL,
EXTENDEDFIELDS NVARCHAR(2048) NOT NULL DEFAULT '{}'
);
GO

CREATE TABLE OAUTHDBSCHEMA.OAUTH20CLIENTCONFIG 
(
COMPONENTID VARCHAR(256) NOT NULL, 
CLIENTID VARCHAR(256) NOT NULL, 
CLIENTSECRET VARCHAR(256), 
DISPLAYNAME VARCHAR(256) NOT NULL,
REDIRECTURI VARCHAR(2048), 
ENABLED INT,
CLIENTMETADATA NVARCHAR(2048) NOT NULL DEFAULT '{}'
);
GO

CREATE TABLE OAUTHDBSCHEMA.OAUTH20CONSENTCACHE (
CLIENTID VARCHAR(256) NOT NULL,
USERID VARCHAR(256),
PROVIDERID VARCHAR(256) NOT NULL,
SCOPE VARCHAR(1024) NOT NULL,
EXPIRES BIGINT,
EXTENDEDFIELDS NVARCHAR(2048) NOT NULL DEFAULT '{}'
);
GO

---- ADD CONSTRAINTS ----
ALTER TABLE OAUTHDBSCHEMA.OAUTH20CACHE
ADD CONSTRAINT PK_LOOKUPKEY PRIMARY KEY (LOOKUPKEY);
GO

ALTER TABLE OAUTHDBSCHEMA.OAUTH20CLIENTCONFIG 
ADD CONSTRAINT PK_COMPIDCLIENTID PRIMARY KEY (COMPONENTID,CLIENTID);
GO

---- CREATE INDEXES ----
CREATE INDEX OAUTH20CACHE_EXPIRES ON OAUTHDBSCHEMA.OAUTH20CACHE (EXPIRES ASC);
GO

---- GRANT PRIVILEGES ----
---- UNCOMMENT THE FOLLOWING IF YOU USE AN ACCOUNT 
---OTHER THAN ADMINISTRATOR FOR DB ACCESS ----

-- Change dbuser to the account you want to use to access your database
--GRANT ALL ON OAUTHDBSCHEMA.OAUTH20CACHE TO dbuser;
--GRANT ALL ON OAUTHDBSCHEMA.OAUTH20CLIENTCONFIG TO dbuser;
--GRANT ALL ON OAUTHDBSCHEMA.OAUTH20CONSENTCACHE TO dbuser;

---- END OF GRANT PRIVILIGES ----
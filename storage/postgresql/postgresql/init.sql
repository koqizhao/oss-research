
CREATE USER PG_USER WITH
	LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	VALID UNTIL '2099-12-31T23:59:59+08:00' 
    PASSWORD 'PG_PASSWORD';
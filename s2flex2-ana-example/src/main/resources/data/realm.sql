CREATE TABLE USER(
	ID NUMERIC(8,0) NOT NULL PRIMARY KEY, 
	USER_ID VARCHAR(15) NOT NULL,
	PASSWORD VARCHAR(15) NOT NULL,
	USER_NAME VARCHAR(20),
	VERSION_NO NUMERIC(8) default 0
);
CREATE TABLE USER_ROLES(
	USER_ID VARCHAR(20) NOT NULL ,
 	ROLENAME VARCHAR(20) NOT NULL,
 	PRIMARY KEY(USER_ID,ROLENAME)
 );
INSERT INTO USER VALUES(1,'admin','adminpassword','administrator',0);
INSERT INTO USER VALUES(2,'user1','user1','editor User',0);
INSERT INTO USER_ROLES VALUES('admin','admin');
INSERT INTO USER_ROLES VALUES('admin','manager');
INSERT INTO USER_ROLES VALUES('user1','editor');
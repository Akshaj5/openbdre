CREATE TABLE BUS_DOMAIN (
  BUS_DOMAIN_ID INT(11) NOT NULL AUTO_INCREMENT,
  DESCRIPTION VARCHAR(256) NOT NULL,
  BUS_DOMAIN_NAME VARCHAR(45) NOT NULL,
  BUS_DOMAIN_OWNER VARCHAR(45) NOT NULL,
  PRIMARY KEY (BUS_DOMAIN_ID)
) ENGINE=INNODB AUTO_INCREMENT=13 DEFAULT CHARSET=UTF8;

CREATE TABLE BATCH_STATUS (
  BATCH_STATE_ID INT(11) NOT NULL,
  DESCRIPTION VARCHAR(45) NOT NULL,
  PRIMARY KEY (BATCH_STATE_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE PROCESS_TYPE (
  PROCESS_TYPE_ID INT(11) NOT NULL,
  PROCESS_TYPE_NAME VARCHAR(45) NOT NULL,
  PARENT_PROCESS_TYPE_ID INT(11),
  PRIMARY KEY (PROCESS_TYPE_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE EXEC_STATUS (
  EXEC_STATE_ID INT(11) NOT NULL,
  DESCRIPTION VARCHAR(45) NOT NULL,
  PRIMARY KEY (EXEC_STATE_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE WORKFLOW_TYPE (
  WORKFLOW_ID INT(11) NOT NULL,
    WORKFLOW_TYPE_NAME VARCHAR(45) NOT NULL,
    PRIMARY KEY (WORKFLOW_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE USERS (
  USERNAME VARCHAR(45) NOT NULL ,
  PASSWORD VARCHAR(45) NOT NULL ,
  ENABLED TINYINT(1) DEFAULT 1 ,
  PRIMARY KEY (USERNAME)
 )ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE USER_ROLES (
  USER_ROLE_ID INT(11) NOT NULL AUTO_INCREMENT,
  USERNAME VARCHAR(45) NOT NULL,
  ROLE VARCHAR(45) NOT NULL,
  PRIMARY KEY (USER_ROLE_ID),
  CONSTRAINT FK_USERNAME1 FOREIGN KEY (USERNAME) REFERENCES USERS (USERNAME)
  )
  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE PERMISSION_TYPE (
  PERMISSION_TYPE_ID INT(11) NOT NULL,
  PERMISSION_TYPE_NAME VARCHAR(45) NOT NULL,
  PRIMARY KEY (PERMISSION_TYPE_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE SERVERS (
  SERVER_ID INT(11) NOT NULL AUTO_INCREMENT,
  SERVER_TYPE VARCHAR(45) NOT NULL,
  SERVER_NAME VARCHAR(45) NOT NULL,
  SERVER_METAINFO VARCHAR(45) DEFAULT NULL,
  LOGIN_USER VARCHAR(45) DEFAULT NULL,
  LOGIN_PASSWORD VARCHAR(45) DEFAULT NULL,
  SSH_PRIVATE_KEY VARCHAR(512) DEFAULT NULL,
  SERVER_IP VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY (SERVER_ID)
) ENGINE=INNODB AUTO_INCREMENT=123459 DEFAULT CHARSET=UTF8;

CREATE TABLE PROCESS_TEMPLATE (
  PROCESS_TEMPLATE_ID INT(11) NOT NULL AUTO_INCREMENT,
  DESCRIPTION VARCHAR(256) NOT NULL,
  ADD_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PROCESS_NAME VARCHAR(45) NOT NULL,
  BUS_DOMAIN_ID INT(11) NOT NULL,
  PROCESS_TYPE_ID INT(11) NOT NULL,
  PARENT_PROCESS_ID INT(11) DEFAULT NULL,
  CAN_RECOVER TINYINT(1) DEFAULT '1',
  BATCH_CUT_PATTERN VARCHAR(45) DEFAULT NULL,
  NEXT_PROCESS_TEMPLATE_ID VARCHAR(256) DEFAULT '' NOT NULL,
  DELETE_FLAG TINYINT(1) DEFAULT '0',
  WORKFLOW_ID INT(11) DEFAULT '1',
  PRIMARY KEY (PROCESS_TEMPLATE_ID),
  KEY BUS_DOMAIN_ID_TEMPLATE (BUS_DOMAIN_ID),
  KEY PROCESS_TYPE_ID1_TEMPLATE (PROCESS_TYPE_ID),
  KEY ORIGINAL_PROCESS_ID1_TEMPLATE (PARENT_PROCESS_ID),
  CONSTRAINT BUS_DOMAIN_ID_TEMPLATE FOREIGN KEY (BUS_DOMAIN_ID) REFERENCES BUS_DOMAIN (BUS_DOMAIN_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT ORIGINAL_PROCESS_ID1_TEMPLATE FOREIGN KEY (PARENT_PROCESS_ID) REFERENCES PROCESS_TEMPLATE (PROCESS_TEMPLATE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT WORKFLOW_ID_TEMPLATE FOREIGN KEY (WORKFLOW_ID) REFERENCES WORKFLOW_TYPE (WORKFLOW_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT PROCESS_TYPE_ID1_TEMPLATE FOREIGN KEY (PROCESS_TYPE_ID) REFERENCES PROCESS_TYPE (PROCESS_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION

) ENGINE=INNODB AUTO_INCREMENT=122 DEFAULT CHARSET=UTF8;

DELIMITER $$

CREATE TRIGGER PROCESS_TEMPLATE_TYPE_CHECK_INSERT
     BEFORE INSERT ON PROCESS_TEMPLATE FOR EACH ROW
     BEGIN
          IF NEW.PROCESS_TYPE_ID IN (1,2,3,4,5) AND NEW.PARENT_PROCESS_ID IS NOT NULL
          THEN
               CALL RAISE_ERROR;
          END IF;

 IF NEW.PROCESS_TYPE_ID IN (6,7,8,9,10,11,12) AND NEW.PARENT_PROCESS_ID IS NULL
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO ETL GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
 IF NEW.PROCESS_TYPE_ID IN (6,7,8) AND (SELECT PROCESS_TYPE_ID FROM PROCESS_TEMPLATE WHERE PROCESS_TEMPLATE_ID=NEW.PARENT_PROCESS_ID) != 5
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
 IF NEW.PROCESS_TYPE_ID IN (9,10,11) AND (SELECT PROCESS_TYPE_ID FROM PROCESS_TEMPLATE WHERE PROCESS_TEMPLATE_ID=NEW.PARENT_PROCESS_ID) != 2
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
 IF NEW.PROCESS_TYPE_ID IN (12) AND (SELECT PROCESS_TYPE_ID FROM PROCESS_TEMPLATE WHERE PROCESS_TEMPLATE_ID=NEW.PARENT_PROCESS_ID) != 1
          THEN
               CALL RAISE_ERROR;
          END IF;
     END $$
DELIMITER ;



DELIMITER $$

CREATE TRIGGER PROCESS_TEMPLATE_TYPE_CHECK_UPDATE
     BEFORE UPDATE ON PROCESS_TEMPLATE FOR EACH ROW
     BEGIN
          IF NEW.PROCESS_TYPE_ID IN (1,2,3,4,5) AND NEW.PARENT_PROCESS_ID IS NOT NULL
          THEN
               CALL RAISE_ERROR;
          END IF;

		  IF NEW.PROCESS_TYPE_ID IN (6,7,8,9,10,11,12) AND NEW.PARENT_PROCESS_ID IS NULL
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO ETL GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
		  IF NEW.PROCESS_TYPE_ID IN (6,7,8) AND (SELECT PROCESS_TYPE_ID FROM PROCESS_TEMPLATE WHERE PROCESS_TEMPLATE_ID=NEW.PARENT_PROCESS_ID) != 5
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
		  IF NEW.PROCESS_TYPE_ID IN (9,10,11) AND (SELECT PROCESS_TYPE_ID FROM PROCESS_TEMPLATE WHERE PROCESS_TEMPLATE_ID=NEW.PARENT_PROCESS_ID) != 2
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
		  IF NEW.PROCESS_TYPE_ID IN (12) AND (SELECT PROCESS_TYPE_ID FROM PROCESS_TEMPLATE WHERE PROCESS_TEMPLATE_ID=NEW.PARENT_PROCESS_ID) != 1
          THEN
               CALL RAISE_ERROR;
          END IF;
     END;
$$
DELIMITER ;

SET GLOBAL SQL_MODE='NO_AUTO_VALUE_ON_ZERO';


CREATE TABLE PROPERTIES_TEMPLATE (
  PROCESS_TEMPLATE_ID INT(11) NOT NULL,
  CONFIG_GROUP VARCHAR(128) NOT NULL,
  PROP_TEMP_KEY VARCHAR(128) NOT NULL,
  PROP_TEMP_VALUE VARCHAR(2048) NOT NULL,
  DESCRIPTION VARCHAR(1028) NOT NULL,
  PRIMARY KEY (PROCESS_TEMPLATE_ID,PROP_TEMP_KEY),
  CONSTRAINT PROCESS_TEMPLATE_ID5 FOREIGN KEY (PROCESS_TEMPLATE_ID) REFERENCES PROCESS_TEMPLATE (PROCESS_TEMPLATE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;



CREATE TABLE PROCESS (
  PROCESS_ID INT(11) NOT NULL AUTO_INCREMENT,
  DESCRIPTION VARCHAR(256) NOT NULL,
  ADD_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PROCESS_NAME VARCHAR(45) NOT NULL,
  BUS_DOMAIN_ID INT(11) NOT NULL,
  PROCESS_TYPE_ID INT(11) NOT NULL,
  PARENT_PROCESS_ID INT(11) DEFAULT NULL,
  CAN_RECOVER TINYINT(1) DEFAULT '1',
  ENQUEUING_PROCESS_ID INT(11) NOT NULL DEFAULT '0',
  BATCH_CUT_PATTERN VARCHAR(45) DEFAULT NULL,
  NEXT_PROCESS_ID VARCHAR(256) NOT NULL DEFAULT '',
  DELETE_FLAG TINYINT(1) DEFAULT '0',
  WORKFLOW_ID INT(11) DEFAULT '1',
  PROCESS_TEMPLATE_ID INT(11) DEFAULT '0',
  EDIT_TS TIMESTAMP NOT NULL,
  PROCESS_CODE VARCHAR(256),
  USER_NAME VARCHAR(45),
  OWNER_ROLE_ID INT(11),
  USER_ACCESS_ID INT(1)  DEFAULT '7',
  GROUP_ACCESS_ID INT(1)  DEFAULT '4',
  OTHERS_ACCESS_ID INT(1)  DEFAULT '0',
  PRIMARY KEY (PROCESS_ID),
  KEY BUS_DOMAIN_ID (BUS_DOMAIN_ID),
  KEY PROCESS_TYPE_ID1 (PROCESS_TYPE_ID),
  KEY ORIGINAL_PROCESS_ID1 (PARENT_PROCESS_ID),
  KEY WORKFLOW_ID (WORKFLOW_ID),
  KEY PROCESS_TEMPLATE_ID (PROCESS_TEMPLATE_ID),
  CONSTRAINT BUS_DOMAIN_ID FOREIGN KEY (BUS_DOMAIN_ID) REFERENCES BUS_DOMAIN (BUS_DOMAIN_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT ORIGINAL_PROCESS_ID1 FOREIGN KEY (PARENT_PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT PROCESS_IBFK_1 FOREIGN KEY (PROCESS_TEMPLATE_ID) REFERENCES PROCESS_TEMPLATE (PROCESS_TEMPLATE_ID),
  CONSTRAINT PROCESS_TYPE_ID1 FOREIGN KEY (PROCESS_TYPE_ID) REFERENCES PROCESS_TYPE (PROCESS_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT PERMISSION_TYPE_ID1 FOREIGN KEY (USER_ACCESS_ID) REFERENCES PERMISSION_TYPE (PERMISSION_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT PERMISSION_TYPE_ID2 FOREIGN KEY (GROUP_ACCESS_ID) REFERENCES PERMISSION_TYPE (PERMISSION_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT PERMISSION_TYPE_ID3 FOREIGN KEY (OTHERS_ACCESS_ID) REFERENCES PERMISSION_TYPE (PERMISSION_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT OWNER_CHECK FOREIGN KEY(OWNER_ROLE_ID) REFERENCES USER_ROLES (USER_ROLE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT WORKFLOW_ID FOREIGN KEY (WORKFLOW_ID) REFERENCES WORKFLOW_TYPE (WORKFLOW_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT USER_CONSTRAINT FOREIGN KEY (USER_NAME) REFERENCES USERS (USERNAME) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8;


DELIMITER $$

CREATE TRIGGER PROCESS_TYPE_CHECK_INSERT
     BEFORE INSERT ON PROCESS FOR EACH ROW
     BEGIN
          IF NEW.PROCESS_TYPE_ID IN (1,2,3,4,5) AND NEW.PARENT_PROCESS_ID IS NOT NULL
          THEN
               CALL RAISE_ERROR;
          END IF;

 IF NEW.PROCESS_TYPE_ID IN (6,7,8,9,10,11,12) AND NEW.PARENT_PROCESS_ID IS NULL
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO ETL GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
 IF NEW.PROCESS_TYPE_ID IN (6,7,8) AND (SELECT PROCESS_TYPE_ID FROM PROCESS WHERE PROCESS_ID=NEW.PARENT_PROCESS_ID) != 5
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
 IF NEW.PROCESS_TYPE_ID IN (9,10,11) AND (SELECT PROCESS_TYPE_ID FROM PROCESS WHERE PROCESS_ID=NEW.PARENT_PROCESS_ID) != 2
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
 IF NEW.PROCESS_TYPE_ID IN (12) AND (SELECT PROCESS_TYPE_ID FROM PROCESS WHERE PROCESS_ID=NEW.PARENT_PROCESS_ID) != 1
          THEN
               CALL RAISE_ERROR;
          END IF;
     END $$
DELIMITER ;


DELIMITER $$

CREATE TRIGGER PROCESS_TYPE_CHECK_UPDATE
     BEFORE UPDATE ON PROCESS FOR EACH ROW
     BEGIN

      SET NEW.EDIT_TS = CURRENT_TIMESTAMP;

          IF NEW.PROCESS_TYPE_ID IN (1,2,3,4,5) AND NEW.PARENT_PROCESS_ID IS NOT NULL
          THEN
               CALL RAISE_ERROR;
          END IF;

		  IF NEW.PROCESS_TYPE_ID IN (6,7,8,9,10,11,12) AND NEW.PARENT_PROCESS_ID IS NULL
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO ETL GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
		  IF NEW.PROCESS_TYPE_ID IN (6,7,8) AND (SELECT PROCESS_TYPE_ID FROM PROCESS WHERE PROCESS_ID=NEW.PARENT_PROCESS_ID) != 5
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
		  IF NEW.PROCESS_TYPE_ID IN (9,10,11) AND (SELECT PROCESS_TYPE_ID FROM PROCESS WHERE PROCESS_ID=NEW.PARENT_PROCESS_ID) != 2
          THEN
               CALL RAISE_ERROR;
          END IF;
-- IF NEW ROWS PARENT DOES NOT BELONG TO SEMANTIC GROUP WHERE THE NEW ROW TYPE ARE 6,7,8 THROW ERROR
		  IF NEW.PROCESS_TYPE_ID IN (12) AND (SELECT PROCESS_TYPE_ID FROM PROCESS WHERE PROCESS_ID=NEW.PARENT_PROCESS_ID) != 1
          THEN
               CALL RAISE_ERROR;
          END IF;

     END;
$$
DELIMITER ;


CREATE TABLE PROPERTIES (
  PROCESS_ID INT(11) NOT NULL,
  CONFIG_GROUP VARCHAR(128) NOT NULL,
  PROP_KEY VARCHAR(128) NOT NULL,
  PROP_VALUE VARCHAR(2048) NOT NULL,
  DESCRIPTION VARCHAR(1028) NOT NULL,
  PRIMARY KEY (PROCESS_ID,PROP_KEY),
  CONSTRAINT PROCESS_ID4 FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE INSTANCE_EXEC (
  INSTANCE_EXEC_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
  PROCESS_ID INT(11) NOT NULL,
  START_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  END_TS TIMESTAMP NULL DEFAULT NULL,
  EXEC_STATE INT(11) NOT NULL,
  PRIMARY KEY (INSTANCE_EXEC_ID),
  KEY PROCESS_ID_INSTANCE_EXEC (PROCESS_ID),
  KEY EXEC_STATE_INSTANCE_EXEC (EXEC_STATE),
  CONSTRAINT PROCESS_ID_INSTANCE_EXEC FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT EXEC_STATE_INSTANCE_EXEC FOREIGN KEY (EXEC_STATE) REFERENCES EXEC_STATUS (EXEC_STATE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB AUTO_INCREMENT=174 DEFAULT CHARSET=UTF8;


CREATE TABLE BATCH (
  BATCH_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
  SOURCE_INSTANCE_EXEC_ID BIGINT(20) DEFAULT NULL,
  BATCH_TYPE VARCHAR(45) NOT NULL,
  PRIMARY KEY (BATCH_ID),
  KEY INSTANCE_EXEC_ID (SOURCE_INSTANCE_EXEC_ID),
  CONSTRAINT INSTANCE_EXEC_ID FOREIGN KEY (SOURCE_INSTANCE_EXEC_ID) REFERENCES INSTANCE_EXEC (INSTANCE_EXEC_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB AUTO_INCREMENT=212 DEFAULT CHARSET=UTF8;


CREATE TABLE FILE (
  BATCH_ID BIGINT(20) NOT NULL,
  SERVER_ID INT(11) NOT NULL,
  PATH VARCHAR(256) NOT NULL,
  FILE_SIZE BIGINT(20) NOT NULL,
  FILE_HASH VARCHAR(100) DEFAULT NULL,
  CREATION_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY SERVER_ID (SERVER_ID),
  KEY UNIQUE_BATCH (BATCH_ID),
  CONSTRAINT SERVER_ID FOREIGN KEY (SERVER_ID) REFERENCES SERVERS (SERVER_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT UNIQUE_BATCH FOREIGN KEY (BATCH_ID) REFERENCES BATCH (BATCH_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE BATCH_CONSUMP_QUEUE (
  SOURCE_BATCH_ID BIGINT(20) NOT NULL,
  TARGET_BATCH_ID BIGINT(20) DEFAULT NULL,
  QUEUE_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
  INSERT_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  SOURCE_PROCESS_ID INT(11) DEFAULT NULL,
  START_TS TIMESTAMP NULL DEFAULT NULL,
  END_TS TIMESTAMP NULL DEFAULT NULL,
  BATCH_STATE INT(11) NOT NULL,
  BATCH_MARKING VARCHAR(45) DEFAULT NULL,
  PROCESS_ID INT(11) NOT NULL,
  PRIMARY KEY (QUEUE_ID),
  KEY SOURCE_BATCH_BCQ (SOURCE_BATCH_ID),
  KEY TARGET_BATCH_BCQ (TARGET_BATCH_ID),
  KEY BATCH_STATE_BCQ (BATCH_STATE),
  KEY PROCESS_ID_BCQ (PROCESS_ID),
  CONSTRAINT BATCH_STATE_BCQ FOREIGN KEY (BATCH_STATE) REFERENCES BATCH_STATUS (BATCH_STATE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT PROCESS_ID_BCQ FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT SOURCE_BATCH_BCQ FOREIGN KEY (SOURCE_BATCH_ID) REFERENCES BATCH (BATCH_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT TARGET_BATCH_BCQ FOREIGN KEY (TARGET_BATCH_ID) REFERENCES BATCH (BATCH_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB AUTO_INCREMENT=1330 DEFAULT CHARSET=UTF8;


CREATE TABLE ARCHIVE_CONSUMP_QUEUE (
  SOURCE_BATCH_ID BIGINT(20) NOT NULL,
  TARGET_BATCH_ID BIGINT(20) DEFAULT NULL,
  QUEUE_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
  INSERT_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  SOURCE_PROCESS_ID INT(11) DEFAULT NULL,
  START_TS TIMESTAMP NULL DEFAULT NULL,
  END_TS TIMESTAMP NULL DEFAULT NULL,
  BATCH_STATE INT(11) NOT NULL,
  BATCH_MARKING VARCHAR(45) DEFAULT NULL,
  PROCESS_ID INT(11) NOT NULL,
  PRIMARY KEY (QUEUE_ID),
  KEY SOURCE_BATCH_ARCHIVE_CONSUMP_QUEUE (SOURCE_BATCH_ID),
  KEY TARGET_BATCH_ARCHIVE_CONSUMP_QUEUE (TARGET_BATCH_ID),
  KEY BATCH_STATE_ARCHIVE_CONSUMP_QUEUE (BATCH_STATE),
  CONSTRAINT PROCESS_ID_ARCHIVE_CONSUMP_QUEUE FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT BATCH_STATE_ARCHIVE_CONSUMP_QUEUE FOREIGN KEY (BATCH_STATE) REFERENCES BATCH_STATUS (BATCH_STATE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT SOURCE_BATCH_ARCHIVE_CONSUMP_QUEUE FOREIGN KEY (SOURCE_BATCH_ID) REFERENCES BATCH (BATCH_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT TARGET_BATCH_ARCHIVE_CONSUMP_QUEUE FOREIGN KEY (TARGET_BATCH_ID) REFERENCES BATCH (BATCH_ID) ON DELETE NO ACTION ON UPDATE NO ACTION

) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE INTERMEDIATE (
  UUID VARCHAR(64) NOT NULL,
  INTER_KEY VARCHAR(128) NOT NULL,
  INTER_VALUE VARCHAR(2048) NOT NULL,
  PRIMARY KEY (INTER_KEY,UUID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;





CREATE TABLE PROCESS_LOG (
  LOG_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
  ADD_TS TIMESTAMP,
  PROCESS_ID INT(11) NOT NULL,
  LOG_CATEGORY VARCHAR(10) NOT NULL,
  MESSAGE_ID VARCHAR(128) NOT NULL,
  MESSAGE VARCHAR(1024) NOT NULL,
  INSTANCE_REF BIGINT(20),
  PRIMARY KEY (LOG_ID),
  CONSTRAINT PROCESS_ID FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;





-- LINEAGE TABLE DDLS

CREATE TABLE LINEAGE_NODE_TYPE (
  NODE_TYPE_ID INT(11) NOT NULL,
  NODE_TYPE_NAME VARCHAR(45) NOT NULL,
  PRIMARY KEY (NODE_TYPE_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE LINEAGE_QUERY_TYPE (
  QUERY_TYPE_ID INT(11) NOT NULL,
  QUERY_TYPE_NAME VARCHAR(255) NOT NULL,
  PRIMARY KEY (QUERY_TYPE_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE LINEAGE_QUERY (
  QUERY_ID VARCHAR(100) NOT NULL,
  QUERY_STRING LONGTEXT ,
  QUERY_TYPE_ID INT(11) NOT NULL,
  CREATE_TS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PROCESS_ID INT(11),
  INSTANCE_EXEC_ID BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (QUERY_ID),
  KEY PROCESS_ID (PROCESS_ID),
  KEY QUERY_TYPE_ID (QUERY_TYPE_ID),
  -- CONSTRAINT PROCESS_ID FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT QUERY_TYPE_ID FOREIGN KEY (QUERY_TYPE_ID) REFERENCES LINEAGE_QUERY_TYPE (QUERY_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE LINEAGE_NODE (
  NODE_ID VARCHAR(100) NOT NULL,
  NODE_TYPE_ID INT(11) NOT NULL,
  CONTAINER_NODE_ID VARCHAR(100) DEFAULT NULL,
  NODE_ORDER INT(11) DEFAULT '0',
  INSERT_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPDATE_TS TIMESTAMP NULL DEFAULT NULL,
  DOT_STRING LONGTEXT,
  DOT_LABEL LONGTEXT,
  DISPLAY_NAME VARCHAR(256) DEFAULT NULL,
  PRIMARY KEY (NODE_ID),
  KEY NODE_TYPE (NODE_TYPE_ID),
  KEY CONATINER_NODE_ID (CONTAINER_NODE_ID),
  CONSTRAINT CONATINER_NODE_ID FOREIGN KEY (CONTAINER_NODE_ID) REFERENCES LINEAGE_NODE (NODE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT NODE_TYPE FOREIGN KEY (NODE_TYPE_ID) REFERENCES LINEAGE_NODE_TYPE (NODE_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE LINEAGE_RELATION (
  RELATION_ID VARCHAR(100) NOT NULL,
  SRC_NODE_ID VARCHAR(100) DEFAULT NULL,
  TARGET_NODE_ID VARCHAR(100) DEFAULT NULL,
  QUERY_ID VARCHAR(100) NOT NULL,
  DOT_STRING LONGTEXT,
  PRIMARY KEY (RELATION_ID),
  KEY SRC_NODE_ID (SRC_NODE_ID),
  KEY TARGET_NODE_ID (TARGET_NODE_ID),
  KEY QUERY_ID (QUERY_ID),
  CONSTRAINT SRC_NODE_ID FOREIGN KEY (SRC_NODE_ID) REFERENCES LINEAGE_NODE (NODE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT TARGET_NODE_ID FOREIGN KEY (TARGET_NODE_ID) REFERENCES LINEAGE_NODE (NODE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT QUERY_ID FOREIGN KEY (QUERY_ID) REFERENCES LINEAGE_QUERY (QUERY_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE DEPLOY_STATUS (
  DEPLOY_STATUS_ID SMALLINT NOT NULL,
  DESCRIPTION VARCHAR(45) NOT NULL,
  PRIMARY KEY (DEPLOY_STATUS_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE GENERAL_CONFIG (
  CONFIG_GROUP VARCHAR(128) NOT NULL,
  GC_KEY VARCHAR(128) NOT NULL,
  GC_VALUE VARCHAR(2048)  NULL,
  DESCRIPTION VARCHAR(1028) NOT NULL,
  REQUIRED TINYINT(1)  DEFAULT '0',
  DEFAULT_VAL VARCHAR(2048)  NULL,
  TYPE VARCHAR(20) NOT NULL DEFAULT 'TEXT',
  ENABLED TINYINT(1) DEFAULT '1',
  PRIMARY KEY (CONFIG_GROUP,GC_KEY)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE PROCESS_DEPLOYMENT_QUEUE (
   DEPLOYMENT_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
   PROCESS_ID INT(11) NOT NULL ,
   START_TS TIMESTAMP NULL DEFAULT NULL,
   INSERT_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   END_TS TIMESTAMP NULL DEFAULT NULL,
   DEPLOY_STATUS_ID SMALLINT NOT NULL DEFAULT 1,
   USER_NAME VARCHAR(45) NOT NULL,
   BUS_DOMAIN_ID INT(11) NOT NULL,
   PROCESS_TYPE_ID INT(11) NOT NULL,
   DEPLOY_SCRIPT_LOCATION VARCHAR(1000) DEFAULT NULL,
  PRIMARY KEY (DEPLOYMENT_ID),
  KEY DEPLOY_STATUS_ID (DEPLOY_STATUS_ID),
  KEY DEPLOY_PROCESS_ID (PROCESS_ID),
  KEY DEPLOY_PROCESS_TYPE_ID (PROCESS_TYPE_ID),
  KEY DEPLOY_BUS_DOMAIN_ID (BUS_DOMAIN_ID),
  CONSTRAINT DEPLOY_STATUS_ID FOREIGN KEY (DEPLOY_STATUS_ID) REFERENCES DEPLOY_STATUS (DEPLOY_STATUS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT DEPLOY_PROCESS_ID FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS (PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT DEPLOY_PROCESS_TYPE_ID FOREIGN KEY (PROCESS_TYPE_ID) REFERENCES PROCESS_TYPE (PROCESS_TYPE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT DEPLOY_BUS_DOMAIN_ID FOREIGN KEY (BUS_DOMAIN_ID) REFERENCES BUS_DOMAIN (BUS_DOMAIN_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;



CREATE TABLE DOCIDSDB (DOCID BIGINT NOT NULL AUTO_INCREMENT, URL VARCHAR(3000), PRIMARY KEY (DOCID) )ENGINE=INNODB DEFAULT CHARSET=UTF8;
CREATE TABLE STATISTICSDB (UNIQID BIGINT NOT NULL AUTO_INCREMENT, VALUE BIGINT, NAME VARCHAR(255), PRIMARY KEY (UNIQID))ENGINE=INNODB DEFAULT CHARSET=UTF8;
CREATE TABLE PENDINGURLSDB (UNIQID BIGINT NOT NULL AUTO_INCREMENT, PID BIGINT, INSTANCEEXECID BIGINT, URL VARCHAR(3000), DOCID INT(11) NOT NULL, PARENTDOCID INT(11) NOT NULL, PARENTURL VARCHAR(1000), DEPTH SMALLINT NOT NULL, DOMAIN VARCHAR(255), SUBDOMAIN VARCHAR(255), PATH VARCHAR(1000), ANCHOR VARCHAR(255),PRIORITY INT(11) NOT NULL, TAG VARCHAR(255), PRIMARY KEY (UNIQID))ENGINE=INNODB DEFAULT CHARSET=UTF8;
CREATE TABLE WEBURLSDB (UNIQID BIGINT NOT NULL AUTO_INCREMENT, PID BIGINT, INSTANCEEXECID BIGINT, URL VARCHAR(3000), DOCID INT(11) NOT NULL, PARENTDOCID INT(11) NOT NULL, PARENTURL VARCHAR(1000), DEPTH SMALLINT NOT NULL, DOMAIN VARCHAR(255), SUBDOMAIN VARCHAR(255), PATH VARCHAR(1000), ANCHOR VARCHAR(255),PRIORITY INT(11) NOT NULL, TAG VARCHAR(255), PRIMARY KEY (UNIQID)) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE APP_DEPLOYMENT_QUEUE_STATUS (
  APP_DEPLOYMENT_STATUS_ID SMALLINT NOT NULL,
  DESCRIPTION VARCHAR(45) NOT NULL,
  PRIMARY KEY (APP_DEPLOYMENT_STATUS_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE APP_DEPLOYMENT_QUEUE (
  APP_DEPLOYMENT_QUEUE_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
  PROCESS_ID INT(11) NOT NULL,
  USERNAME VARCHAR(45) NOT NULL,
  APP_DOMAIN VARCHAR(45) NOT NULL,
  APP_NAME VARCHAR(45) NOT NULL,
  APP_DEPLOYMENT_STATUS_ID SMALLINT NOT NULL,
  PRIMARY KEY (APP_DEPLOYMENT_QUEUE_ID),
  CONSTRAINT PROCESS_ID_ADQ_CONSTRAINT FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS(PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT ADQ_USER_CONSTRAINT FOREIGN KEY (USERNAME) REFERENCES USERS(USERNAME) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT ADQ_STATE_CONSTRAINT FOREIGN KEY (APP_DEPLOYMENT_STATUS_ID) REFERENCES APP_DEPLOYMENT_QUEUE_STATUS(APP_DEPLOYMENT_STATUS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8;


CREATE TABLE INSTALLED_PLUGINS (
  PLUGIN_UNIQUE_ID VARCHAR(128) NOT NULL,
  PLUGIN_ID VARCHAR(8) NOT NULL,
  NAME VARCHAR(128),
  DESCRIPTION VARCHAR(128),
  VERSION INT(11) NOT NULL DEFAULT 1,
  AUTHOR VARCHAR(128),
  ADD_TS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PLUGIN VARCHAR(128),
  UNINSTALLABLE TINYINT(1),
  PRIMARY KEY (PLUGIN_UNIQUE_ID)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;


CREATE TABLE PLUGIN_DEPENDENCY (
  DEPENDENCY_ID INT(11) NOT NULL AUTO_INCREMENT,
  PLUGIN_UNIQUE_ID VARCHAR(128) NOT NULL,
  DEPENDENT_PLUGIN_UNIQUE_ID VARCHAR(128),
  PRIMARY KEY (DEPENDENCY_ID),
  CONSTRAINT PLUGIN_UNIQUE_ID FOREIGN KEY (PLUGIN_UNIQUE_ID) REFERENCES INSTALLED_PLUGINS (PLUGIN_UNIQUE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT DEPENDENT_PLUGIN_UNIQUE_ID FOREIGN KEY (DEPENDENT_PLUGIN_UNIQUE_ID) REFERENCES INSTALLED_PLUGINS (PLUGIN_UNIQUE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE PLUGIN_CONFIG (
  PLUGIN_UNIQUE_ID VARCHAR(128) NOT NULL,
  CONFIG_GROUP VARCHAR(128),
  PLUGIN_KEY VARCHAR(128),
  PLUGIN_VALUE VARCHAR(128),
  PRIMARY KEY (PLUGIN_KEY,PLUGIN_UNIQUE_ID),
  CONSTRAINT PLUGIN_CONFIG_ID FOREIGN KEY (PLUGIN_UNIQUE_ID) REFERENCES INSTALLED_PLUGINS (PLUGIN_UNIQUE_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE ANALYTICS_APPS (
  ANALYTIC_APPS_ID BIGINT(20) NOT NULL AUTO_INCREMENT,
  PROCESS_ID INT(11) NOT NULL,
  INDUSTRY_NAME VARCHAR(45) NOT NULL,
  CATEGORY_NAME VARCHAR(45) NOT NULL,
  APP_DESCRIPTION VARCHAR(45) NOT NULL,
  APP_NAME VARCHAR(45) NOT NULL,
  QUESTIONS_JSON VARCHAR(45) NOT NULL,
  DASHBOARD_URL VARCHAR(45) NOT NULL,
  DDP_URL VARCHAR(45) NOT NULL,
  APP_IMAGE VARCHAR(45) NOT NULL,
  PRIMARY KEY (ANALYTIC_APPS_ID),
  CONSTRAINT PROCESS_ID_ANALYTIC_CONSTRAINT FOREIGN KEY (PROCESS_ID) REFERENCES PROCESS(PROCESS_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=UTF8;



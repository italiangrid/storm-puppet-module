--
-- StoRM Backend DATABASE
-- storm_be_ISAM
--

CREATE DATABASE IF NOT EXISTS storm_be_ISAM;
USE storm_be_ISAM;

CREATE TABLE IF NOT EXISTS db_version (
  ID int NOT NULL auto_increment,
  major int,
  minor int,
  revision int,
  description VARCHAR(100),
  primary key (ID)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DELETE FROM storm_be_ISAM.db_version;
INSERT INTO storm_be_ISAM.db_version (major,minor,revision,description) VALUES (1,1,0,'27 May 2011');

--
-- Table structure for table `storage_space`
--
CREATE TABLE IF NOT EXISTS `storage_space` (
  `SS_ID` bigint(20) NOT NULL auto_increment,
  `USERDN` VARCHAR(150) NOT NULL default '',
  `VOGROUP` VARCHAR(20) NOT NULL default '',
  `ALIAS` VARCHAR(100) default NULL,
  `SPACE_TOKEN` VARCHAR(100) BINARY NOT NULL default '',
  `CREATED` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP,
  `TOTAL_SIZE` bigint(20) NOT NULL default '0',
  `GUAR_SIZE` bigint(20) NOT NULL default '0',
  `FREE_SIZE` bigint(20) default NULL default '-1',
  `SPACE_FILE` VARCHAR(145) NOT NULL default '',
  `STORAGE_INFO` VARCHAR(255) default NULL,
  `LIFETIME` bigint(20) default NULL,
  `SPACE_TYPE` VARCHAR(10) NOT NULL default '',
  `USED_SIZE` bigint(20) NOT NULL default '-1',
  `BUSY_SIZE` bigint(20) NOT NULL default '-1',
  `UNAVAILABLE_SIZE` bigint(20) NOT NULL default '-1',
  `AVAILABLE_SIZE` bigint(20) NOT NULL default '-1',
  `RESERVED_SIZE` bigint(20) NOT NULL default '-1',
  `UPDATE_TIME` TIMESTAMP NOT NULL default '1970-01-02 00:00:00', 
  PRIMARY KEY  (`SS_ID`),
  INDEX ALIAS_index (`ALIAS`),
  INDEX TOKEN_index (`SPACE_TOKEN`),
  KEY `SPACE_NAME` (`SPACE_TOKEN`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


--
-- Table structure for table `tape_recall`
--
CREATE TABLE IF NOT EXISTS tape_recall (
  taskId CHAR(36) NOT NULL,
  requestToken VARCHAR(255) BINARY NOT NULL,
  requestType CHAR(4),
  fileName text not null,
  pinLifetime int,
  status int,
  voName VARCHAR(255) BINARY,
  userID VARCHAR(255) BINARY,
  retryAttempt int,
  timeStamp datetime not null,
  deferredStartTime datetime not null,
  groupTaskId CHAR(36) NOT NULL,
  inProgressTime datetime,
  finalStatusTime datetime,
  primary key (taskId , requestToken)) ENGINE=InnoDB;

ALTER TABLE tape_recall 
  ADD INDEX deferredStartTime_index (deferredStartTime),
  ADD INDEX groupTaskId_index (groupTaskId);
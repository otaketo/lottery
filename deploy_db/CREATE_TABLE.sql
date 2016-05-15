-- Project Name : プレゼント抽選
-- Date/Time    : 2016/05/15 16:51:35
-- Author       : ootake
-- RDBMS Type   : MySQL
-- Application  : A5:SQL Mk-2

-- 抽選
drop table if exists lots_master cascade;

create table lots_master (
  lots_id MEDIUMINT not null AUTO_INCREMENT comment '抽選ID'
  , lots_month MEDIUMINT not null comment '抽選年月'
  , open_lots DATETIME not null comment '抽選開始日'
  , lots_deadline DATETIME not null comment '抽選締め切り'
  , created TIMESTAMP not null comment '作成日時'
  , constraint pk_lots_master primary key (lots_id)
) comment '抽選' ;

alter table lots_master add unique uix_lots (lots_month) ;

-- 当選番号
drop table if exists winning_number cascade;

create table winning_number (
  winning_number_id MEDIUMINT not null AUTO_INCREMENT comment '当選番号ID'
  , lots_id MEDIUMINT not null comment '抽選ID'
  , winning_number MEDIUMINT not null comment '当選番号'
  , winning_token VARCHAR(32) not null comment '当選トークン'
  , created TIMESTAMP not null comment '作成日時'
  , constraint pk_winning_number primary key (winning_number_id)
) comment '当選番号' engine = InnoDB;

alter table winning_number add unique uix_winning_number (lots_id,winning_number) ;

-- プレゼント当選者
drop table if exists present_to cascade;

create table present_to (
  present_id MEDIUMINT not null AUTO_INCREMENT comment '当選者ID'
  , lots_id MEDIUMINT not null comment '抽選ID'
  , uid MEDIUMINT(7) ZEROFILL not null comment 'UID'
  , created TIMESTAMP not null comment '作成日時'
  , constraint pk_present_to primary key (present_id)
) comment 'プレゼント当選者' engine = InnoDB;

alter table present_to add unique uix_present_to (lots_id,uid) ;

-- プレゼント応募
drop table if exists entry_lots cascade;

create table entry_lots (
  entry_lots_id MEDIUMINT not null AUTO_INCREMENT comment '応募ID'
  , lots_id MEDIUMINT not null comment '抽選ID'
  , uid MEDIUMINT(7) ZEROFILL not null comment 'UID'
  , numbered_ticket MEDIUMINT not null comment '整理券'
  , created TIMESTAMP not null comment '作成日時'
  , constraint pk_entry_lots primary key (entry_lots_id)
) comment 'プレゼント応募' engine = InnoDB;

alter table entry_lots add unique uix_entry_lots_uid (lots_id,uid) ;

alter table entry_lots add unique uix_entry_lots_ticket (lots_id,numbered_ticket) ;

-- ユーザーマスタ
drop table if exists user_master cascade;

create table user_master (
  uid MEDIUMINT(7) ZEROFILL not null AUTO_INCREMENT comment 'UID'
  , area_code TINYINT(2) ZEROFILL not null comment '都道府県コード'
  , attr_gender BOOLEAN not null comment '性別'
  , attr_birthday SMALLINT UNSIGNED not null comment '生年'
  , modefied DATETIME not null comment '更新日時'
  , created DATETIME not null comment '作成日時'
  , constraint pk_user_master primary key (uid)
) comment 'ユーザーマスタ' engine = InnoDB;

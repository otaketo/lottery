-- Project Name : �v���[���g���I
-- Date/Time    : 2016/05/15 16:51:35
-- Author       : ootake
-- RDBMS Type   : MySQL
-- Application  : A5:SQL Mk-2

-- ���I
drop table if exists lots_master cascade;

create table lots_master (
  lots_id MEDIUMINT not null AUTO_INCREMENT comment '���IID'
  , lots_month MEDIUMINT not null comment '���I�N��'
  , open_lots DATETIME not null comment '���I�J�n��'
  , lots_deadline DATETIME not null comment '���I���ߐ؂�'
  , created TIMESTAMP not null comment '�쐬����'
  , constraint pk_lots_master primary key (lots_id)
) comment '���I' ;

alter table lots_master add unique uix_lots (lots_month) ;

-- ���I�ԍ�
drop table if exists winning_number cascade;

create table winning_number (
  winning_number_id MEDIUMINT not null AUTO_INCREMENT comment '���I�ԍ�ID'
  , lots_id MEDIUMINT not null comment '���IID'
  , winning_number MEDIUMINT not null comment '���I�ԍ�'
  , winning_token VARCHAR(32) not null comment '���I�g�[�N��'
  , created TIMESTAMP not null comment '�쐬����'
  , constraint pk_winning_number primary key (winning_number_id)
) comment '���I�ԍ�' engine = InnoDB;

alter table winning_number add unique uix_winning_number (lots_id,winning_number) ;

-- �v���[���g���I��
drop table if exists present_to cascade;

create table present_to (
  present_id MEDIUMINT not null AUTO_INCREMENT comment '���I��ID'
  , lots_id MEDIUMINT not null comment '���IID'
  , uid MEDIUMINT(7) ZEROFILL not null comment 'UID'
  , created TIMESTAMP not null comment '�쐬����'
  , constraint pk_present_to primary key (present_id)
) comment '�v���[���g���I��' engine = InnoDB;

alter table present_to add unique uix_present_to (lots_id,uid) ;

-- �v���[���g����
drop table if exists entry_lots cascade;

create table entry_lots (
  entry_lots_id MEDIUMINT not null AUTO_INCREMENT comment '����ID'
  , lots_id MEDIUMINT not null comment '���IID'
  , uid MEDIUMINT(7) ZEROFILL not null comment 'UID'
  , numbered_ticket MEDIUMINT not null comment '������'
  , created TIMESTAMP not null comment '�쐬����'
  , constraint pk_entry_lots primary key (entry_lots_id)
) comment '�v���[���g����' engine = InnoDB;

alter table entry_lots add unique uix_entry_lots_uid (lots_id,uid) ;

alter table entry_lots add unique uix_entry_lots_ticket (lots_id,numbered_ticket) ;

-- ���[�U�[�}�X�^
drop table if exists user_master cascade;

create table user_master (
  uid MEDIUMINT(7) ZEROFILL not null AUTO_INCREMENT comment 'UID'
  , area_code TINYINT(2) ZEROFILL not null comment '�s���{���R�[�h'
  , attr_gender BOOLEAN not null comment '����'
  , attr_birthday SMALLINT UNSIGNED not null comment '���N'
  , modefied DATETIME not null comment '�X�V����'
  , created DATETIME not null comment '�쐬����'
  , constraint pk_user_master primary key (uid)
) comment '���[�U�[�}�X�^' engine = InnoDB;

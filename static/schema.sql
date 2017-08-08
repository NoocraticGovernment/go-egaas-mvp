﻿DROP SEQUENCE IF EXISTS "dlt_transactions_id_seq" CASCADE;
CREATE SEQUENCE "dlt_transactions_id_seq" START WITH 1;
DROP TABLE IF EXISTS "dlt_transactions"; CREATE TABLE "dlt_transactions" (
"id" bigint NOT NULL  default nextval('dlt_transactions_id_seq'),
"sender_wallet_id" bigint NOT NULL DEFAULT '0',
"recipient_wallet_id" bigint NOT NULL DEFAULT '0',
"amount" decimal(30) NOT NULL DEFAULT '0',
"commission" decimal(30) NOT NULL DEFAULT '0',
"time" int  NOT NULL DEFAULT '0',
"comment" text NOT NULL DEFAULT '',
"block_id" int  NOT NULL DEFAULT '0',
"rb_id" int  NOT NULL DEFAULT '0'
);
ALTER SEQUENCE "dlt_transactions_id_seq" owned by "dlt_transactions".id;
ALTER TABLE ONLY "dlt_transactions" ADD CONSTRAINT "dlt_transactions_pkey" PRIMARY KEY (id);
CREATE INDEX dlt_transactions_index_sender ON "dlt_transactions" (sender_wallet_id);
CREATE INDEX dlt_transactions_index_recipient ON "dlt_transactions" (recipient_wallet_id);



DROP TYPE IF EXISTS "my_keys_enum_status" CASCADE;
CREATE TYPE "my_keys_enum_status" AS ENUM ('my_pending','approved');
DROP SEQUENCE IF EXISTS my_keys_id_seq CASCADE;
CREATE SEQUENCE my_keys_id_seq START WITH 1;
DROP TABLE IF EXISTS "my_keys"; CREATE TABLE "my_keys" (
"id" int NOT NULL  default nextval('my_keys_id_seq'),
"add_time" int NOT NULL DEFAULT '0',
"notification" smallint NOT NULL DEFAULT '0',
"public_key" bytea  NOT NULL DEFAULT '',
"private_key" varchar(3096) NOT NULL DEFAULT '',
"password_hash" varchar(64) NOT NULL DEFAULT '',
"status" my_keys_enum_status  NOT NULL DEFAULT 'my_pending',
"my_time" int  NOT NULL DEFAULT '0',
"time" int  NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE my_keys_id_seq owned by my_keys.id;
ALTER TABLE ONLY "my_keys" ADD CONSTRAINT my_keys_pkey PRIMARY KEY (id);




DROP TYPE IF EXISTS "my_node_keys_enum_status" CASCADE;
CREATE TYPE "my_node_keys_enum_status" AS ENUM ('my_pending','approved');
DROP SEQUENCE IF EXISTS my_node_keys_id_seq CASCADE;
CREATE SEQUENCE my_node_keys_id_seq START WITH 1;
DROP TABLE IF EXISTS "my_node_keys"; CREATE TABLE "my_node_keys" (
"id" int NOT NULL  default nextval('my_node_keys_id_seq'),
"add_time" int NOT NULL DEFAULT '0',
"public_key" bytea  NOT NULL DEFAULT '',
"private_key" varchar(3096) NOT NULL DEFAULT '',
"status" my_node_keys_enum_status  NOT NULL DEFAULT 'my_pending',
"my_time" int NOT NULL DEFAULT '0',
"time" bigint NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0',
"rb_id" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE my_node_keys_id_seq owned by my_node_keys.id;
ALTER TABLE ONLY "my_node_keys" ADD CONSTRAINT my_node_keys_pkey PRIMARY KEY (id);




DROP TABLE IF EXISTS "transactions_status"; CREATE TABLE "transactions_status" (
"hash" bytea  NOT NULL DEFAULT '',
"time" int NOT NULL DEFAULT '0',
"type" int NOT NULL DEFAULT '0',
"wallet_id" bigint NOT NULL DEFAULT '0',
"citizen_id" bigint NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0',
"error" varchar(255) NOT NULL DEFAULT ''
);
ALTER TABLE ONLY "transactions_status" ADD CONSTRAINT transactions_status_pkey PRIMARY KEY (hash);




DROP TABLE IF EXISTS "confirmations"; CREATE TABLE "confirmations" (
"block_id" bigint  NOT NULL DEFAULT '0',
"good" int  NOT NULL DEFAULT '0',
"bad" int  NOT NULL DEFAULT '0',
"time" int  NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "confirmations" ADD CONSTRAINT confirmations_pkey PRIMARY KEY (block_id);




DROP TABLE IF EXISTS "block_chain"; CREATE TABLE "block_chain" (
"id" int NOT NULL DEFAULT '0',
"hash" bytea  NOT NULL DEFAULT '',
"data" bytea NOT NULL DEFAULT '',
"state_id" int  NOT NULL DEFAULT '0',
"wallet_id" bigint  NOT NULL DEFAULT '0',
"time" int NOT NULL DEFAULT '0',
"tx" int NOT NULL DEFAULT '0',
"cur_0l_miner_id" int NOT NULL DEFAULT '0',
"max_miner_id" int NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "block_chain" ADD CONSTRAINT block_chain_pkey PRIMARY KEY (id);




DROP SEQUENCE IF EXISTS currency_id_seq CASCADE;
CREATE SEQUENCE currency_id_seq START WITH 1;
DROP TABLE IF EXISTS "currency"; CREATE TABLE "currency" (
"id" smallint  NOT NULL  default nextval('currency_id_seq'),
"name" char(3) NOT NULL DEFAULT '',
"full_name" varchar(50) NOT NULL DEFAULT '',
"rb_id" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE currency_id_seq owned by currency.id;
ALTER TABLE ONLY "currency" ADD CONSTRAINT currency_pkey PRIMARY KEY (id);






DROP TABLE IF EXISTS "info_block"; CREATE TABLE "info_block" (
"hash" bytea  NOT NULL DEFAULT '',
"block_id" int  NOT NULL DEFAULT '0',
"state_id" int  NOT NULL DEFAULT '0',
"wallet_id" bigint  NOT NULL DEFAULT '0',
"time" int  NOT NULL DEFAULT '0',
"level" smallint  NOT NULL DEFAULT '0',
"current_version" varchar(50) NOT NULL DEFAULT '0.0.1',
"sent" smallint NOT NULL DEFAULT '0'
);




DROP TABLE IF EXISTS "log_transactions"; CREATE TABLE "log_transactions" (
"hash" bytea  NOT NULL DEFAULT '',
"time" int NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "log_transactions" ADD CONSTRAINT log_transactions_pkey PRIMARY KEY (hash);




DROP TABLE IF EXISTS "main_lock"; CREATE TABLE "main_lock" (
"lock_time" int  NOT NULL DEFAULT '0',
"script_name" varchar(100) NOT NULL DEFAULT '',
"info" text NOT NULL DEFAULT '',
"uniq" smallint NOT NULL DEFAULT '0'
);
CREATE UNIQUE INDEX main_lock_uniq ON "main_lock" USING btree (uniq);




DROP SEQUENCE IF EXISTS full_nodes_id_seq CASCADE;
CREATE SEQUENCE full_nodes_id_seq START WITH 1;
DROP TABLE IF EXISTS "full_nodes"; CREATE TABLE "full_nodes" (
"id" int NOT NULL  default nextval('full_nodes_id_seq'),
"host" varchar(100) NOT NULL DEFAULT '',
"wallet_id" bigint NOT NULL DEFAULT '0',
"state_id" int NOT NULL DEFAULT '0',
"final_delegate_wallet_id" bigint NOT NULL DEFAULT '0',
"final_delegate_state_id" bigint NOT NULL DEFAULT '0',
"rb_id" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE full_nodes_id_seq owned by full_nodes.id;
ALTER TABLE ONLY "full_nodes" ADD CONSTRAINT full_nodes_pkey PRIMARY KEY (id);




DROP SEQUENCE IF EXISTS rb_full_nodes_rb_id_seq CASCADE;
CREATE SEQUENCE rb_full_nodes_rb_id_seq START WITH 1;
DROP TABLE IF EXISTS "rb_full_nodes"; CREATE TABLE "rb_full_nodes" (
"rb_id" bigint NOT NULL  default nextval('rb_full_nodes_rb_id_seq'),
"full_nodes_wallet_json" bytea  NOT NULL DEFAULT '',
"block_id" int NOT NULL DEFAULT '0',
"prev_rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE rb_full_nodes_rb_id_seq owned by rb_full_nodes.rb_id;
ALTER TABLE ONLY "rb_full_nodes" ADD CONSTRAINT rb_full_nodes_pkey PRIMARY KEY (rb_id);



DROP SEQUENCE IF EXISTS upd_full_nodes_id_seq CASCADE;
CREATE SEQUENCE upd_full_nodes_id_seq START WITH 1;
DROP TABLE IF EXISTS "upd_full_nodes"; CREATE TABLE "upd_full_nodes" (
"id" bigint NOT NULL  default nextval('upd_full_nodes_id_seq'),
"time" int NOT NULL DEFAULT '0',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE upd_full_nodes_id_seq owned by upd_full_nodes.id;
ALTER TABLE ONLY "upd_full_nodes" ADD CONSTRAINT upd_full_nodes_pkey PRIMARY KEY (id);



DROP SEQUENCE IF EXISTS rb_upd_full_nodes_rb_id_seq CASCADE;
CREATE SEQUENCE rb_upd_full_nodes_rb_id_seq START WITH 1;
DROP TABLE IF EXISTS "rb_upd_full_nodes"; CREATE TABLE "rb_upd_full_nodes" (
"rb_id" bigint NOT NULL  default nextval('rb_upd_full_nodes_rb_id_seq'),
"time" int NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0',
"prev_rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE rb_upd_full_nodes_rb_id_seq owned by rb_upd_full_nodes.rb_id;
ALTER TABLE ONLY "rb_upd_full_nodes" ADD CONSTRAINT rb_upd_full_nodes_pkey PRIMARY KEY (rb_id);




DROP TABLE IF EXISTS "queue_blocks"; CREATE TABLE "queue_blocks" (
"hash" bytea  NOT NULL DEFAULT '',
"full_node_id" int NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "queue_blocks" ADD CONSTRAINT queue_blocks_pkey PRIMARY KEY (hash);




DROP TABLE IF EXISTS "queue_tx"; CREATE TABLE "queue_tx" (
"hash" bytea  NOT NULL DEFAULT '',
"data" bytea NOT NULL DEFAULT '',
"from_gate" int NOT NULL DEFAULT '0',
"_tmp_node_user_id" VARCHAR(255) DEFAULT ''
);
ALTER TABLE ONLY "queue_tx" ADD CONSTRAINT queue_tx_pkey PRIMARY KEY (hash);




DROP TABLE IF EXISTS "transactions"; CREATE TABLE "transactions" (
"hash" bytea  NOT NULL DEFAULT '',
"data" bytea NOT NULL DEFAULT '',
"verified" smallint NOT NULL DEFAULT '1',
"used" smallint NOT NULL DEFAULT '0',
"high_rate" smallint NOT NULL DEFAULT '0',
"for_self_use" smallint NOT NULL DEFAULT '0',
"type" smallint NOT NULL DEFAULT '0',
"wallet_id" bigint NOT NULL DEFAULT '0',
"citizen_id" bigint NOT NULL DEFAULT '0',
"third_var" int NOT NULL DEFAULT '0',
"counter" smallint NOT NULL DEFAULT '0',
"sent" smallint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "transactions" ADD CONSTRAINT transactions_pkey PRIMARY KEY (hash);




DROP TABLE IF EXISTS "dlt_wallets"; CREATE TABLE "dlt_wallets" (
"wallet_id" bigint  NOT NULL DEFAULT '0',
"public_key_0" bytea  NOT NULL DEFAULT '',
"node_public_key" bytea  NOT NULL DEFAULT '',
"last_forging_data_upd" bigint NOT NULL DEFAULT '0',
"amount" decimal(30) NOT NULL DEFAULT '0',
"host" varchar(50) NOT NULL DEFAULT '',
"address_vote" varchar(255) NOT NULL DEFAULT '',
"fuel_rate" bigint NOT NULL DEFAULT '0',
"spending_contract" varchar(100) NOT NULL DEFAULT '',
"conditions_change" text NOT NULL DEFAULT '',
"rb_id" bigint  NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "dlt_wallets" ADD CONSTRAINT dlt_wallets_pkey PRIMARY KEY (wallet_id);


DROP TABLE IF EXISTS "global_apps"; CREATE TABLE "global_apps" (
"name" varchar(100)  NOT NULL DEFAULT '',
"done" integer NOT NULL DEFAULT '0',
"blocks" text  NOT NULL DEFAULT ''
);
ALTER TABLE ONLY "global_apps" ADD CONSTRAINT "global_apps_pkey" PRIMARY KEY (name);


DROP TABLE IF EXISTS "system_recognized_states"; CREATE TABLE "system_recognized_states" (
"name" varchar(255) NOT NULL DEFAULT '',
"state_id" bigint NOT NULL DEFAULT '0',
"host" varchar(255) NOT NULL DEFAULT '',
"node_public_key" bytea  NOT NULL DEFAULT '',
"delegate_wallet_id" bigint NOT NULL DEFAULT '0',
"delegate_state_id" int NOT NULL DEFAULT '0',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "system_recognized_states" ADD CONSTRAINT system_recognized_states_pkey PRIMARY KEY (state_id);




DROP TABLE IF EXISTS "install"; CREATE TABLE "install" (
"progress" varchar(10) NOT NULL DEFAULT ''
);



DROP TABLE IF EXISTS "config"; CREATE TABLE "config" (
"my_block_id" int NOT NULL DEFAULT '0',
"dlt_wallet_id" bigint NOT NULL DEFAULT '0',
"state_id" int NOT NULL DEFAULT '0',
"citizen_id" bigint NOT NULL DEFAULT '0',
"bad_blocks" text NOT NULL DEFAULT '',
"pool_tech_works" smallint NOT NULL DEFAULT '0',
"auto_reload" int NOT NULL DEFAULT '0',
"setup_password" varchar(255)  NOT NULL DEFAULT '',
"sqlite_db_url" varchar(255)  NOT NULL DEFAULT '',
"first_load_blockchain_url" varchar(255)  NOT NULL DEFAULT '',
"first_load_blockchain"  varchar(255)  NOT NULL DEFAULT '',
"current_load_blockchain"  varchar(255)  NOT NULL DEFAULT '',
"http_host" varchar(255) NOT NULL DEFAULT '',
"auto_update" smallint NOT NULL DEFAULT '0',
"auto_update_url" varchar(255) NOT NULL DEFAULT '',
"analytics_disabled" smallint NOT NULL DEFAULT '0',
"stat_host" varchar(255) NOT NULL DEFAULT ''
);




DROP TABLE IF EXISTS "stop_daemons"; CREATE TABLE "stop_daemons" (
"stop_time" int NOT NULL DEFAULT '0'
);




DROP TABLE IF EXISTS "incorrect_tx"; CREATE TABLE "incorrect_tx" (
"hash" bytea  NOT NULL DEFAULT '',
"time" int  NOT NULL DEFAULT '0',
"err" text NOT NULL DEFAULT ''
);
ALTER TABLE ONLY "incorrect_tx" ADD CONSTRAINT incorrect_tx_pkey PRIMARY KEY (hash);




DROP SEQUENCE IF EXISTS migration_history_id_seq CASCADE;
CREATE SEQUENCE migration_history_id_seq START WITH 1;
DROP TABLE IF EXISTS "migration_history"; CREATE TABLE "migration_history" (
"id" int NOT NULL  default nextval('migration_history_id_seq'),
"version" int NOT NULL DEFAULT '0',
"date_applied" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE migration_history_id_seq owned by migration_history.id;
ALTER TABLE ONLY "migration_history" ADD CONSTRAINT migration_history_pkey PRIMARY KEY (id);




DROP TABLE IF EXISTS "dlt_wallets_buffer"; CREATE TABLE "dlt_wallets_buffer" (
"hash" bytea  NOT NULL DEFAULT '',
"del_block_id" bigint NOT NULL DEFAULT '0',
"wallet_id" bigint NOT NULL DEFAULT '0',
"amount" decimal(15,2)  NOT NULL DEFAULT '0',
"block_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "dlt_wallets_buffer" ADD CONSTRAINT dlt_wallets_buffer_pkey PRIMARY KEY (hash);




DROP SEQUENCE IF EXISTS president_id_seq CASCADE;
CREATE SEQUENCE president_id_seq START WITH 1;
DROP TABLE IF EXISTS "president"; CREATE TABLE "president" (
"id" int NOT NULL  default nextval('president_id_seq'),
"state_id" int NOT NULL DEFAULT '0',
"citizen_id" bigint NOT NULL DEFAULT '0',
"start_time" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE president_id_seq owned by president.id;
ALTER TABLE ONLY "president" ADD CONSTRAINT president_pkey PRIMARY KEY (id);




DROP SEQUENCE IF EXISTS cb_head_id_seq CASCADE;
CREATE SEQUENCE cb_head_id_seq START WITH 1;
DROP TABLE IF EXISTS "cb_head"; CREATE TABLE "cb_head" (
"id" int NOT NULL  default nextval('cb_head_id_seq'),
"state_code" varchar(2) NOT NULL DEFAULT '',
"citizen_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE cb_head_id_seq owned by cb_head.id;
ALTER TABLE ONLY "cb_head" ADD CONSTRAINT cb_head_pkey PRIMARY KEY (id);






DROP SEQUENCE IF EXISTS rollback_tx_id_seq CASCADE;
CREATE SEQUENCE rollback_tx_id_seq START WITH 1;
DROP TABLE IF EXISTS "rollback_tx"; CREATE TABLE "rollback_tx" (
"id" bigint NOT NULL  default nextval('rollback_tx_id_seq'),
"block_id" bigint NOT NULL DEFAULT '0',
"tx_hash" bytea  NOT NULL DEFAULT '',
"table_name" varchar(255) NOT NULL DEFAULT '',
"table_id" varchar(255) NOT NULL DEFAULT ''
);
ALTER SEQUENCE rollback_tx_id_seq owned by rollback_tx.id;
ALTER TABLE ONLY "rollback_tx" ADD CONSTRAINT rollback_tx_pkey PRIMARY KEY (id);




DROP SEQUENCE IF EXISTS upd_full_nodes_id_seq CASCADE;
CREATE SEQUENCE upd_full_nodes_id_seq START WITH 1;
DROP TABLE IF EXISTS "upd_full_nodes"; CREATE TABLE "upd_full_nodes" (
"id" bigint NOT NULL  default nextval('upd_full_nodes_id_seq'),
"time" int NOT NULL DEFAULT '0',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE upd_full_nodes_id_seq owned by upd_full_nodes.id;
ALTER TABLE ONLY "upd_full_nodes" ADD CONSTRAINT upd_full_nodes_pkey PRIMARY KEY (id);




DROP SEQUENCE IF EXISTS rb_upd_full_nodes_rb_id_seq CASCADE;
CREATE SEQUENCE rb_upd_full_nodes_rb_id_seq START WITH 1;
DROP TABLE IF EXISTS "rb_upd_full_nodes"; CREATE TABLE "rb_upd_full_nodes" (
"rb_id" bigint NOT NULL  default nextval('rb_upd_full_nodes_rb_id_seq'),
"time" int NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0',
"prev_rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE rb_upd_full_nodes_rb_id_seq owned by rb_upd_full_nodes.rb_id;
ALTER TABLE ONLY "rb_upd_full_nodes" ADD CONSTRAINT rb_upd_full_nodes_pkey PRIMARY KEY (rb_id);




DROP SEQUENCE IF EXISTS rollback_rb_id_seq CASCADE;
CREATE SEQUENCE rollback_rb_id_seq START WITH 1;
DROP TABLE IF EXISTS "rollback"; CREATE TABLE "rollback" (
"rb_id" bigint NOT NULL  default nextval('rollback_rb_id_seq'),
"block_id" bigint NOT NULL DEFAULT '0',
"data" text NOT NULL DEFAULT ''
);
ALTER SEQUENCE rollback_rb_id_seq owned by rollback.rb_id;
ALTER TABLE ONLY "rollback" ADD CONSTRAINT rollback_pkey PRIMARY KEY (rb_id);


DROP TABLE IF EXISTS "system_parameters";
CREATE TABLE "system_parameters" (
"name" varchar(255)  NOT NULL DEFAULT '',
"value" jsonb,
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "system_parameters" ADD CONSTRAINT system_parameters_pkey PRIMARY KEY ("name");


CREATE TABLE "global_menu" (
"name" varchar(255)  NOT NULL DEFAULT '',
"value" text  NOT NULL DEFAULT '',
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "global_menu" ADD CONSTRAINT global_menu_pkey PRIMARY KEY (name);


CREATE TABLE "global_pages" (
"name" varchar(255)  NOT NULL DEFAULT '',
"value" text  NOT NULL DEFAULT '',
"menu" varchar(255)  NOT NULL DEFAULT '',
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "global_pages" ADD CONSTRAINT global_pages_pkey PRIMARY KEY (name);

CREATE TABLE "global_signatures" (
"name" varchar(100)  NOT NULL DEFAULT '',
"value" jsonb,
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "global_signatures" ADD CONSTRAINT global_signatures_pkey PRIMARY KEY (name);

DROP SEQUENCE IF EXISTS global_smart_contracts_id_seq CASCADE;
CREATE SEQUENCE global_smart_contracts_id_seq START WITH 1;
CREATE TABLE "global_smart_contracts" (
"id" bigint NOT NULL  default nextval('global_smart_contracts_id_seq'),
"name" varchar(100)  NOT NULL DEFAULT '',
"value" bytea  NOT NULL DEFAULT '',
"wallet_id" bigint  NOT NULL DEFAULT '0',
"active" character(1) NOT NULL DEFAULT '0',
"conditions" text  NOT NULL DEFAULT '',
"variables" bytea  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE "global_smart_contracts_id_seq" owned by "global_smart_contracts".id;
ALTER TABLE ONLY "global_smart_contracts" ADD CONSTRAINT global_smart_contracts_pkey PRIMARY KEY (id);
CREATE INDEX global_smart_contracts_index_name ON "global_smart_contracts" (name);

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('DLTTransfer',
  'contract DLTTransfer {
    data {
        Recipient string
        Amount    string
        Comment     string "optional"
    }

    conditions {
        $recipient = AddressToId($Recipient)
        if $recipient == 0 {
            error Sprintf("Recipient %s is invalid", $Recipient)
        }
        var total money
        $amount = Money($Amount) 
        if $amount == 0 {
            error "Amount is zero"
        }
        total = Money(DBStringExt(`dlt_wallets`, `amount`, $wallet, "wallet_id"))
        if $amount >= total {
            error Sprintf("Money is not enough %v < %v",total, $amount)
        }
    }

    action {
        DBUpdateExt(`dlt_wallets`, "wallet_id", $wallet,`-amount`, $amount)
        DBUpdateExt(`dlt_wallets`, "wallet_id", $recipient,`+amount`, $amount)
        DBInsert(`dlt_transactions`, `sender_wallet_id, recipient_wallet_id, amount, comment, time, block_id`, $wallet, $recipient, $amount, $Comment, $block_time, $block)
    }
}', '1','ContractAccess("@0UpdateDLTTranfer")');
INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('DLTChangeHostVote',
  'contract DLTChangeHostVote {
    data {
        Host        string
	AddressVote string
	FuelRate    string
    }

    conditions {
        var lastUpd int
	    lastUpd = DBIntExt(`dlt_wallets`, `last_forging_data_upd`, $wallet, `wallet_id`)
	    if $time-lastUpd < 600 {
		    warning "txTime - lastForgingDataUpd < 600 sec"
	    }
    }

    action {
        DBUpdateExt(`dlt_wallets`, "wallet_id", $wallet,`host,address_vote,fuel_rate,last_forging_data_upd`, $Host, $AddressVote, $FuelRate, $block_time)
    }
}', '1','ContractAccess("@0UpdateDLTChangeHostVote")');
INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('NewMenu',
  'contract NewMenu {
    data {
        Global     int
    	Name       string
    	Value      string
    	Conditions string
    }

    conditions {
        var state int
        if $Global == 0 {
            state = $state
        }
        ValidateCondition($Conditions,state)
    }

    action {
        DBInsert(PrefixTable(`menu`, $Global), `name,value,conditions`, $Name, $Value, $Conditions )
    }
}', '1','ContractAccess("@0UpdateNewMenu")');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('EditMenu',
  'contract EditMenu {
    data {
        Global     int
    	Name       string
    	Value      string
    	Conditions string
    }

    conditions {
        var state int
        
        EvalCondition(PrefixTable(`menu`,$Global), $Name, `conditions`)
        if $Global == 0 {
            state = $state
        }
        ValidateCondition($Conditions,state)
    }

    action {
        DBUpdateExt(PrefixTable(`menu`, $Global), `name`, $Name, `value,conditions`, $Value, $Conditions )
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('AppendMenu',
  'contract AppendMenu {
    data {
        Global     int
    	Name       string
    	Value      string
    }

    conditions {
        EvalCondition(PrefixTable(`menu`,$Global), $Name, `conditions`)
    }

    action {
        var table string
        table = PrefixTable(`menu`, $Global)
        DBUpdateExt(table, `name`, $Name, `value`, DBStringExt(table, `value`, $Name, `name`) + "\r\n" + $Value )
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('NewPage',
  'contract NewPage {
    data {
        Global     int
    	Name       string
    	Value      string
    	Menu       string
    	Conditions string
    }

    conditions {
        var state int
        if $Global == 0 {
            state = $state
        }
        ValidateCondition($Conditions,$state)
       	if HasPrefix($Name, `sys-`) || HasPrefix($Name, `app-`) {
	    	error `The name cannot start with sys- or app-`
	    }
    }

    action {
        DBInsert(PrefixTable(`pages`, $Global), `name,value,menu,conditions`, $Name, $Value, $Menu, $Conditions )
    }
}', '1','ContractConditions(`MainCondition`)');


INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('EditPage',
  'contract EditPage {
    data {
        Global     int
    	Name       string
    	Value      string
    	Menu      string
    	Conditions string
    }

    conditions {
        var state int
        
        EvalCondition(PrefixTable(`pages`,$Global), $Name, `conditions`)
        if $Global == 0 {
            state = $state
        }
        ValidateCondition($Conditions,state)
    }

    action {
        DBUpdateExt(PrefixTable(`pages`, $Global), `name`, $Name, `value,menu,conditions`, $Value, $Menu, $Conditions )
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('AppendPage',
  'contract AppendPage {
    data {
        Global     int
    	Name       string
    	Value      string
    }

    conditions {
        EvalCondition(PrefixTable(`pages`,$Global), $Name, `conditions`)
    }

    action {
        var value, table string
        table = PrefixTable(`pages`, $Global)
        value = DBStringExt(table, `value`, $Name, `name`)
       	if Contains(value, `PageEnd:`) {
		   value = Replace(value, "PageEnd:", $Value) + "\r\nPageEnd:"
    	} else {
    		value = value + "\r\n" + $Value
    	}
        DBUpdateExt(table, `name`, $Name, `value`,  value )
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('NewStateParameters',
  'contract NewStateParameters {
    data {
        Name string
        Value string
        Conditions string
    }
    conditions {
        ValidateCondition($Conditions, $state)
    }
    action {
        DBInsert(Table(`state_parameters`), `name,value,conditions`, $Name, $Value, $Conditions )
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('EditStateParameters',
  'contract EditStateParameters {
    data {
        Name string
        Value string
        Conditions string
    }
    conditions {
        EvalCondition(Table(`state_parameters`), $Name, `conditions`)
        ValidateCondition($Conditions, $state)
        var exist int
       	if $Name == `state_name` {
    		exist = FindEcosystem($Value)
    		if exist > 0 && exist != $state {
    			warning Sprintf(`State %s already exists`, $Value)
    		}
    	}
    }
    action {
        DBUpdateExt(Table(`state_parameters`), `name`, $Name, `value,conditions`, $Value, $Conditions )
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('NewLang',
  'contract NewLang {
    data {
        Name  string
        Trans string
    }

    conditions {
        EvalCondition(Table(`state_parameters`), `changing_language`, `value`)
        var exist string
        exist = DBStringExt(Table(`languages`), `name`, $Name, `name`)
        if exist {
            error Sprintf("The language resource %s already exists", $Name)
        }
    }

    action {
        DBInsert(Table(`languages`), `name,res`, $Name, $Trans )
        UpdateLang($Name, $Trans)
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('EditLang',
  'contract EditLang {
    data {
        Name  string
        Trans string
    }

    conditions {
        EvalCondition(Table(`state_parameters`), `changing_language`, `value`)
    }

    action {
        DBUpdateExt(Table(`languages`), `name`, $Name, `res`, $Trans )
        UpdateLang($Name, $Trans)
    }
}', '1','ContractConditions(`MainCondition`)');

INSERT INTO global_smart_contracts ("name", "value", "active", "conditions") VALUES ('UpdFullNodes',
  'contract UpdFullNodes {
    data {

    }

    conditions {
        var prev int
        var nodekey bytes
        prev = DBInt(`upd_full_nodes`, `time`, 1)
	    if $time-prev < SysParamInt(`upd_full_nodes_period`) {
		    warning Sprintf("txTime - upd_full_nodes < UPD_FULL_NODES_PERIOD")
	    }
	    nodekey = bytes(DBStringExt(`dlt_wallets`, `node_public_key`, $wallet, `wallet_id`))
	    if !nodekey {
	        error `len(node_key) == 0`
	    }
    }

    action {
        var list array
        list = DBGetList("dlt_wallets", "address_vote", 0, SysParamInt(`number_of_dlt_nodes`), "sum(amount) DESC", "address_vote != ? and amount > ? GROUP BY address_vote", ``, `10000000000000000000000`)
        var i int
        var out string
        while i<Len(list) {
            var row, item map
            item = list[i]
            row = DBRowExt(`dlt_wallets`, `host, wallet_id`, item[`address_vote`], `wallet_id`)
            if i > 0 {
                out = out + `,`
            }
            out = out + Sprintf(`[%q,%q]`, row[`host`],row[`wallet_id`])
            i = i+1
        }
        UpdateSysParam(`full_nodes`, `[`+out+`]`, ``)
    }
}', '1','ContractAccess("@0UpdateUpdFullNodes")');

CREATE TABLE "global_tables" (
"name" varchar(255)  NOT NULL DEFAULT '',
"columns_and_permissions" jsonb,
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "global_tables" ADD CONSTRAINT global_tables_pkey PRIMARY KEY (name);

INSERT INTO global_tables ("name", "columns_and_permissions", "conditions") VALUES ('dlt_wallets', 
        '{"insert": "ContractAccess(\"@0NewWallet\")", "update": {"*": "false","amount": "ContractAccess(\"@0DLTTransfer\")",
        "host": "ContractAccess(\"@0DLTChangeHostVote\")","address_vote": "ContractAccess(\"@0DLTChangeHostVote\")",
        "fuel_rate": "ContractAccess(\"@0DLTChangeHostVote\")","last_forging_data_upd": "ContractAccess(\"@0DLTChangeHostVote\")"
        }, 
        "new_column": "ContractAccess(\"@0NewWalletColumn\")", "general_update": "ContractAccess(\"@0UpdateDltWallet\")"}',
        'false');
INSERT INTO global_tables ("name", "columns_and_permissions", "conditions") VALUES ('dlt_transactions', 
        '{"insert": "ContractAccess(\"@0DLTTransfer\")", "update": {"*": "false"}, "new_column": "ContractAccess(\"@0NewDLTColumn\")", "general_update": "ContractAccess(\"@0UpdateDltTransactions\")"}',
        'false');
INSERT INTO global_tables ("name", "columns_and_permissions", "conditions") VALUES ('global_menu', 
        '{"insert": "ContractAccess(\"@0NewMenu\")", "update": {"*": "ContractAccess(\"@0EditMenu\", \"@0AppendMenu\")"}, "new_column": "ContractAccess(\"@0NewMenuColumn\")", "general_update": "ContractAccess(\"@0UpdateNewMenu\")"}',
        'false');
INSERT INTO global_tables ("name", "columns_and_permissions", "conditions") VALUES ('global_pages', 
        '{"insert": "ContractAccess(\"@0NewPage\")", "update": {"*": "ContractAccess(\"@0EditPage\", \"@0AppendPage\")"}, "new_column": "ContractAccess(\"@0NewPageColumn\")", "general_update": "ContractAccess(\"@0UpdateNewPage\")"}',
        'false');

DROP SEQUENCE IF EXISTS system_states_id_seq CASCADE;
CREATE SEQUENCE system_states_id_seq START WITH 1;
DROP TABLE IF EXISTS "system_states"; CREATE TABLE "system_states" (
"id" bigint NOT NULL default nextval('system_states_id_seq'),
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE system_states_id_seq owned by system_states.id;
ALTER TABLE ONLY "system_states" ADD CONSTRAINT system_states_pkey PRIMARY KEY (id);


INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('number_of_dlt_nodes', '100', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('fuel_rate', '1000000000000000', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('op_price', '{"edit_contract":100, "edit_column":100, "edit_menu":100, "edit_page":100, "edit_state_parameters":100,"edit_table":100,"new_column":100,"new_contract":100,"new_menu":100,"new_state_parameters":100,"new_page":100, "insert":100, "update":200, "change_node": 100, "edit_lang": 10, "edit_sign": 10, "change_host_vote": 100, "new_column":500, "new_lang": 10, "new_sign": 10, "new_column_w_index":1000, "add_table":5000,  "select":10, "new_state":1000000, "dlt_transfer":1, "system_restore_access_active":10000, "system_restore_access_close":100, "system_restore_access_request":100, "system_restore_access":100,"activate_cost":100}', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('gaps_between_blocks', '3', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('blockchain_url', '"https://raw.githubusercontent.com/egaas-blockchain/egaas-blockchain.github.io/master/testnet_blockchain"', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('max_block_size', '67108864', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('max_tx_size', '33554432', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('max_tx_count', '100000', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('max_columns', '50', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('max_indexes', '10', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('max_block_user_tx', '100', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('upd_full_nodes_period', '3600', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('recovery_address', '8275283526439353759', 'ContractAccess("@0SysPar")');
INSERT INTO system_parameters ("name", "value", "conditions") VALUES ('commission_wallet', '8275283526439353759', 'ContractAccess("@0SysPar")');


DROP SEQUENCE IF EXISTS system_restore_access_id_seq CASCADE;
CREATE SEQUENCE system_restore_access_id_seq START WITH 1;
DROP TABLE IF EXISTS "system_restore_access"; CREATE TABLE "system_restore_access" (
"id" bigint NOT NULL default nextval('system_restore_access_id_seq'),
"citizen_id" bigint NOT NULL DEFAULT '0',
"state_id" bigint NOT NULL DEFAULT '0',
"active" bigint NOT NULL DEFAULT '0',
"time" bigint NOT NULL DEFAULT '0',
"close" bigint NOT NULL DEFAULT '0',
"secret" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE system_restore_access_id_seq owned by system_restore_access.id;
ALTER TABLE ONLY "system_restore_access" ADD CONSTRAINT system_restore_access_pkey PRIMARY KEY (id);

DROP PROCEDURE LOTTERY_USER;

DELIMITER //
CREATE PROCEDURE LOTTERY_USER ( IN p_uid INT, OUT ret VARCHAR(32) )
BEGIN

# パラメータ p_uid
# 応募者のUID

# 戻り値 ret（string）
# 応募済み=2003 はずれ=1 不明UID=2002 当選=トークン

# ローカル変数宣言
DECLARE l_is_exist INT;         # UID検査フラグ
DECLARE l_this_month INT;       # 抽選月
DECLARE l_is_entry INT;         # 応募済みフラグ
DECLARE l_is_win INT;           # 当選フラグ
DECLARE l_numbered_ticket INT;  # 整理券番号
DECLARE l_lots_id INT;          # 現在抽選中のlots_id
DECLARE l_winning_token VARCHAR(32);        # 当選者向けトークン
DECLARE l_is_entry_lots INT;    # lots_idが存在するか

# 変数初期値
SET l_this_month = DATE_FORMAT(NOW(), '%Y%m');
SET l_is_entry = 0;
SET l_is_win = 0;
SET l_numbered_ticket = 0;
SET ret = '2003';
SET l_lots_id = 0;
SET l_winning_token = '';
SET l_is_exist = 0;
SET l_is_entry_lots = 0;

# 応募者のUIDが実在するか
SELECT COUNT(uid) INTO l_is_exist
FROM user_master WHERE uid = p_uid;

# UIDが不明なら2を返して終了
IF l_is_exist = 0 THEN

    SET ret = '2001';
    
ELSE

    # 現在抽選中のlots_idを取得
    SELECT COUNT(lots_id),lots_id INTO l_is_entry_lots, l_lots_id
    FROM lots_master WHERE lots_month = l_this_month AND lots_deadline >= NOW() AND open_lots <= NOW();

    # 応募済みか
    SELECT COUNT(uid) INTO l_is_entry
    FROM entry_lots
    WHERE lots_id = l_lots_id 
    AND uid = p_uid;
    
    # lots_idが設定されている
    IF l_is_entry_lots = 1 THEN

        # 未応募
        IF l_is_entry = 0 THEN
        
        # トランザクション設定
        SET AUTOCOMMIT = 0;
        SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

            # トランザクション開始
            START TRANSACTION;

                # 整理番号の最後尾取得 未発行であれば0を設定
                SELECT IFNULL(MAX(numbered_ticket), 0) INTO l_numbered_ticket
                FROM entry_lots WHERE lots_id = l_lots_id GROUP BY lots_id;
                
                # 整理番号発番
                SET l_numbered_ticket = l_numbered_ticket + 1;

                # 整理券発行
                INSERT INTO entry_lots (lots_id, uid, numbered_ticket, created)
                VALUES (l_lots_id, p_uid, l_numbered_ticket, NOW());

                # 当選しているか
                SELECT COUNT(winning_number) INTO l_is_win
                FROM winning_number
                WHERE winning_number = l_numbered_ticket AND lots_id = l_lots_id;

                IF l_is_win = 1 THEN
                    # 当選者テーブルに登録
                    INSERT INTO present_to (lots_id, uid, created) VALUES (l_lots_id, p_uid, NOW());
                    
                    # 当選者パスワードを返す
                    SELECT winning_token INTO ret
                    FROM winning_number
                    WHERE lots_id = l_lots_id AND winning_number = l_numbered_ticket;
                ELSE
                    # はずれを返す
                    SET ret = '1';
                END IF;
                    
            COMMIT;
            # トランザクション終了
        END IF;
    ELSE
        # lots_idが設定されていない
        SET ret = '2002';
    END IF;
END IF;
END
//
DELIMITER ;
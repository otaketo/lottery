<?php
/*
* DB接続
*/
require_once (__DIR__ . '/CommonDao.php');

class LotteryDao Extends CommonDao
{

    public function __construct()
    {
        parent::__construct();
    }

    // ストアドプロシージャLOTTERY_USERを実行する
	// @return 1=はずれ 英数字32文字のトークン=当選 その他=エラー
	public function entryLots($uid)
    {
        try {
    		$this->sql = $this->pdo->prepare('CALL LOTTERY_USER(:uid, @ret)');
            $this->sql->bindParam(':uid', $uid, PDO::PARAM_STR);
    		$this->executeSql();
    		$this->sql = $this->pdo->query('SELECT @ret');
    		$result = $this->sql->fetch(PDO::FETCH_NUM, 0);
            return $result[0];
        } catch (LotteryException $e) {
            $e->showErrorCode();
        }
	}
}

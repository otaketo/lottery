<?php
/*
* DB接続共通クラス
*/
require_once (__DIR__ . '/../config/SiteConfig.php');

class CommonDao
{

    protected $pdo;   // PDOインスタンス
    protected $sql;   // プリペアドステートメント

    public function __construct()
    {
        try {
            $this->dbConnection();
        } catch (LotteryException $e) {
            $e->showErrorCode();
        }
    }

	// DB接続
    private function dbConnection()
    {
        try {
    		switch ($_SERVER['SERVER_NAME']) {
    			case SiteConfig::STAGING_HOST :
    				// ステージング
    				$dsn = 'mysql:dbname=lottery;charset=utf8;host=test.db.lottery.jp';
    				break;
    			case SiteConfig::PRODUCT_HOST :
    				// 本番
    				$dsn = 'mysql:dbname=lottery;charset=utf8;host=db.lottery.jp';
    				break;
                default :
                    // ローカル
                    $dsn = 'mysql:dbname=lottery;charset=utf8;host=localhost';
    		}
    		$user = 'root';
    		$password = 'root';
            $this->pdo = new PDO( $dsn, $user, $password, array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
        } catch (PDOException $e) {
            throw new LotteryException(3306, $e);
        }
    }

    // SQLを実行し、PDOExceptionを受け取ったらLotteryExceptionを投げる
    protected function executeSql($data = NULL)
    {
        try {
            $this->sql->execute($data);
        } catch (PDOException $e) {
            throw new LotteryException(3307, $e);
        }
    }
}

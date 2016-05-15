<?php
/*
* エラー処理
*/

class LotteryException Extends Exception
{
    private $catches; // catchしたExceptionのインスタンス

    public function __construct($error_code = 0, $catches = NULL)
    {
        parent::__construct('例外が発生しました', $error_code);
        $this->catches = $catches;
    }

    // エラーコードを返す
    public function showErrorCode()
    {
        if ($this->catches !== NULL) {
            @$this->writePdoErrorLog($this->catches);
        }
        header('Content-Type: application/json; Charset=UTF-8');
        echo json_encode(array('error' => $this->code));
        exit;
    }

    private function writePdoErrorLog($catches)
    {
        date_default_timezone_set('Asia/Tokyo');
        $log_dir = $_SERVER['DOCUMENT_ROOT']. '/../data/lottery/log/php';
        if (!is_dir($log_dir)) {
			mkdir($log_dir, 0755, true);
		}
        $log_file = $log_dir. '/pdo_error.log';
        $log_string = '['.date('Y-m-d H:i:s') . '] ' . $this->catches->__toString() . "\n";
        @file_put_contents($log_file, $log_string, FILE_APPEND | LOCK_EX);
    }
}

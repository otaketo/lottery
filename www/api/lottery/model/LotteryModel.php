<?php
/*
* 抽選model
*/

require_once (__DIR__ . '/../dao/LotteryDao.php');

class LotteryModel
{
    private $dao;

    public function __construct()
    {
        $this->dao = new LotteryDao();
    }

    // 抽選
    public function lotterySystem($uid)
    {
        $is_lucky = $this->dao->entryLots($uid);
        return $is_lucky;
    }

    // 結果をJSONで返す
    public function responseJson($string)
    {
        header('Content-Type: application/json; Charset=UTF-8');
        echo json_encode(array('result' => $string));
        exit;
    }

    public function sessionStart()
    {
        session_set_cookie_params(0, '/', '', false, true);
        session_name('S1J0lJdDi');
        session_start();
    }
}

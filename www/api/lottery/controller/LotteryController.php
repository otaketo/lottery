<?php
/*
* 抽選controller
*/

require_once (__DIR__ . '/../module/LotteryException.php');
require_once (__DIR__ . '/../model/LotteryModel.php');

class LotteryController
{

    private $model;

    public function __construct()
    {
        $this->model = new LotteryModel();
        $this->model->sessionStart();
    }

    public function lotteryAction()
    {

        try {

            // UIDチェック
            if (empty($_SESSION['uid'])) {
                throw new LotteryException(1001);
            };

            $uid = $_SESSION['uid'];

            // 抽選
            $response = $this->model->lotterySystem($uid);

            // 抽選結果を表示
            $this->model->responseJson($response);

        } catch (LotteryException $e) {
            $e->showErrorCode();
        }
    }
}

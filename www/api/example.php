<?php
require_once (__DIR__ . '/lottery/controller/LotteryController.php');

$ctrl = new LotteryController();
$_SESSION['uid'] = 1;
$ctrl->lotteryAction();

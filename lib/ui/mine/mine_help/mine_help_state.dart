class MineHelpState {
  int helpIndex = 0;
  int currentIndex = 0;
  List title = [
    "全部","会员","充值","账号","认证",
  ];

  List helpList = [
    {
      "title":"充值后可以退款吗",
      "type":"2",
    },
    {
      "title":"充值未到账怎么办",
      "type":"2",
    },
    {
      "title":"扣费规则",
      "type":"2",
    },
    {
      "title":"账号怎么注销",
      "type":"3",
    },
    {
      "title":"如何注册账号",
      "type":"3",
    },
    {
      "title":"账号绑定第三方账号",
      "type":"3",
    },
    {
      "title":"扣款后未开通会员怎么办",
      "type":"1",
    },
    {
      "title":"开错会员怎么办",
      "type":"1",
    },
    {
      "title":"使用手机号登录不了",
      "type":"3",
    },
    {
      "title":"忘记密码怎么办",
      "type":"4",
    },
    {
      "title":"注册手机号码不再使用怎么办",
      "type":"4",
    },
  ];

  //筛选后的数据
  List filtrateData = [];
}

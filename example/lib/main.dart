import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_h5pay/flutter_h5pay.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('H5Pay'),
      ),
      body: Center(
        child: H5PayWidget(
          refererScheme: getrefererScheme(),
          builder: (ctx, controller) {
            return FlatButton(
                onPressed: () {
                  controller.pay(getAliPayUrl(), jumpPayResultCallback: (p) {
                    print("支付跳转结果$p");
                  });
                },
                child: Text("立即支付"));
          },
        ),
      ),
    ));
  }

  String getrefererScheme() {
    if (Platform.isAndroid) {
      return "http://xxx.xxx.com";
    }
    if (Platform.isIOS) {
      return "xxx.xxx.com://";
    }
  }

  ///此处为对应平台的支付链接样例,具体从个自服务器上获取支付的h5链接
  String getAliPayUrl() {
    return "https://openapi.alipay.com/gateway.do?alipay_sdkxxxxx";
  }

  String gewWXPayUrl() {
    return "https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=xxx&package=xxx";
  }
}

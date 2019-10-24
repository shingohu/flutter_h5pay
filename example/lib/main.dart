import 'package:flutter/material.dart';
import 'package:flutter_h5pay/h5pay.dart';

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
          refererScheme: "http://www.xx",
          builder: (ctx, controller) {
            return FlatButton(
                onPressed: () {
                  controller.pay(getPayUrl(), jumpPayResultCallback: (p) {
                    print("支付跳转结果$p");
                  });
                },
                child: Text("立即支付"));
          },
        ),
      ),
    ));
  }

  ///从服务器上获取支付的h5链接
  String getPayUrl() {
    return "http://www.baidu.com";
  }
}

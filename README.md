# Flutter_h5pay
### A Flutter plugin for h5pay(Support WeChat and Alipay)







## Usage

Add `flutter_h5pay` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).
For Example
```
dependencies:
  flutter_h5pay:
    git:
      url: https://github.com/shingohu/flutter_h5pay.git
```

```
import 'package:flutter_h5pay/h5pay.dart';


//wrap you widget with H5PayWidget
//call the pay method to invoke the payment app

H5PayWidget(
          refererScheme: "www.xx.com://",
          builder: (ctx, controller) {
            return FlatButton(
                onPressed: () {
                  controller.pay(getPayUrl(), jumpPayResultCallback: (p) {
                    print("jump pay app result ->$p");
                  });
                },
                child: Text("pay"));
          },
        )


```


### iOS
Opt-in to the embedded views preview by adding a boolean property to the app's `Info.plist` file
with the key `io.flutter.embedded_views_preview` and the value `YES`.

When payment completed or cancelled,on IOS, if need to return to the App,you must add target URL Types into the `Info.plist` file。
For exmalpe.If you [referer](https://pay.weixin.qq.com/wiki/doc/api/H5.php?chapter=15_4 "referer")(申请H5支付时的授权域名) is `http://www.xx.com` ，In Android you can set this referer,but in ios you should set like this `www.xx.com:\\`，and add a URL Schemes of  `www.xx.com` into the `Info.plist` file.Please refer to this [article](https://juejin.im/post/5bc83676e51d450e4369b526 "article") for more details 










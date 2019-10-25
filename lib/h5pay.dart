import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef void JumpPayResultCallback(JumpPayResult result);
typedef Widget H5PayWidgetBuilder(
  BuildContext context,
  H5PayController controller,
);

enum PayStatus {
  IDEL,
  LOADING,
  TIMEOUT,
  SUCCESS,
  FAIL,
}

enum JumpPayResult {
  ///仅仅表示跳转成功,支付状态需要自己查询服务器
  SUCCESS,

  ///1 可能不是支付链接或者参数不正确
  ///2 微信支付链接超时,链接失效
  ///3 IOS上第一次需要授权,不点击的情况下不会触发跳转成功或者失败
  TIMEOUT,

  ///有可能没有安装微信或者支付宝的app
  ///IOS上可能点了不允许打开微信或者支付宝
  FAIL,
}

abstract class H5PayController {
  void pay(String payUrl, {JumpPayResultCallback jumpPayResultCallback});
}

class H5PayWidget extends StatefulWidget {
  /// The Referer URL
  /// 微信支付必须要携带此参数用于微信支付认证
  /// 可用于支付app返回到调用方app
  final String refererScheme;

  ///支付超时设置 默认8S
  final Duration timeout;

  final H5PayWidgetBuilder builder;

  /// Create a widget for pay
  H5PayWidget(
      {Key key,
      @required this.refererScheme,
      @required this.builder,
      this.timeout = const Duration(seconds: 8)})
      : assert(refererScheme != null, "refererScheme should not null"),
        assert(builder != null, "builder should not null"),
        super(key: key);

  @override
  _H5PayWidgetState createState() => _H5PayWidgetState();
}

class _H5PayWidgetState extends State<H5PayWidget> implements H5PayController {
  String _refererScheme;
  WebViewController _controller;
  JumpPayResultCallback _jumpPayResultCallback;

  PayStatus _payStatus = PayStatus.IDEL;

  bool _isDispose = false;

  Duration _timeoutDuration;

  @override
  void initState() {
    this._refererScheme = widget.refererScheme;
    this._timeoutDuration = widget.timeout ?? Duration(seconds: 8);
    super.initState();
  }

  @override
  void didUpdateWidget(H5PayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refererScheme != widget.refererScheme) {
      this._refererScheme = widget.refererScheme;
    }
    if (oldWidget.timeout != widget.timeout) {
      this._timeoutDuration = widget.timeout;
    }
  }

  _timeout() {
    Future.delayed(_timeoutDuration, () {
      if (_payStatus == PayStatus.LOADING && !_isDispose) {
        _payStatus = PayStatus.TIMEOUT;
        _jumpPayResultCallback?.call(JumpPayResult.TIMEOUT);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: true,
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: _onWebViewCreated,
            navigationDelegate: _navigationDelegate,
          ),
        ),
        widget.builder != null ? widget.builder(context, this) : Container()
      ],
    );
  }

  Map<String, String> _headers() {
    return {
      "referer": _refererScheme,
    };
  }

  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }

  ///只执行了一遍,update 也不会更新
  _onWebViewCreated(WebViewController controller) {
    this._controller = controller;
  }

  NavigationDecision _navigationDelegate(NavigationRequest request) {
    String url = Uri.decodeFull(request.url);
    if (url.startsWith("weixin://") ||
        url.startsWith("alipays://") ||
        url.startsWith("alipay://")) {
      if (Platform.isIOS &&
          (url.startsWith("alipays://") || url.startsWith("alipay://")) &&
          _refererScheme != null) {
        url = url.replaceAll(':"alipays', ':"' + _refererScheme);
      }
      url = Uri.encodeFull(url);

      if (_isDispose || _payStatus != PayStatus.LOADING) {
      } else {
        if (Platform.isIOS) {
          launch(url).then((can) {
            _payStatus = can ? PayStatus.SUCCESS : PayStatus.FAIL;
            _jumpPayResultCallback
                ?.call(can ? JumpPayResult.SUCCESS : JumpPayResult.FAIL);
          });
        } else if (Platform.isAndroid) {
          canLaunch(url).then((can) {
            if (can) {
              launch(url);
            }
            _payStatus = can ? PayStatus.SUCCESS : PayStatus.FAIL;
            _jumpPayResultCallback
                ?.call(can ? JumpPayResult.SUCCESS : JumpPayResult.FAIL);
          });
        }
      }
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  void pay(String url,
      {JumpPayResultCallback jumpPayResultCallback, String refererScheme}) {
    this._jumpPayResultCallback = jumpPayResultCallback;
    if (refererScheme != null) {
      this._refererScheme = refererScheme;
    }
    if (url != null && _controller != null) {
      _payStatus = PayStatus.LOADING;
      _timeout();
      _controller.loadUrl(url, headers: _headers());
    } else {
      _payStatus = PayStatus.FAIL;
      _jumpPayResultCallback?.call(JumpPayResult.FAIL);
    }
  }
}

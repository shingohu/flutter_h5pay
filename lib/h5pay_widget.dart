import 'dart:io';

import 'package:flutter/cupertino.dart';




class H5PayWidget extends StatelessWidget{

  final String _viewType = "sh/h5pay";
  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid){
      return _androidView();
    }else if(Platform.isIOS){
      return _iosView();
    }
    return Container();
  }


  Widget _androidView(){
    return Offstage(offstage: true,child: AndroidView(viewType:_viewType,onPlatformViewCreated:_onPlatformViewCreated , ),);
  }

  Widget _iosView(){
    return Offstage(offstage: true,child: UiKitView(viewType:_viewType ,onPlatformViewCreated:_onPlatformViewCreated ,),);
  }

  _onPlatformViewCreated(int pvId){

  }

}
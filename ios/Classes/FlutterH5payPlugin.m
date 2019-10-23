#import "FlutterH5payPlugin.h"
#import <flutter_h5pay/flutter_h5pay-Swift.h>

@implementation FlutterH5payPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterH5payPlugin registerWithRegistrar:registrar];
}
@end

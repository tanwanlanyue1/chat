#import "ZegoUikitPlugin.h"

#import <UIKit/UIKit.h>

@implementation ZegoUikitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zego_uikit_plugin"
            binaryMessenger:[registrar messenger]];
  ZegoUikitPlugin* instance = [[ZegoUikitPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"isLockScreen" isEqualToString:call.method]) {
        result(@([UIScreen mainScreen].brightness == 0.0));
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end

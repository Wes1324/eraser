#import "EraserPlugin.h"
#if __has_include(<eraser/eraser-Swift.h>)
#import <eraser/eraser-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "eraser-Swift.h"
#endif

@implementation EraserPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEraserPlugin registerWithRegistrar:registrar];
}
@end

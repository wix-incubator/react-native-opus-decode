#import "OpusDecode.h"
#import "decoder.h"

@implementation OpusDecode

RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(decodeFromUri,
                 withSourceFile:(nonnull NSString*)sourceFile
                 withSourceFile:(nonnull NSString*)destFile
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    //    NSString *result = @([a floatValue] * [b floatValue]);
    //    NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"File.ogg"];
    const char *cfilename=[sourceFile UTF8String];

    //     NSString *str_out = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"File.wav"];
    //     const char *cfilename_out=[str_out UTF8String];
    const char *cfilename_out=[destFile UTF8String];

    decodeOpus(cfilename, cfilename_out);
    resolve(destFile);
}

@end

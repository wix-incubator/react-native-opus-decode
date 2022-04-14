#import "OpusDecode.h"
#import "decoder.h"

@implementation OpusDecode

RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);
    
    
    //
    NSString *str = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"File.ogg"];
    const char *cfilename=[str UTF8String];
    
    NSString *str_out = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"File.wav"];
    const char *cfilename_out=[str_out UTF8String];

  decodeOpus(cfilename, cfilename_out);

  resolve(result);
}

@end

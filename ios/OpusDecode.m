#import "OpusDecode.h"
#import "decoder.h"

@implementation OpusDecode

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(decodeFromUri,
                 withSourceFile:(nonnull NSString*)sourceFile
                 withSourceFile:(nonnull NSString*)destFile
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    const char *fileNameIn=[sourceFile UTF8String];
    const char *filenameOut=[destFile UTF8String];
    decodeOpus(fileNameIn, filenameOut);
    resolve(destFile);
}

@end

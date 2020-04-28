#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(FaceDetection, NSObject)

RCT_EXTERN_METHOD(checkPermissions)
RCT_EXTERN_METHOD(isLogged)
RCT_EXTERN_METHOD(login)

@end
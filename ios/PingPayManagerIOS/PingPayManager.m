//
//  PingPayManager.m
//  PingPayManager
//
//  Created by jessica on 16/10/18.
//  Copyright © 2016年 jessica. All rights reserved.
//

#import "PingPayManager.h"
#import "Pingpp.h"

static NSString *gScheme = @"";

@implementation PingPayManager


RCT_EXPORT_MODULE()


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _autoGetScheme];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"RCTOpenURLNotification" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) handleOpenURL:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    NSString *url = userInfo[@"url"];
    [Pingpp handleOpenURL:[NSURL URLWithString:url] withCompletion:^(NSString *result, PingppError *error) {
        [self onResult:result error:error];
    }];
}
     
-(void) onResult:(NSString *) result error:(PingppError *)error
{
    NSMutableDictionary *body = @{}.mutableCopy;
    body[@"result"] = result;
    if(![result isEqualToString:@"success"]) {
        body[@"errCode"] = @(error.code);
        body[@"errMsg"] = [error getMsg];
    }
    [self sendEventWithName:@"Pingpp_Resp" body:body];
}

-(NSArray<NSString *> *) supportedEvents {
    return @[@"Pingpp_Resp"];
}

- (void)_autoGetScheme
{
    if(gScheme.length > 0) {
        return;
    }
    
    NSArray *list = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleURLTypes"];
    for(NSDictionary *item in list) {
        NSString *name = item[@"CFBundleURLName"];
        if([name isEqualToString:@"alipay"]) {
            NSArray *schemes = item[@"CFBundleURLSchemes"];
            if(schemes.count > 0) {
                gScheme = schemes[0];
                break;
            }
        }
    }
}

RCT_EXPORT_METHOD(pay:(NSString *)charge)
{
#ifdef DEBUG
    [Pingpp setDebugMode:YES];
#endif
    UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    [Pingpp createPayment:charge
           viewController:controller
             appURLScheme:gScheme
           withCompletion:^(NSString *result, PingppError *error) {
               [self onResult:result error:error];
           }];
}

//RCT_EXPORT_METHOD(setDebugMode:(BOOL)enabled
//                  :(RCTResponseSenderBlock)callback)
//{
//    [Pingpp setDebugMode:enabled];
//    callback(@[[NSNull null]]);
//}
//
//RCT_EXPORT_METHOD(handleOpenURLInIOS8:(NSURL *)url
//                  :(RCTResponseSenderBlock)callback)
//{
//    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
//        callback(@[@(error.code), result]);
//    }];
//}
//
//RCT_EXPORT_METHOD(handleOpenURLInIOS9:(NSURL *)url
//                  :(NSString *)sourceApplication
//                  :(RCTResponseSenderBlock)callback)
//{
//    [Pingpp handleOpenURL:url sourceApplication:sourceApplication withCompletion:^(NSString *result, PingppError *error) {
//        callback(@[@(error.code), result]);
//    }];
//}
//
//RCT_EXPORT_METHOD(createPayment:(NSDictionary *)charge
//                  :(NSString *)schema
//                  :(RCTResponseSenderBlock)callback)
//{
//    [Pingpp createPayment:charge appURLScheme:schema withCompletion:^(NSString *result, PingppError *error) {
//        callback(@[@(error.code), result]);
//    }];
//}

@end

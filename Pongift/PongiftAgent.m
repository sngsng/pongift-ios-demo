//
//  PongiftAgent.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftAgent.h"
#import "PongiftRestService.h"
#import "PongiftConstants.h"
#import "PongiftViewController.h"
#import "PongiftPersistenceManager.h"

@implementation PongiftAgent

+(id)sharedInstance {
    
    static PongiftAgent *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
    
}

- (void)initializePongiftWithSecretKey:(NSString*)secretKey andAccessKey:(NSString*)accessKey completion:(void(^)(bool completion)) completion {
    
    [self requestSecretKey:secretKey andAccessKey:accessKey completion:completion];
    
}

- (void)openPongiftViewController:(UIViewController*)controller {
    
    [controller presentViewController:[[PongiftViewController alloc] init] animated:true completion:nil];
}

- (void)requestSecretKey:(NSString*)secretKey andAccessKey:(NSString*)accessKey completion:(void(^)(bool compeltion)) completion{
    
    PongiftRestService *restService = [[PongiftRestService alloc] init];
    
    NSString *subUrl = SerivceInitializeUrl;
    
    NSString *secretQuery = [[ServiceInitializeQuerySecretKey stringByAppendingString:secretKey] stringByAppendingString:@"&"];
    NSString *accessQuery = [ServiceInitializeQueryAccessKey stringByAppendingString:accessKey];
    
    subUrl = [[subUrl stringByAppendingString:secretQuery] stringByAppendingString:accessQuery];

    [restService request:GET subUrl:subUrl params:nil progressBlock:^{
        
    } successBlock:^(id _Nullable response) {
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *resDict = (NSDictionary *)response;
            
            NSString *serviceId = [[resDict objectForKey:kServiceIntializeResponseId] stringValue];
            
            if (serviceId != nil) {
                
                [[PongiftPersistenceManager sharedInstance] setServiceId:serviceId];
            }
            
        }
        completion(true);
        
    } failBlock:^(NSError * _Nonnull error) {
        
        completion(false);
        
    } errorBlock:^(NSError * _Nonnull error) {
        
        completion(false);
    }];
}
@end

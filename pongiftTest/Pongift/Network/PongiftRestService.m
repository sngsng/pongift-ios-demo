//
//  PongiftRestService.m
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//


#import "PongiftRestService.h"
#import "PongiftConstants.h"
#import "PongiftCookieStore.h"
#import "PongiftUtils.h"

@implementation PongiftRestService

AFHTTPSessionManager *manager;

-(id)init {
    
    if (self = [super init]) {
        
        NSURL *rootUrl = [NSURL URLWithString:RootUrl];
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:rootUrl];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.HTTPShouldHandleCookies = NO;
        
        NSString *cookie = [[PongiftCookieStore sharedInstance] getCookie];
        
        if (cookie != nil) {
            
            [[manager requestSerializer] setValue:cookie forHTTPHeaderField:@"cookie"];
        }
    }
    
    return self;
}

-(void)request:(Method)method subUrl:(NSString* _Nonnull)subUrl params:(nullable NSDictionary* )params progressBlock:(void (^_Nonnull)(void))progressBlock successBlock:(void(^_Nonnull)(id _Nullable response))successBlock
     failBlock:(void(^_Nonnull)(NSError* _Nonnull error))failBlock errorBlock:(void(^_Nonnull)( NSError* _Nonnull error))errorBlock
{
    
    switch (method) {
        case GET:
            [self requestGETWithUrl:subUrl params:params progressBlock:progressBlock successBlock:successBlock failBlock:failBlock errorBlock:errorBlock];
        case POST:
        case DELETE:
        case PUT:
            break;
            
    }
}

- (void)requestGETWithUrl:(NSString*)subUrl params:(nullable NSDictionary* )params progressBlock:(void (^_Nullable)(void))progressBlock successBlock:(void(^_Nullable)(id response))successBlock
                failBlock:(void(^_Nonnull)(NSError* error))failBlock errorBlock:(void(^_Nonnull)(NSError* error))errorBlock{
    
    [manager GET:subUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progressBlock();
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        NSDictionary *headers = [response allHeaderFields];
        NSString *cookie = [headers objectForKey:@"Set-Cookie"];
        
        if (cookie != nil) {
            
            [[PongiftCookieStore sharedInstance] saveCookie:cookie];
        }
        
        
        successBlock(responseObject);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = 0;
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            statusCode = response.statusCode;
            
        }
        
        if (statusCode > 0) {
            
            if (statusCode >= 400 && statusCode < 500) {
                
                if (statusCode == 404) {
                    
                    [PongiftUtils Log:@"accessKey, secretKey 가 올바르지 않습니다."];
                }
                failBlock(error);
            }
            else {
                
                [PongiftUtils Log:error.localizedDescription];
                errorBlock(error);
            }
        }
        else {
            
            [PongiftUtils Log:error.localizedDescription];
            errorBlock(error);
        }
    }];
}

@end

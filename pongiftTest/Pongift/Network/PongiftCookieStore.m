//
//  PongiftCookieStore.m
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftCookieStore.h"
#import "PongiftConstants.h"

@implementation PongiftCookieStore
    
    + (id _Nonnull)sharedInstance {
        
        static PongiftCookieStore *instance = nil;
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            instance = [[self alloc] init];
        });
        
        return instance;
    }
    
    
    - (void)saveCookie:(NSString* _Nonnull)cookie {
        
        [[NSUserDefaults standardUserDefaults] setValue:cookie forKey:RootUrl];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    - (NSString * _Nullable)getCookie {
        
        return [[NSUserDefaults standardUserDefaults] objectForKey:RootUrl];
    }
    
    - (void)removeCookie {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:RootUrl];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    

@end

//
//  PongiftCookieStore.h
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PongiftCookieStore : NSObject
    
    + (id _Nonnull)sharedInstance;
    - (NSString * _Nullable)getCookie;
    - (void)saveCookie:(NSString* _Nonnull)cookie;
    - (void)removeCookie;
    
    
@end

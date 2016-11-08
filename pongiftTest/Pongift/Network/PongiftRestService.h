//
//  PongiftRestService.h
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface PongiftRestService : NSObject
    
    enum methods{GET,POST,DELETE,PUT};
    typedef enum methods Method;
    
    -(void)request:(Method)method subUrl:(NSString* _Nonnull)subUrl params:(nullable NSDictionary* )params progressBlock:(void (^_Nonnull)(void))progressBlock successBlock:(void(^_Nonnull)(id _Nullable response))successBlock
         failBlock:(void(^_Nonnull)(NSError* _Nonnull error))failBlock errorBlock:(void(^_Nonnull)( NSError* _Nonnull error))errorBlock;
    
    
    @end

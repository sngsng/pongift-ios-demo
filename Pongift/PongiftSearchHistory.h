//
//  PongiftSearchHistory.h
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PongiftSearchHistory : NSObject

@property (strong, nonatomic, nonnull) NSString* title;
@property (strong, nonatomic, nonnull) NSString* date;

- (id _Nonnull)initWithTitle:(NSString* _Nonnull)title andDate:(NSString* _Nonnull)date;
- (NSDictionary * _Nonnull)getJson;

@end

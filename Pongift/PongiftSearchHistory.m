//
//  PongiftSearchHistory.m
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftSearchHistory.h"
#import "PongiftConstants.h"

@implementation PongiftSearchHistory

- (id _Nonnull)initWithTitle:(NSString*)title andDate:(NSString*)date {
    
    if (self = [super init]) {
        
        _title = title;
        _date = date;
    }
    
    return self;
}

- (NSDictionary * _Nonnull)getJson {
    
    return @{kTitle : _title, kDate : _date};
}

@end

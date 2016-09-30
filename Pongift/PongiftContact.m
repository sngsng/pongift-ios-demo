//
//  PongiftContact.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftContact.h"

@implementation PongiftContact

NSString *const kContactName = @"name";
NSString *const kContactPhoneNum = @"phoneNumber";
NSString *const kContactThumbnailImage = @"thumnailImage";
NSString *const kContactBirthday = @"birthDay";

NSMutableDictionary *json;

- (id)init {
    
    if (self = [super init]) {
        
        json = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setName:(NSString*)name {
    
    [json setValue:name forKey:kContactName];
}

- (void)setPhoneNum:(NSString *)phoneNum {
    
    [json setValue:phoneNum forKey:kContactPhoneNum];
}

- (void)setThumnailImage:(NSData *)imageData {
    
//    [json setValue:name forKey:kContactName];
}

- (void)setBirthDay:(NSString*)birthDay {
    
    [json setValue:birthDay forKey:kContactBirthday];
}


@end

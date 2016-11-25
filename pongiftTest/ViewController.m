//
//  ViewController.m
//  pongiftTest
//
//  Created by 김승중 on 2016. 10. 26..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "ViewController.h"
#import "PongiftAgent.h"
#import "PongiftUtils.h"
#import "PongiftLocalNotificationManager.h"
#import "PongiftViewController.h"
#import "PongiftConstants.h"
#import "PongiftRestService.h"
#import "PongiftPersistenceManager.h"




@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    NSString *timeIntervalString = [PongiftUtils timeStampStringFromHour:9 andMinute:0];
    
    NSLog(@"%@", timeIntervalString);
    

    
    
    
    
    
}

- (IBAction)openPongiftVCWithDebug:(id)sender {
    
    [self openPongiftVCWithDebugFlag:YES];
}

- (IBAction)openPongiftVCWithRelease:(id)sender {
    
    [self openPongiftVCWithDebugFlag:NO];
}


- (void)openPongiftVCWithDebugFlag:(BOOL)isDebug {

    NSString *url;
    NSString *accessKey;
    NSString *secretKey;
    
    if (isDebug) {
        
        accessKey = @"j8NtyUuoubAfGShaRQF2MA==";
        secretKey = @"bD3QeKX2rhUcSVlubuy2Dg==";
        url = RootUrlDebug;

    }
    else {
        
        accessKey = @"oKx8mZREfK5FwQBjI3oDHg==";
        secretKey = @"uO3LzzCJshT9VdcRnjRGvA==";
        url = RootUrl;
    }
    
    [self requestSecretKeyWithUrl:url secretKey:secretKey andAccessKey:accessKey completion:^(bool compeltion) {
        
        if (compeltion) {
            
            PongiftViewController *pongiftVC = [[PongiftViewController alloc] init];
            pongiftVC.url = url;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pongiftVC];
            [self presentViewController:navigationController animated:true completion:nil];
        }
    }];
    
    
    
}


- (void)requestSecretKeyWithUrl:(NSString*)url secretKey:(NSString*)secretKey andAccessKey:(NSString*)accessKey completion:(void(^)(bool compeltion)) completion{
    
    PongiftRestService *restService = [[PongiftRestService alloc] initWithRootUrl:url];
    
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
        
        [PongiftUtils Log:[error localizedDescription]];
        completion(false);
        
    } errorBlock:^(NSError * _Nonnull error) {
        
        [PongiftUtils Log:[error localizedDescription]];
        completion(false);
    }];
}


- (IBAction)pushNotificationTimeSettingsButton:(id)sender {
    
    NSDate *selectedDate = _datePickerView.date;
    NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:selectedDate];
    NSInteger min = [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:selectedDate];
    
    NSLog(@"datePicker date :%ld : %ld", (long)hour, (long)min);
    
    PongiftLocalNotificationManager *manager = [PongiftLocalNotificationManager sharedInstance];
    [manager setNotiFiredHour:hour];
    [manager setNotiFiredMin:min];
    
    [[PongiftAgent sharedInstance] schedulePongiftMemorialDayNotifications];
    
    [PongiftUtils showAlertWithMsg:[NSString stringWithFormat:@"알림이 등록되었습니다. (%2d시 %2d분)",hour,min] controller:self];
    
    
}


- (IBAction)datePickerUpdated:(id)sender {
    
    
}

@end

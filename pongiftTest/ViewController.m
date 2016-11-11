//
//  ViewController.m
//  pongiftTest
//
//  Created by 김승중 on 2016. 10. 26..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "ViewController.h"
#import "PongiftAgent.h"
#import "PongiftContactsManager.h"
#import "PongiftLocalNotificationManager.h"
#import "PongiftUtils.h"



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)openPongiftVC:(id)sender {
    
    // 폰기프트 선물하기기능을 위한 컨트롤러 호출
    PongiftAgent *agent = [PongiftAgent sharedInstance];
    [agent openPongiftViewController:self];
    
}

- (IBAction)pushNotificationTimeSettingsButton:(id)sender {
    
    NSDate *selectedDate = _datePickerView.date;
    NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:selectedDate];
    NSInteger min = [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:selectedDate];
    
    NSLog(@"datePicker date :%d : %d", hour, min);
    
    PongiftLocalNotificationManager *manager = [PongiftLocalNotificationManager sharedInstance];
    [manager setNotiFiredHour:hour];
    [manager setNotiFiredMin:min];
    
    [[PongiftAgent sharedInstance] schedulePongiftMemorialDayNotifications];
    
    [PongiftUtils showAlertWithMsg:[NSString stringWithFormat:@"알림이 등록되었습니다. (%2d시 %2d분)",hour,min] controller:self];
    
    
    
}

- (IBAction)datePickerUpdated:(id)sender {
    
    
}

@end

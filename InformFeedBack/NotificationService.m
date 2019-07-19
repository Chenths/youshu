//
//  NotificationService.m
//  InformFeedBack
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "NotificationService.h"
#import "JPushNotificationExtensionService.h"
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    self.contentHandler(self.bestAttemptContent);
    [JPushNotificationExtensionService jpushSetAppkey:@"5094545990eb415462160e31"];
    [JPushNotificationExtensionService jpushReceiveNotificationRequest:request with:^{
        NSLog(@"上传推送信息");
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end

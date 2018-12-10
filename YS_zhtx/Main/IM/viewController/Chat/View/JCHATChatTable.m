//
//  chatTable.m
//  JPush IM
//
//  Created by Apple on 15/3/4.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATChatTable.h"

@implementation JCHATChatTable

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesBegan:touches withEvent:event];
  if ([self.touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
      [self.touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
  {
    [self.touchDelegate tableView:self touchesBegan:touches withEvent:event];
  }
}



@end

//
//  CALayer+CALayer_CALayer_XibConfiguration.m
//  YS_zhtx
//
//  Created by mac on 2019/4/26.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "CALayer+CALayer_CALayer_XibConfiguration.h"

@implementation CALayer (CALayer_CALayer_XibConfiguration)
- (void)setBorderUIColor:(UIColor *)borderUIColor{
    self.borderColor = borderUIColor.CGColor;
}

- (UIColor *)borderUIColor{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end

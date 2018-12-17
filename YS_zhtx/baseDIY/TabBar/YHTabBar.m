
//
//  YHTabBar.m
//  ZHTX_YouShu
//
//  Created by FengYiHao on 2018/3/15.
//  Copyright © 2018年 成都志汇天下网络科技有限公司 版权所有. All rights reserved.
//

#import "YHTabBar.h"
#define caishImg @"g-caish"
#define BtnMargin 5
@interface YHTabBar()

@property (nonatomic, strong) UIButton *centerBtn;

@property (nonatomic, strong) UILabel *labTag;

@end

@implementation YHTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _centerBtn = [[UIButton alloc]init];
        [_centerBtn setBackgroundImage:[UIImage imageNamed:caishImg] forState:UIControlStateNormal];
        [_centerBtn setBackgroundImage:[UIImage imageNamed:caishImg] forState:UIControlStateHighlighted];
        [_centerBtn addTarget:self action:@selector(centBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_centerBtn];
    }
    return self;
}
- (void)centBtnClick:(UIButton *)btn{
    if (self.delegateYH && [self.delegateYH respondsToSelector:@selector(actionEventsOfBarCentItemClickWithTabBar:)]) {
        [self.delegateYH actionEventsOfBarCentItemClickWithTabBar:self];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
            UIImageView *line = (UIImageView *)view;
            line.hidden = YES;
        }
    }
    _centerBtn.size = CGSizeMake(_centerBtn.currentBackgroundImage.size.width, _centerBtn.currentBackgroundImage.size.height);
    
    _centerBtn.center = CGPointMake(HMSCREENWIDTH * 0.5, self.height - _centerBtn.currentBackgroundImage.size.height * 0.5);
    _labTag = [[UILabel alloc] init];
    _labTag.text = @"";
    _labTag.font = [UIFont systemFontOfSize:10];
    _labTag.textColor = [UIColor grayColor];
    [_labTag sizeToFit];
    
    _labTag.centerX = _centerBtn.centerX;
    _labTag.centerY = CGRectGetMaxY(_centerBtn.frame) + 0.5 * BtnMargin + 0.5;
    [self addSubview:_labTag];
    
    int btnIndex = 0;
    
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in self.subviews) {//遍历TabBar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度等于TabBar的五分之一
            btn.width = self.width / 5;
            btn.x = btn.width * btnIndex;
            btnIndex++;
            //如果索引是1(即“+”按钮)，直接让索引加一
            if (btnIndex == 2) {
                btnIndex++;
            }
        }
    }
    
    //将按钮放到视图层次最前面
    [self bringSubviewToFront:_centerBtn];
    
}

//重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //这一个判断是关键，不判断的话push到其他页面，点击“+”按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有TabBar的，那么肯定是在根控制器页面
    //在根控制器页面，那么我们就需要判断手指点击的位置是否在“+”按钮或“添加”标签上
    //是的话让“+”按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO)
    {
        
        //将当前TabBar的触摸点转换坐标系，转换到“+”按钮的身上，生成一个新的点
        CGPoint newA = [self convertPoint:point toView:_centerBtn];
        //将当前TabBar的触摸点转换坐标系，转换到“添加”标签的身上，生成一个新的点
        CGPoint newL = [self convertPoint:point toView:_labTag];
        
        //判断如果这个新的点是在“+”按钮身上，那么处理点击事件最合适的view就是“+”按钮
        if ( [_centerBtn pointInside:newA withEvent:event]){
            return _centerBtn;
            
        }else if([_labTag pointInside:newL withEvent:event]){//判断如果这个新的点是在“添加”标签身上，那么也让“+”按钮处理事件
            return _centerBtn;
            
        }else{//如果点不在“+”按钮身上，直接让系统处理就可以了
            
            return [super hitTest:point withEvent:event];
        }
    }else{
        //TabBar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}



@end

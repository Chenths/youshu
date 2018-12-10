//
//  ____    ___   _        ___  _____  ____  ____  ____
// |    \  /   \ | T      /  _]/ ___/ /    T|    \|    \
// |  o  )Y     Y| |     /  [_(   \_ Y  o  ||  o  )  o  )
// |   _/ |  O  || l___ Y    _]\__  T|     ||   _/|   _/
// |  |   |     ||     T|   [_ /  \ ||  _  ||  |  |  |
// |  |   l     !|     ||     T\    ||  |  ||  |  |  |
// l__j    \___/ l_____jl_____j \___jl__j__jl__j  l__j
//
//
//	Powered by Polesapp.com
//
//
//  RBCustomDatePickerView.h
//
//
//  Created by fangmi-huangchengda on 15/10/21.
//
//

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (kScreen_Width/320))

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

typedef enum {
    DatePickerDateMode,
    DatePickerTimeMode,
    DatePickerDateTimeMode,
    DatePickerYearMonthMode,
    DatePickerMonthDayMode,
    DatePickerHourMinuteMode,
    DatePickerDateHourMinuteMode,
    DatePickerYearMode
} DatePickerMode;

typedef enum {
    DateBegin,
    DateEnd
} DateIsBeginOrEnd;

typedef void(^DatePickerCompleteAnimationBlock)(BOOL Complete);
typedef void(^ClickedOkBtn)(NSString *dateTimeStr);

typedef void(^BetweenClickedOkBtn)(NSString *beginTime,NSString *endTime);

@interface HcdDateTimePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>
@property (nonatomic,copy) ClickedOkBtn clickedOkBtn;

@property (nonatomic,copy) BetweenClickedOkBtn betweenClickedOkBtn;

@property (nonatomic,assign) DatePickerMode datePickerMode;

@property (nonatomic,assign) NSInteger maxYear;
@property (nonatomic,assign) NSInteger minYear;

@property (nonatomic,strong) UIColor *topViewColor;
@property (nonatomic,strong) UIColor *buttonTitleColor;
@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,weak  ) NSString *title;

-(instancetype)initWithDefaultDatetime:(NSDate*)dateTime;
-(instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode defaultDateTime:(NSDate*)dateTime WithIsBeteewn:(BOOL) isbetween;
-(void) showHcdDateTimePicker;
@end

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
//  RBCustomDatePickerView.m
//
//
//  Created by fangmi-huangchengda on 15/10/21.
//
//

#define kTopViewHeight kScaleFrom_iPhone5_Desgin(44)
#define TopViewHeight kScaleFrom_iPhone5_Desgin(44)
#define kTimeBroadcastViewHeight kScaleFrom_iPhone5_Desgin(200)
#define kDatePickerHeight (kTopViewHeight + kTimeBroadcastViewHeight)
#define kOKBtnTag 101
#define kCancleBtnTag 100
#define BeginHeight 44


#import "HcdDateTimePickerView.h"
//#import "UIColor+HcdCustom.h"

@interface HcdDateTimePickerView()<UIGestureRecognizerDelegate>
{
    UIView                      *timeBroadcastView;//定时播放显示视图
    UIView                      *topView;
    UILabel                     *titleLbl;
    MXSCycleScrollView          *yearScrollView;//年份滚动视图
    MXSCycleScrollView          *monthScrollView;//月份滚动视图
    MXSCycleScrollView          *dayScrollView;//日滚动视图
    MXSCycleScrollView          *hourScrollView;//时滚动视图
    MXSCycleScrollView          *minuteScrollView;//分滚动视图
    MXSCycleScrollView          *secondScrollView;//秒滚动视图
    UIButton                    *okBtn;//自定义picker上的确认按钮
    UIButton                    *cancleBtn;//
    NSString                    *dateTimeStr;
}

@property (nonatomic,assign) NSInteger curYear;//当前年
@property (nonatomic,assign) NSInteger curMonth;//当前月
@property (nonatomic,assign) NSInteger curDay;//当前日
@property (nonatomic,assign) NSInteger curHour;//当前小时
@property (nonatomic,assign) NSInteger curMin;//当前分
@property (nonatomic,assign) NSInteger curSecond;//当前秒

@property (nonatomic, retain) NSDate *defaultDate;

@property (nonatomic,strong) UIView *beginTimeView;
@property (nonatomic,strong) UIView *endTimeView;

@property (nonatomic,strong) UILabel *beginTimeLabel;
@property (nonatomic,strong) UILabel *endTimeLabel;
@property (nonatomic,assign) BOOL isBetween;

@property (nonatomic,assign) CGFloat BetweenHeight;

@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;

@property (nonatomic,assign) DateIsBeginOrEnd  HoldDate;

@end

@implementation HcdDateTimePickerView

- (instancetype)initWithDefaultDatetime:(NSDate *)dateTime
{
    self = [super init];
    if (self) {
        self.defaultDate = dateTime;
        if (!self.defaultDate) {
            self.defaultDate = [NSDate date];
        }
        self.datePickerMode = DatePickerDateTimeMode;
        [self initDatas];
        [self setTimeBroadcastView];
        self.HoldDate = DateBegin;
    }
    return self;
}

- (instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode defaultDateTime:(NSDate *)dateTime WithIsBeteewn:(BOOL)isbetween
{
    self = [super init];
    if (self) {
        self.defaultDate = dateTime;
        self.isBetween = isbetween;
        if (!self.defaultDate) {
            self.defaultDate = [NSDate date];
        }
        self.datePickerMode = datePickerMode;
        [self initDatas];
        [self setTimeBroadcastView];
    }
    return self;
}

- (void)setMaxYear:(NSInteger)maxYear {
    _maxYear = maxYear;
    [self updateYearScrollView];
}
- (void)setMinYear:(NSInteger)minYear {
    _minYear = minYear;
    [self updateYearScrollView];
}

- (void)updateYearScrollView {
    [yearScrollView reloadData];
    
    [yearScrollView setCurrentSelectPage:(self.curYear-(_minYear+2))];
    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initDatas {
    _topViewColor = [UIColor colorWithHexString:@"0x6271f3"];
    _buttonTitleColor = [UIColor colorWithHexString:@"0xffffff"];
}

- (void)setTopViewColor:(UIColor *)topViewColor {
    _topViewColor = topViewColor;
    if (topView) {
        topView.backgroundColor = topViewColor;
    }
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;
    if (okBtn) {
        [okBtn setTitleColor:_buttonTitleColor forState:UIControlStateNormal];
    }
    if (cancleBtn) {
        [cancleBtn setTitleColor:_buttonTitleColor forState:UIControlStateNormal];
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    titleLbl.textColor = _titleColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLbl.text = title;
}
-(void)beginClicked:(UIButton *) sender{
    self.HoldDate = DateBegin;
    self.beginTimeLabel.textColor = [UIColor colorWithHexString:@"#6A82FB"];
    self.endTimeLabel.textColor = [UIColor colorWithHexString:@"222222"];
}
- (void)endClicked:(UIButton *)sender{
    self.HoldDate = DateEnd;
    self.endTimeLabel.textColor = [UIColor colorWithHexString:@"#6A82FB"];
    self.beginTimeLabel.textColor = [UIColor colorWithHexString:@"222222"];
}
#pragma mark -custompicker
//设置自定义datepicker界面
- (void)setTimeBroadcastView
{
    
    [self setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateTimeStr = [dateFormatter stringFromDate:self.defaultDate];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, TopViewHeight)];
    topView.backgroundColor = _topViewColor;
    
    okBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width-60, 0, 60, TopViewHeight)];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [okBtn setBackgroundColor:[UIColor clearColor]];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(selectedButtons:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.tag = kOKBtnTag;
    [self addSubview:okBtn];
    
    cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, TopViewHeight)];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor clearColor]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(selectedButtons:) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.tag = kCancleBtnTag;
    [self addSubview:cancleBtn];
    
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreen_Width - 120, TopViewHeight)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:14];
    
    [topView addSubview:okBtn];
    [topView addSubview:cancleBtn];
    [topView addSubview:titleLbl];
    
    if (self.isBetween) {
//        [self beginTimeView];
        _beginTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight,kScreen_Width, BeginHeight)];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"开始时间";
        titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.frame = CGRectMake(15, 0 , 120 , BeginHeight);
        [_beginTimeView addSubview:titleLabel];
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(120, 0 , HMSCREENWIDTH - 120, BeginHeight)];
        
        [bt addTarget:self action:@selector(beginClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_beginTimeView addSubview:bt];
        self.beginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(HMSCREENWIDTH *0.5, 0, HMSCREENWIDTH *0.5 - 10, BeginHeight)];
        self.beginTimeLabel.text = @"----/--/--";
        self.beginTimeLabel.textColor = [UIColor colorWithHexString:@"222222"];
        self.beginTimeLabel.font = [UIFont systemFontOfSize:14];
        self.beginTimeLabel.textAlignment = NSTextAlignmentRight;
        [_beginTimeView addSubview:self.beginTimeLabel];

        _endTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + BeginHeight,kScreen_Width, BeginHeight)];
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame: CGRectMake(15, 0, 120 , BeginHeight)];
        titleLabel1.text = @"结束时间";
        titleLabel1.textColor = [UIColor colorWithHexString:@"222222"];
        titleLabel1.font = [UIFont systemFontOfSize:15];
        [_endTimeView addSubview:titleLabel1];
        UIButton *bt1 = [[UIButton alloc] initWithFrame:CGRectMake(120, 0 , HMSCREENWIDTH - 120, BeginHeight)];
//        bt1.backgroundColor  =[UIColor redColor];
        [bt1 addTarget:self action:@selector(endClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_endTimeView addSubview:bt1];
        self.endTimeLabel = [[UILabel alloc] init];
        self.endTimeLabel.text = @"----/--/--";
        self.endTimeLabel.textColor = [UIColor colorWithHexString:@"222222"];
        self.endTimeLabel.font = [UIFont systemFontOfSize:14];
        self.endTimeLabel.frame = CGRectMake(HMSCREENWIDTH *0.5, 0, HMSCREENWIDTH *0.5 - 10 , BeginHeight);
        self.endTimeLabel.textAlignment = NSTextAlignmentRight;
        [_endTimeView addSubview:self.endTimeLabel];
        self.BetweenHeight = 2 * BeginHeight;
    }else{
        self.BetweenHeight = 0.0f;
    }
    
    timeBroadcastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kTimeBroadcastViewHeight)];
    timeBroadcastView.backgroundColor = [UIColor redColor];
    timeBroadcastView.layer.cornerRadius = 0;//设置视图圆角
    timeBroadcastView.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    timeBroadcastView.layer.borderColor = cgColor;
    timeBroadcastView.layer.borderWidth = 0.0;
    timeBroadcastView.backgroundColor = [UIColor whiteColor];
    [self addSubview:timeBroadcastView];
    UIView *beforeSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + self.BetweenHeight + (kTimeBroadcastViewHeight / 5), kScreen_Width, 1.5)];
    [beforeSepLine setBackgroundColor:[UIColor colorWithHexString:@"0xEDEDED"]];
    [timeBroadcastView addSubview:beforeSepLine];
    UIView *middleSepView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight +self.BetweenHeight + 2 * (kTimeBroadcastViewHeight / 5), kScreen_Width, kTimeBroadcastViewHeight / 5)];
    [middleSepView setBackgroundColor:[UIColor colorWithHexString:@"0xEDEDED"]];
    [timeBroadcastView addSubview:middleSepView];
    middleSepView.layer.borderWidth = 1.5;
    middleSepView.layer.borderColor = [UIColor colorWithHexString:@"0xEDEDED"].CGColor;
    UIView *bottomSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + self.BetweenHeight + 4 * (kTimeBroadcastViewHeight / 5), kScreen_Width, 1.5)];
    [bottomSepLine setBackgroundColor:[UIColor colorWithHexString:@"0xEDEDED"]];
    [timeBroadcastView addSubview:bottomSepLine];
    
    if (self.datePickerMode == DatePickerDateMode) {
        [self setYearScrollView];
        [self setMonthScrollView];
        [self setDayScrollView];
    }
    else if (self.datePickerMode == DatePickerTimeMode) {
        [self setHourScrollView];
        [self setMinuteScrollView];
        [self setSecondScrollView];
    }
    else if (self.datePickerMode == DatePickerDateTimeMode) {
        [self setYearScrollView];
        [self setMonthScrollView];
        [self setDayScrollView];
        [self setHourScrollView];
        [self setMinuteScrollView];
        [self setSecondScrollView];
    }
    else if (self.datePickerMode == DatePickerYearMonthMode) {
        [self setYearScrollView];
        [self setMonthScrollView];
    }
    else if (self.datePickerMode == DatePickerMonthDayMode) {
        [self setMonthScrollView];
        [self setDayScrollView];
    }
    else if (self.datePickerMode == DatePickerHourMinuteMode) {
        [self setHourScrollView];
        [self setMinuteScrollView];
    }
    else if (self.datePickerMode == DatePickerDateHourMinuteMode) {
        [self setYearScrollView];
        [self setMonthScrollView];
        [self setDayScrollView];
        [self setHourScrollView];
        [self setMinuteScrollView];
    }else if (self.datePickerMode == DatePickerYearMode) {
        [self setYearScrollView];
    }
    
    if (self.isBetween) {
        [timeBroadcastView addSubview:_beginTimeView];
        [timeBroadcastView addSubview: _endTimeView];
    }
    [timeBroadcastView addSubview:topView];
    [timeBroadcastView setFrame:CGRectMake(0, kScreen_Height-100, kScreen_Width, kDatePickerHeight + self.BetweenHeight)];
}
//设置年月日时分的滚动视图
- (void)setYearScrollView
{
    if (self.datePickerMode == DatePickerDateTimeMode) {
        yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + self.BetweenHeight, kScreen_Width*0.25, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateMode) {
        yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + self.BetweenHeight, kScreen_Width*0.34, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerYearMonthMode) {
        yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + self.BetweenHeight, kScreen_Width*0.5, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateHourMinuteMode) {
        yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + self.BetweenHeight, kScreen_Width*0.28, kTimeBroadcastViewHeight)];
    }else if (self.datePickerMode == DatePickerYearMode) {
        yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + self.BetweenHeight, kScreen_Width, kTimeBroadcastViewHeight)];
    }
    
    self.curYear = [self setNowTimeShow:0];
    [yearScrollView setCurrentSelectPage:(self.curYear-(_minYear+2))];
    yearScrollView.delegate = self;
    yearScrollView.datasource = self;
    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:yearScrollView];
}
//设置年月日时分的滚动视图
- (void)setMonthScrollView
{
    if (self.datePickerMode == DatePickerDateTimeMode) {
        monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.25, kTopViewHeight + self.BetweenHeight, kScreen_Width*0.15, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateMode) {
        monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.34, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.33, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerMonthDayMode) {
        monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.5, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerYearMonthMode) {
        monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.5, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.5, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateHourMinuteMode) {
        monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.28, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.18, kTimeBroadcastViewHeight)];
    }
    
    self.curMonth = [self setNowTimeShow:1];
    [monthScrollView setCurrentSelectPage:(self.curMonth-3)];
    monthScrollView.delegate = self;
    monthScrollView.datasource = self;
    [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:monthScrollView];
}
//设置年月日时分的滚动视图
- (void)setDayScrollView
{
    if (self.datePickerMode == DatePickerDateTimeMode) {
        dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.40, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.15, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateMode) {
        dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.67, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.33, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerMonthDayMode) {
        dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.5, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.5, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateHourMinuteMode) {
        dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.46, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.18, kTimeBroadcastViewHeight)];
    }
    
    self.curDay = [self setNowTimeShow:2];
    [dayScrollView setCurrentSelectPage:(self.curDay-3)];
    dayScrollView.delegate = self;
    dayScrollView.datasource = self;
    [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:dayScrollView];
}
//设置年月日时分的滚动视图
- (void)setHourScrollView
{
    if (self.datePickerMode == DatePickerDateTimeMode) {
        hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.55, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.15, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerTimeMode) {
        hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.34, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerHourMinuteMode) {
        hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.5, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateHourMinuteMode) {
        hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.64, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.18, kTimeBroadcastViewHeight)];
    }
    
    self.curHour = [self setNowTimeShow:3];
    [hourScrollView setCurrentSelectPage:(self.curHour-2)];
    hourScrollView.delegate = self;
    hourScrollView.datasource = self;
    [self setAfterScrollShowView:hourScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:hourScrollView];
}
//设置年月日时分的滚动视图
- (void)setMinuteScrollView
{
    if (self.datePickerMode == DatePickerDateTimeMode) {
        minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.70, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.15, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerTimeMode) {
        minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.34, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.33, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerHourMinuteMode) {
        minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.5, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.5, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerDateHourMinuteMode) {
        minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.82, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.18, kTimeBroadcastViewHeight)];
    }
    
    self.curMin = [self setNowTimeShow:4];
    [minuteScrollView setCurrentSelectPage:(self.curMin-2)];
    minuteScrollView.delegate = self;
    minuteScrollView.datasource = self;
    [self setAfterScrollShowView:minuteScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:minuteScrollView];
}
//设置年月日时分的滚动视图
- (void)setSecondScrollView
{
    if (self.datePickerMode == DatePickerDateTimeMode) {
        secondScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.85, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.15, kTimeBroadcastViewHeight)];
    } else if (self.datePickerMode == DatePickerTimeMode) {
        secondScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(kScreen_Width*0.67, kTopViewHeight+ self.BetweenHeight, kScreen_Width*0.33, kTimeBroadcastViewHeight)];
    }
    self.curSecond = [self setNowTimeShow:5];
    [secondScrollView setCurrentSelectPage:(self.curSecond-2)];
    secondScrollView.delegate = self;
    secondScrollView.datasource = self;
    [self setAfterScrollShowView:secondScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:secondScrollView];
}
- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:[UIColor colorWithHexString:@"0xBABABA"]];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:[UIColor colorWithHexString:@"0x717171"]];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[UIColor blackColor]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:[UIColor colorWithHexString:@"0x717171"]];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:[UIColor colorWithHexString:@"0xBABABA"]];
}
#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == yearScrollView) {
        
        if (self.datePickerMode == DatePickerDateMode || self.datePickerMode == DatePickerDateTimeMode) {
            return _maxYear - _minYear + 1;
        }
        
        return 299;
    }
    else if (scrollView == monthScrollView)
    {
        return 12;
    }
    else if (scrollView == dayScrollView)
    {
        
        if (DatePickerMonthDayMode == self.datePickerMode) {
            return 29;
        }
        
        if (self.curMonth == 1 || self.curMonth == 3 || self.curMonth == 5 ||
            self.curMonth == 7 || self.curMonth == 8 || self.curMonth == 10 ||
            self.curMonth == 12) {
            return 31;
        } else if (self.curMonth == 2) {
            if ([self isLeapYear:self.curYear]) {
                return 29;
            } else {
                return 28;
            }
        } else {
            return 30;
        }
    }
    else if (scrollView == hourScrollView)
    {
        return 24;
    }
    else if (scrollView == minuteScrollView)
    {
        return 60;
    }
    return 60;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    l.tag = index+1;
    if (scrollView == yearScrollView) {
        l.text = [NSString stringWithFormat:@"%ld年",(long)(_minYear+index)];
    }
    else if (scrollView == monthScrollView)
    {
        l.text = [NSString stringWithFormat:@"%ld月",(long)(1+index)];
    }
    else if (scrollView == dayScrollView)
    {
        l.text = [NSString stringWithFormat:@"%ld日",(long)(1+index)];
    }
    else if (scrollView == hourScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld时",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld时",(long)index];
    }
    else if (scrollView == minuteScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld分",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld分",(long)index];
    }
    else
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld秒",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld秒",(long)index];
    
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    return l;
}
//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType
{
    NSDate *now = self.defaultDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 3:
        {
            NSRange range = NSMakeRange(8, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 4:
        {
            NSRange range = NSMakeRange(10, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 5:
        {
            NSRange range = NSMakeRange(12, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        default:
            break;
    }
    return 0;
}
//选择设置的播报时间
- (void)selectSetBroadcastTime
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    NSInteger yearInt = yearLabel.tag + _minYear - 1;
    NSInteger monthInt = monthLabel.tag;
    NSInteger dayInt = dayLabel.tag;
    NSInteger hourInt = hourLabel.tag - 1;
    NSInteger minuteInt = minuteLabel.tag - 1;
    NSInteger secondInt = secondLabel.tag - 1;
    NSString *taskDateString = [NSString stringWithFormat:@"%ld%02ld%02ld%02ld%02ld%02ld",(long)yearInt,(long)monthInt,(long)dayInt,(long)hourInt,(long)minuteInt,(long)secondInt];
    NSLog(@"Now----%@",taskDateString);
}
//滚动时上下标签显示(当前时间和是否为有效时间)
- (void)scrollviewDidChangeNumber
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    NSInteger month = monthLabel.tag;
    NSInteger year = yearLabel.tag + _minYear - 1;
    if (month != self.curMonth) {
        self.curMonth = month;
        [dayScrollView reloadData];
        [dayScrollView setCurrentSelectPage:(self.curDay-3)];
        [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
    }
    if (year != self.curYear) {
        self.curYear = year;
        [dayScrollView reloadData];
        [dayScrollView setCurrentSelectPage:(self.curDay-3)];
        [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
    }
    
    self.curMonth = monthLabel.tag;
    self.curDay = dayLabel.tag;
    self.curHour = hourLabel.tag - 1;
    self.curMin = minuteLabel.tag - 1;
    self.curSecond = secondLabel.tag - 1;
    switch (self.datePickerMode) {
        case DatePickerDateMode:
            dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay];
            
            break;
        case DatePickerTimeMode:
            dateTimeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)self.curHour,(long)self.curMin,(long)self.curSecond];
            
            break;
        case DatePickerDateTimeMode:
            dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay,(long)self.curHour,(long)self.curMin,(long)self.curSecond];
            
            break;
        case DatePickerMonthDayMode:
            dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld",(long)self.curMonth,(long)self.curDay];
            
            break;
        case DatePickerYearMonthMode:
            dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld",(long)self.curYear,(long)self.curMonth];
            
            break;
        case DatePickerYearMode:
           
            dateTimeStr = [NSString stringWithFormat:@"%ld",(long)self.curYear];
            break;
        case DatePickerHourMinuteMode:
            
            dateTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)self.curHour,(long)self.curMin];
            break;
        case DatePickerDateHourMinuteMode:
           
            dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay,(long)self.curHour,(long)self.curMin];
            break;
        default:
            
            
            dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay,(long)self.curHour,(long)self.curMin,(long)self.curSecond];
            break;
    }
    if (self.HoldDate == DateBegin) {
        self.beginTime = dateTimeStr;
        self.beginTimeLabel.text = dateTimeStr;
        self.beginTimeLabel.textColor = [UIColor colorWithHexString:@"#6A82FB"];
        self.endTimeLabel.textColor = [UIColor colorWithHexString:@"222222"];
    }else if(self.HoldDate == DateEnd){
        self.endTime = dateTimeStr;
        self.endTimeLabel.text = dateTimeStr;
        self.endTimeLabel.textColor = [UIColor colorWithHexString:@"#6A82FB"];
        self.beginTimeLabel.textColor = [UIColor colorWithHexString:@"222222"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *selectTimeString = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay,(long)self.curHour,(long)self.curMin,(long)self.curSecond];
    NSDate *selectDate = [dateFormatter dateFromString:selectTimeString];
    NSDate *nowDate = self.defaultDate;
    NSString *nowString = [dateFormatter stringFromDate:nowDate];
    NSDate *nowStrDate = [dateFormatter dateFromString:nowString];
    if (NSOrderedAscending == [selectDate compare:nowStrDate]) {//选择的时间与当前系统时间做比较
        [okBtn setEnabled:YES];
    }
    else
    {
        [okBtn setEnabled:YES];
    }
}
//通过日期求星期
- (NSString*)fromDateToWeek:(NSString*)selectDate
{
    NSInteger yearInt = [selectDate substringWithRange:NSMakeRange(0, 4)].integerValue;
    NSInteger monthInt = [selectDate substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger dayInt = [selectDate substringWithRange:NSMakeRange(6, 2)].integerValue;
    int c = 20;//世纪
    NSInteger y = yearInt -1;//年
    NSInteger d = dayInt;
    NSInteger m = monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0:
            weekDay = @"周日";
            break;
        case 1:
            weekDay = @"周一";
            break;
        case 2:
            weekDay = @"周二";
            break;
        case 3:
            weekDay = @"周三";
            break;
        case 4:
            weekDay = @"周四";
            break;
        case 5:
            weekDay = @"周五";
            break;
        case 6:
            weekDay = @"周六";
            break;
        default:
            break;
    }
    return weekDay;
}

- (void)showHcdDateTimePicker
{
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [self->timeBroadcastView setFrame:CGRectMake(0, self.superview.height - kDatePickerHeight - self.BetweenHeight, kScreen_Width, kDatePickerHeight + self.BetweenHeight)];
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weak action:@selector(dismiss:)];
        tap.delegate = self;
        [weak addGestureRecognizer:tap];
        [self->timeBroadcastView setFrame:CGRectMake(0, self.superview.height - kDatePickerHeight - self.BetweenHeight, kScreen_Width, kDatePickerHeight + self.BetweenHeight)];
    }];
}

-(void)dismissBlock:(DatePickerCompleteAnimationBlock)block{
    
    
    typeof(self) __weak weak = self;
    CGFloat height = kDatePickerHeight;
    
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
//        [weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        [timeBroadcastView setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, height)];
        
    } completion:^(BOOL finished) {
        
        block(finished);
        [self removeFromSuperview];
        
    }];
    
}

-(void)dismiss:(UITapGestureRecognizer *)tap{
    
    if( CGRectContainsPoint(self.frame, [tap locationInView:timeBroadcastView])) {
        NSLog(@"tap");
    } else{
        [self dismissBlock:^(BOOL Complete) {
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self ) {
        return NO;
    }
    
    return YES;
}

-(void)selectedButtons:(UIButton *)btns{
    if ([btns.titleLabel.text isEqualToString:@"取消"]) {
        [self dismissBlock:^(BOOL Complete) {
        }];
        return;
    }
    typeof(self) __weak weak = self;
    if (self.isBetween) {
        if (self.beginTime.length == 0 || self.endTime.length == 0) {
            [MBProgressHUD showError:@"请选择完整的时间区间"];
            return;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        switch (self.datePickerMode) {
            case DatePickerDateMode:
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                break;
            case DatePickerTimeMode:
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                break;
            case DatePickerDateTimeMode:
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                break;
            case DatePickerMonthDayMode:
                [dateFormatter setDateFormat:@"MM-dd"];
                break;
            case DatePickerYearMonthMode:
                [dateFormatter setDateFormat:@"yyyy-MM"];
            case DatePickerYearMode:
                [dateFormatter setDateFormat:@"yyyy"];
                break;
            case DatePickerHourMinuteMode:
                [dateFormatter setDateFormat:@"HH:mm"];
            case DatePickerDateHourMinuteMode:
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                break;
            default:
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                break;
        }
        NSDate *dateB = [dateFormatter dateFromString:self.beginTime];
        NSDate *dateA = [dateFormatter dateFromString:self.endTime];
        NSComparisonResult result = [dateA compare:dateB];
        if (result == NSOrderedDescending) {
            [self dismissBlock:^(BOOL Complete) {
                weak.betweenClickedOkBtn(self.beginTime, self.endTime);
            }];
        }else{
            [MBProgressHUD showError:@"结束时间不能早于开始时间"];
            return;
        }
    }else{
        [self dismissBlock:^(BOOL Complete) {
            if (btns.tag == kOKBtnTag) {
                
                switch (self.datePickerMode) {
                    case DatePickerDateMode:
                        dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay];
                        break;
                    case DatePickerTimeMode:
                        dateTimeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)self.curHour,(long)self.curMin,(long)self.curSecond];
                        break;
                    case DatePickerDateTimeMode:
                        dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay,(long)self.curHour,(long)self.curMin,(long)self.curSecond];
                        break;
                    case DatePickerMonthDayMode:
                        dateTimeStr = [NSString stringWithFormat:@"%02ld-%02ld",(long)self.curMonth,(long)self.curDay];
                        break;
                    case DatePickerYearMonthMode:
                        dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld",(long)self.curYear,(long)self.curMonth];
                        break;
                    case DatePickerYearMode:
                        dateTimeStr = [NSString stringWithFormat:@"%ld",(long)self.curYear];
                        break;
                    case DatePickerHourMinuteMode:
                        dateTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)self.curHour,(long)self.curMin];
                        break;
                    case DatePickerDateHourMinuteMode:
                        dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay,(long)self.curHour,(long)self.curMin];
                        break;
                    default:
                        dateTimeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)self.curYear,(long)self.curMonth,(long)self.curDay,(long)self.curHour,(long)self.curMin,(long)self.curSecond];
                        break;
                }
                weak.clickedOkBtn(dateTimeStr);
            } else {
            }
        }];
    }
}

-(BOOL)isLeapYear:(NSInteger)year {
    if ((year%4==0 && year %100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}


@end

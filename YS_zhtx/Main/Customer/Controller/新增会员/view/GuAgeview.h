//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>


@protocol HTGuageViewDelegate <NSObject>

- (void)guageViewDismiss;

@end

@interface GuAgeview : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource,UISearchBarDelegate>
{
@private
    NSArray *array;
}


@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
/*蒙板*/
@property (strong, nonatomic) UIButton *mengban;
/**存储数据*/
@property (copy, nonatomic) NSString *selectNum;
/**存储数据*/
@property (assign, nonatomic) int guMark;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,weak) id <HTGuageViewDelegate> delega;

- (id)initWithTitle:(NSArray *)myArray delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;

@end

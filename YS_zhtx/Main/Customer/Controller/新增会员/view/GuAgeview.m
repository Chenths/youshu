//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "GuAgeview.h"
#define kDuration 0.3

@implementation GuAgeview

@synthesize locatePicker;

- (id)initWithTitle:(NSArray *)myArray delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"GuAgeview" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        self.searchBar.delegate = self;
        //加载数据
        array = myArray;
        self.selectNum = [NSString stringWithFormat:@"%d",0];
    }
    return self;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *result = searchBar.text;
    [searchBar resignFirstResponder];
 
    if (searchBar.text.length > 0) {
        
        for (int i = 0; i < array.count; i ++) {
            NSString *str = array[i];
            if ([str rangeOfString:result].length > 0 ) {
                
                [self.locatePicker selectRow:i inComponent:0 animated:YES];
                [self selectRow:i inComponent:0 animated:YES];
                 self.selectNum = [NSString stringWithFormat:@"%d",i];
                self.guMark =   i;
                return;
            }
        }
    }
}


- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = (id)self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, HMSCREENWIDTH  ,HEIGHT);
    
    //添加蒙板
    _mengban = [[UIButton alloc] initWithFrame:view.bounds];
    _mengban.backgroundColor = RGB(0.0, 0.0,  0.0, 0.3);
    [_mengban addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_mengban];
    [_mengban addSubview:self];
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    
}
-(void)back
{
    [_mengban removeFromSuperview];
    if (self.delega) {
        [self.delega guageViewDismiss];
    }
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   return [array count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   return [array objectAtIndex:row];
           
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
     [self.locatePicker selectRow:row inComponent:0 animated:YES];
     [self.locatePicker reloadComponent:0];
    
     self.selectNum = [NSString stringWithFormat:@"%ld",(long)row];
     self.guMark = (int)row;
}

#pragma mark - Button lifecycle

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = (id)self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    [self back];
    if (array.count == 0) {
        return;
    }
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

@end

//
//  HTChangePriceAlertView.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#define imgWidth 48

#define space 6

#import "HTCahargeProductModel.h"
#import "HTChangePriceAlertView.h"

@interface HTChangePriceAlertView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScollerView;

@property (weak, nonatomic) IBOutlet UIView *textFieldBackView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *okBt;

@property (weak, nonatomic) IBOutlet UIScrollView *backScollerView;

@property (weak, nonatomic) IBOutlet UITextField *firstField;

@property (weak, nonatomic) IBOutlet UITextField *secendField;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountTitle;

@property (nonatomic,assign) CGFloat totalPrice;


@property (nonatomic,assign) HTChangePriceType type;

@end

@implementation HTChangePriceAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self changeCornerRadiusWithRadius:5];
    [self.cancelBt changeCornerRadiusWithRadius:3];
    [self.okBt changeCornerRadiusWithRadius:3];
    [self.textFieldBackView changeCornerRadiusWithRadius:3];
    [self.cancelBt changeBorderStyleColor:[UIColor colorWithHexString:@"222222"] withWidth:1];
    self.backgroundColor = [UIColor whiteColor];
    self.firstField.delegate = self;
    self.secendField.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChangeWithObj:) name:UITextFieldTextDidChangeNotification object:self.firstField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChangeWithObj:) name:UITextFieldTextDidChangeNotification object:self.secendField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePrizeFieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.firstField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.secendField];
    
}

- (instancetype)initWithChangePriceAlertWithType:(HTChangePriceType)type
{
    HTChangePriceAlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"HTChangePriceAlertView" owner:nil options:nil].lastObject;
    [alert setFrame:CGRectMake(16, HEIGHT - (356), HMSCREENWIDTH - 32, 356)];
    alert.type = type;
    if (type == HTChangePrice) {
        alert.titleLabel.text = @"修改价格";
        alert.textField.placeholder = @"输入修改后价格";
        alert.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        alert.textFieldBackView.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
        alert.textField.hidden = NO;
        alert.firstField.hidden = YES;
        alert.secendField.hidden = YES;
        alert.pointLabel.hidden = YES;
        alert.discountTitle.hidden = YES;
        
    }
    if (type == HTChangeDiscount) {
        alert.titleLabel.text = @"设置折扣";
        alert.textField.placeholder = @"设置折扣";
        alert.textField.keyboardType = UIKeyboardTypeDecimalPad;
        
        alert.textFieldBackView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        alert.textField.hidden = YES;
        alert.firstField.hidden = NO;
        alert.secendField.hidden = NO;
        alert.pointLabel.hidden = NO;
        alert.discountTitle.hidden = NO;
        
    }
    return alert;
}
-(void)show{
    KLCPopup *pop = [KLCPopup popupWithContentView:self showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [pop show];
}
-(void)setSelectedArray:(NSArray *)selectedArray{
    _selectedArray = selectedArray;
    self.productCount.text = [NSString stringWithFormat:@"商品%ld件",selectedArray.count];
    CGFloat total = 0;
    CGFloat finall = 0;
    for (HTCahargeProductModel *model in selectedArray) {
        total += model.selectedModel.price.floatValue;
        finall += model.selectedModel.finalprice.floatValue;
    }
    self.totalPrice = total;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.0lf",total];
    self.finallPriceLabel.text  = [NSString stringWithFormat:@"¥%.0lf",finall];
    for (UIView *vv in self.backScollerView.subviews) {
        [vv removeFromSuperview];
    }
    int index = (int)selectedArray.count;
    CGFloat btx = index * (imgWidth + space) > self.backScollerView.width  ? 0 : (self.backScollerView.width -  index * (imgWidth + space) ) * 0.5;
    for (int i = 0; i < index; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(btx, 0, imgWidth, imgWidth)];
        HTCahargeProductModel *mmm = selectedArray[i];
        [image sd_setImageWithURL:[NSURL URLWithString:mmm.selectedModel.productimage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
        [self.backScollerView addSubview:image];
        btx = btx + imgWidth + space;
    }
    self.backScollerView.contentSize = CGSizeMake(btx, imgWidth);
    self.backScollerView.showsVerticalScrollIndicator = NO;
    self.backScollerView.showsHorizontalScrollIndicator = NO;
}


//代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        if (textField == _secendField) {
            if ([_secendField.text isEqualToString:@"0"]) {
                return YES;
            }
            _secendField.text = @"0";
            [_firstField  becomeFirstResponder];
            return NO;
        }
        if (textField == _firstField) {
            return YES;
        }
    }else{
        if (textField == _firstField  && _firstField.text.length == 1 ) {
            return NO;
        }
        if (textField == _secendField && _secendField.text.length == 1) {
            return NO;
        }
    }
    return YES;
}

- (void)textfieldDidChangeWithObj:(NSNotification *)notice{
    UITextField *textField =  notice.object;
    if (textField == self.textField) {
    }else{
        if (_firstField.text.intValue > 0 || _secendField.text.intValue > 0) {
            CGFloat f = _firstField.text.floatValue * 10 + _secendField.text.floatValue;
            CGFloat ttttotal = 0;
            for (HTCahargeProductModel *model in self.selectedArray) {
                NSString *str = [NSString stringWithFormat:@"%lf",f  / 100 * model.selectedModel.price.floatValue];
                NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                                   decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                   scale:0
                                                   raiseOnExactness:NO
                                                   raiseOnOverflow:NO
                                                   raiseOnUnderflow:NO
                                                   raiseOnDivideByZero:YES];
                NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:str];
                NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:@"0.00"];
                NSDecimalNumber *total = [subtotal decimalNumberByAdding:discount withBehavior:roundUp];
                ttttotal += total.floatValue;
            }
            self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%.0lf",ttttotal];
        }else{
        }
        
        if (_firstField.text.length > 0 && _secendField.text.length == 0) {
            [_firstField resignFirstResponder];
            [_secendField becomeFirstResponder];
        }
        if (_firstField.text.length == 0 && _secendField.text.length > 0) {
            [_secendField resignFirstResponder];
            [_firstField becomeFirstResponder];
        }
//        if (_firstField.text.length > 0 && _secendField.text.length > 0) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(setPriceDiscountFinishWithDiscount:)]) {
//                if (self.firstField.text.length > 0) {
//                    if (_changePrizeField.hidden) {
//                        [self.delegate setPriceDiscountFinishWithDiscount:[NSString stringWithFormat:@"0.%@%@",self.firstField.text,self.secendField.text.length == 0 ? @"0":self.secendField.text]];
//                        [self cancelClicked:nil];
//                    }
//
//                }
//            }
//
//        }
    }
}
- (void)changePrizeFieldTextChange:(NSNotification *) notice{
    UITextField *obj = notice.object;
    if (obj == self.textField) {
        self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.textField.text];
    }
}

- (IBAction)cancelBt:(id)sender {
    [KLCPopup dismissAllPopups];
}
- (IBAction)okBtClicked:(id)sender {
    [KLCPopup dismissAllPopups];
    
    if (self.delegate) {
        if (self.type == HTChangeDiscount) {
            CGFloat  discount = _firstField.text.floatValue * 10 + _secendField.text.floatValue;
            [self.delegate hasChangePriceWithDiscount:[NSString stringWithFormat:@"%.2lf",discount / 100]];
        }
        if (self.type == HTChangePrice) {
            [self.delegate hasChangePriceWithFinalPrice:self.textField.text];
        }
       
    }
}


@end

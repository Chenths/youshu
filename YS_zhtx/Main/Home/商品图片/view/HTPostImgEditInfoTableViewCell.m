//
//  HTPostImgEditInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTPostImgEditInfoTableViewCell.h"

@interface HTPostImgEditInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *holdText;

@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UITextView *descText;

@property (weak, nonatomic) IBOutlet UIButton *deleteBt;


@property (weak, nonatomic) IBOutlet UIButton *editCamerImg;

@end
@implementation HTPostImgEditInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.descText.layer.masksToBounds = YES;
    self.descText.layer.cornerRadius = 3;
    self.productImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg)];
    [self.imageView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewtextDidChange:) name:UITextViewTextDidChangeNotification object:self.descText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewtextBigin:) name:UITextViewTextDidBeginEditingNotification object:self.descText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewtextDidEnd:) name:UITextViewTextDidEndEditingNotification object:self.descText];
    
}
- (void)setModel:(HTPostImageModel *)model{
    _model = model;
   
    self.productImg.image = nil;
    if (model.imageSeverUrl.length > 0) {
        [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.imageSeverUrl] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }];
    }else{
        self.productImg.image = [model.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.productImg.contentMode = UIViewContentModeScaleAspectFit;
    self.productImg.clipsToBounds = YES;
    self.descText.text =  model.desc;
    if (model.desc.length > 0) {
        self.holdText.hidden = YES;
    }
    
}
- (IBAction)delBtClicked:(id)sender {
    if (self.delegate) {
        [self.delegate deleteItemWithCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)tapImg{
    if (self.controllerType != ControllerDetail) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeImgTapWithCell:)]) {
            [self.delegate changeImgTapWithCell:self];
        }
    }
}

- (void)setControllerType:(ControllerType)controllerType{
    _controllerType = controllerType;
    switch (controllerType) {
        case ControllerDetail:
        {
            
            self.editCamerImg.hidden = YES;
            self.descText.editable = NO;
            self.deleteBt.hidden = YES;
            self.descText.backgroundColor = [UIColor whiteColor];
            
            
        }
            break;
        case ControllerEdit:
        {
            self.editCamerImg.hidden = NO;
            self.descText.editable = YES;
            self.deleteBt.hidden = NO;
            self.descText.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
           
        }
            break;
        case ControllerPost:
        {
            self.editCamerImg.hidden = NO;
            self.descText.editable = YES;
            self.deleteBt.hidden = NO;
            self.descText.backgroundColor = [UIColor colorWithHexString:@"#E6E8EC"];
        }
            break;
            
        default:
            break;
    }
}
- (void)textViewtextDidChange:(NSNotification *)notic{
    UITextView *textView = notic.object;
    if (textView == self.descText) {
        self.model.desc = self.descText.text;
    }
}
- (void)textViewtextDidEnd:(NSNotification *)notic{
    UITextView *textView = notic.object;
    if (textView == self.descText) {
        if (textView.text.length == 0) {
            self.holdText.hidden = NO;
        }
    }
}
- (void)textViewtextBigin:(NSNotification *)notic{
    UITextView *textView = notic.object;
    if (textView == self.descText) {
        self.holdText.hidden = YES;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.descText];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UITextViewTextDidEndEditingNotification object:self];
}

@end

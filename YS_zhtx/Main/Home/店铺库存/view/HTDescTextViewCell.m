//
//  HTDescTextViewCell.m
//  有术
//
//  Created by mac on 2017/8/14.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTDescTextViewCell.h"
@interface HTDescTextViewCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *decsTextView;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;

@end


@implementation HTDescTextViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.decsTextView changeCornerRadiusWithRadius:3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(desctextDicChange:) name:UITextViewTextDidChangeNotification object:self.decsTextView];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.decsTextView];
}
-(void)setModel:(HTTuneOutOrInDescModel *)model{
    _model = model;
    self.decsTextView.delegate = self;
}

-(void)desctextDicChange:(NSNotification *)notice{
    if (notice.object == self.decsTextView) {
        if (self.decsTextView.text.length == 0) {
            self.holdLabel.hidden = NO;
        }
        self.model.desc = self.decsTextView.text;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.holdLabel.hidden = YES;
    return YES;
}



@end

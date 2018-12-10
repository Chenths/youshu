//
//  HTLianxiViewController.m
//  有术
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "KeyboardToolBar.h"
#import "HTLianxiViewController.h"

@interface HTLianxiViewController ()
@property (weak, nonatomic) IBOutlet UITextField *wechatTextField;
@property (weak, nonatomic) IBOutlet UITextView *wechatTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation HTLianxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.image = [UIImage imageNamed:@"wx_qrcode.jpg"];
    self.wechatTextView.editable = NO;
    self.wechatTextView.backgroundColor = self.view.backgroundColor;
    self.wechatTextView.textContainerInset = UIEdgeInsetsMake(1, 1, 0, 0);
    [KeyboardToolBar unregisterKeyboardToolBarWithTextView:self.wechatTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)callPhoe:(id)sender {
    
    UIButton *bt = sender;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",bt.titleLabel.text];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    bt.enabled = NO;
    
    
}


@end

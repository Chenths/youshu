//
//  HTWarningWebViewController.m
//  有术
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
//
#ifdef DEBUG
#define categoreUrl  @"http://xx.24v5.com/study/studyItemListPage.html?nohead=1&type="
#else
#define categoreUrl  @"http://xx.24v5.com/study/studyItemListPage.html?nohead=1&type="
#endif
#import "HTLoginDataPersonModel.h"
#import <WebKit/WebKit.h>
#import "UIBarButtonItem+Extension.h"
#import "HTWarningWebViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface HTWarningWebViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *dataWebView;

@property (nonatomic,strong) NSString *currentUrl;

@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation HTWarningWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学习中心";
    [self createWebView];
     HTLoginDataPersonModel *model1 = [[HTShareClass shareClass].loginModel person];
    NSString *name = [HTHoldNullObj getValueWithUnCheakValue:model1.name];
    if (self.sendUrl.length > 0) {
        [self.dataWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.sendUrl]]];
    }else{
    if (self.finallUrl.length > 0) {
         [self.dataWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&appCode=%@&userId=%@&companyId=%@&appSecret=%@name=%@",categoreUrl,self.finallUrl,@"rscWTt71Y2JptQh8",[HTShareClass shareClass].loginId,[HTShareClass shareClass].loginModel.companyId,@"2GetNFH0WmXlfzXSzpHuGeJCJAzBPV11",[self encodeToPercentEscapeString:name]]]]];
    }else{
         [self.dataWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@appCode=%@&userId=%@&companyId=%@&appSecret=%@name=%@",@"http://xx.24v5.com/study/studyListPage.html?nohead=1&",@"rscWTt71Y2JptQh8",[HTShareClass shareClass].loginId,[HTShareClass shareClass].loginModel.companyId,@"2GetNFH0WmXlfzXSzpHuGeJCJAzBPV11",[self encodeToPercentEscapeString:name]]]]];
      }
    }
  
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"g-back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    backItem.tintColor = [UIColor colorWithHexString:@"#222222"];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    closeItem.tintColor = [UIColor colorWithHexString:@"#222222"];
    self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
    [self.dataWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.dataWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                       NULL,           (__bridge CFStringRef)input,
                                                                                       NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return
    outputStr;
}


- (void)createWebView{
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem creatBarButtonItemWithTitle:@"分享" target:self action:@selector(rightBtClicked:)];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, HMSCREENWIDTH, 3)];
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    self.progressView.progressTintColor = [UIColor redColor];
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 4.0f);
    [self.view addSubview:self.progressView];
    self.dataWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 3, HMSCREENWIDTH , HEIGHT - nav_height - 3)];
    self.dataWebView.scrollView.backgroundColor = [UIColor whiteColor];
    self.dataWebView.navigationDelegate = self;

    [self.view addSubview:self.dataWebView];
    
    self.dataWebView.scrollView.bounces = NO;
}

- (void)back
{
    NSArray *forwardList = self.dataWebView.backForwardList.backList;
    if (forwardList.count > 0) {
        [self.dataWebView goToBackForwardListItem:[forwardList lastObject]];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtClicked:(UIBarButtonItem *)sender{
    NSArray* imageArray = @[[UIImage imageNamed:@"share_图标"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"知识与你共享"
                                         images:imageArray
                                            url:[NSURL URLWithString:self.currentUrl]
                                          title:self.title
                                           type:SSDKContentTypeAuto];
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.dataWebView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.dataWebView.estimatedProgress animated:YES];
            
            if(self.dataWebView.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    else  if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.dataWebView) {
            self.title = self.dataWebView.title;
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.currentUrl = webView.URL.absoluteString;
}
- (void)dealloc{
    [self.dataWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.dataWebView removeObserver:self forKeyPath:@"title"];
}

@end

//
//  GinPhotoCaptureTipsViewController.m
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/5/16.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <Masonry.h>
#import <Gin_Macro.h>
#import <UIColor+Hex.h>
#import <UIAlertController+GinUnit.h>

#import "GinPhotoCaptureTipsViewController.h"

@interface GinPhotoCaptureTipsViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate>

@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation GinPhotoCaptureTipsViewController

- (void)dealloc
{
    [self.webView removeFromSuperview];
    [self.progressView removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.preferences.javaScriptEnabled = YES;
    
    // 设置Cookie
//    NSString *cookie = [NSString stringWithFormat:@"document.cookie = 'TOKEN=%@';document.cookie = 'webview=native_ios_cv'",[CEUserManager sharedInstance].user.accessToken];
    
//    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
//    [config.userContentController addUserScript:cookieScript];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.bounces = NO;
    
    //    self.webView.allowsBackForwardNavigationGestures = YES;
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];

    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view setNeedsUpdateConstraints];
    

    [self.view addSubview:self.closeBtn];

    [self.view setNeedsUpdateConstraints];
    
    [self showViewControllerAnimated:0.01f];
}

- (void)loadUrl
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
//    [request setValue:[CEUserManager sharedInstance].user.accessToken forHTTPHeaderField:@"X-Auth-Token"];
    
    [self.webView loadRequest:request];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.offset(0);
        }
    }];
    
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(2);
    }];
    
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(20);
        make.size.sizeOffset(CGSizeMake(40, 40));
    }];
}

- (void)showViewControllerAnimated:(CGFloat)seconds
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.view.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.view.alpha = 1;
        }];
    });
}

- (void)dismissViewControllerAnimated
{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.view.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            ;
        }];
    }];
}

#pragma mark- Delegate & DataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {}];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.progressView.alpha = 1;
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [UIAlertController alert:@"提示" message:@"页面打开失败，请稍后重试" cancelTitle:@"确定" cancelBlock:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated];

    } completionBlock:^{
        ;
    }];
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
}

// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//{
//
//}
// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//
//}

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message params:(NSDictionary *)params scriptName:(NSString *)scriptName
{
    
}

#pragma mark- Getter & Setter

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = [UIColor colorWithHex:0xFF571A];
    }
    return _progressView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.layer.cornerRadius = 20;
        _closeBtn.backgroundColor = [UIColor colorWithHex:0x343434a alpha:0.5];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)closeBtnAction:(id)sender
{
    [self dismissViewControllerAnimated];
}


@end

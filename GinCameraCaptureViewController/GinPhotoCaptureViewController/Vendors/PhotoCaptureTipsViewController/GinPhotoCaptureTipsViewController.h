//
//  GinPhotoCaptureTipsViewController.h
//  CommercialVehiclePlatform
//
//  Created by JunhuaShao on 2018/5/16.
//  Copyright © 2018年 JunhuaShao. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface GinPhotoCaptureTipsViewController : UIViewController

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@property (strong, nonatomic) NSString *url;

@end

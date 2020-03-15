//
//  WebViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 14-8-19.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "WebViewController.h"
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceWidth  [UIScreen mainScreen].bounds.size.width

@interface WebViewController ()<UIWebViewDelegate>
{
    UIWebView *_infoWebView;
    UIView *_toolView;
}
@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.title;
    [self initView];
    
}


- (void)initView
{
    _infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KDeviceWidth, KDeviceHeight - 30)];
    [_infoWebView setBackgroundColor:[UIColor clearColor]];
    [_infoWebView setDelegate:self];
    [_infoWebView setOpaque:NO];//使网页透明
    
    if (self.URL.length == 0) {
        return;
    }
    if (![self.URL hasPrefix:@"http://"] && ![self.URL hasPrefix:@"https://"]) {
        
        self.URL = [NSString stringWithFormat:@"http://%@",self.URL];
    }
    NSURL *url = [NSURL URLWithString:self.URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSString* HOST=[NSString stringWithFormat:@"http://pa3.%@",aedudomain];
    
    NSHTTPCookieStorage *myCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [myCookie cookies]) {
        NSLog(@"%@", cookie);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie]; // 保存
    }
    
    // 寻找URL为HOST的相关cookie，不用担心，步骤2已经自动为cookie设置好了相关的URL信息
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:HOST]]; // 这里的HOST是你web服务器的域名地址
    // 比如你之前登录的网站地址是abc.com（当然前面要加http://，如果你服务器需要端口号也可以加上端口号），那么这里的HOST就是http://abc.com
    
    // 设置header，通过遍历cookies来一个一个的设置header
    for (NSHTTPCookie *cookie in cookies){
        
        // cookiesWithResponseHeaderFields方法，需要为URL设置一个cookie为NSDictionary类型的header，注意NSDictionary里面的forKey需要是@"Set-Cookie"
        NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:
                                    [NSDictionary dictionaryWithObject:
                                     [[NSString alloc] initWithFormat:@"%@=%@",[cookie name],[cookie value]]
                                                                forKey:@"Set-Cookie"]
                                                                          forURL:[NSURL URLWithString:HOST]];
        
        // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                           forURL:[NSURL URLWithString:HOST]
                                                  mainDocumentURL:nil];
    }
    
    [_infoWebView loadRequest:request];
    

    

    [self.view addSubview:_infoWebView];

    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - 30, KDeviceWidth, 30)];
    _toolView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [self.view addSubview:_toolView];
    
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousBtn setTitleColor:appColor forState:UIControlStateNormal];
    [previousBtn setTitle: @"<" forState: UIControlStateNormal];
    previousBtn.frame = CGRectMake(10, 0, 30, 30);
    previousBtn.tag = 101;
    [previousBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitleColor:appColor forState:UIControlStateNormal];
    [nextBtn setTitle: @">" forState: UIControlStateNormal];
    nextBtn.tag = 102;
    nextBtn.frame = CGRectMake(285, 0, 30, 30);
    [nextBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolView addSubview:previousBtn];
    [_toolView addSubview:nextBtn];
}

- (void)buttonPressed:(UIBarButtonItem *)sender
{
    switch (sender.tag) {
        case 101:
            [_infoWebView goBack];
            break;
        case 102:
            [_infoWebView goForward];
            break;
            
        default:
            break;
    }
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self show];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self dismiss];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[NSURLCache  sharedURLCache ] removeCachedResponseForRequest:webView.request];
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",webView.request.URL);
    [self dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

@end

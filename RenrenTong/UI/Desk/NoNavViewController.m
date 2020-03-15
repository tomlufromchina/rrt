//
//  NoNavViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 15-2-12.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "NoNavViewController.h"
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceWidth  [UIScreen mainScreen].bounds.size.width

@interface NoNavViewController ()<UIWebViewDelegate>
{
    UIWebView *_infoWebView;
    UIView *_toolView;
}
@end

@implementation NoNavViewController

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

-(void)viewWillAppear:(BOOL)animated{
    statusBarView.backgroundColor=[UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
}

- (void)initView
{
    _infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, KDeviceWidth, KDeviceHeight - 50)];
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
    
    [self setCookieWithHost:[NSString stringWithFormat:@"http://phoneweb.%@",aedudomain]];

    
    [_infoWebView loadRequest:request];
    
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.3];
    [self.view addSubview:view];
    
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
    
    statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    [self.view addSubview:statusBarView];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [[NSURLCache  sharedURLCache ] removeCachedResponseForRequest:webView.request];
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",webView.request.URL);
    return YES;
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self show];
    [[NSURLCache  sharedURLCache ] removeCachedResponseForRequest:webView.request];
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",webView.request.URL);
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString hasSuffix:@"exit.html"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismiss];
    }else{
        [[NSURLCache  sharedURLCache ] removeCachedResponseForRequest:webView.request];
        [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
        NSLog(@"%@",NSStringFromSelector(_cmd));
        NSLog(@"%@",webView.request.URL);
        statusBarView.backgroundColor=theLoginButtonColor;
        [self dismiss];
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[NSURLCache  sharedURLCache ] removeCachedResponseForRequest:webView.request];
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",webView.request.URL);
    [self showImage:nil status:@"呜呜..网络不给力，%>_<%"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setCookieWithHost:(NSString*)HOST{
    
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
}



@end

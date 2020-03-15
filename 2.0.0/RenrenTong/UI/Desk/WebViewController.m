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

@interface WebViewController ()
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
        // Custom initialization
        
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
    _infoWebView.scalesPageToFit = YES;
    [self.view addSubview:_infoWebView];
    [self loadRequestWithString:self.URL];
    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - 30, KDeviceWidth, 30)];
    _toolView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_toolView];
    
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

- (void)loadRequestWithString:(NSString *)string
{
    if (string.length == 0) {
        return;
    }
    if (![string hasPrefix:@"http://"]) {
        
        string = [NSString stringWithFormat:@"http://%@",string];
    }
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_infoWebView loadRequest:request];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

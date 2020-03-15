//
//  FindPasswordViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-30.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FindPasswordViewController

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
    // Do any additional setup after loading the view.
    
    self.title = @"找回密码";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"2.登录www.aedu.cn再次发送重置申请。"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4,11)];
    
    self.contentLabel.attributedText = str;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

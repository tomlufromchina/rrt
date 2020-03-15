//
//  CreateAlbumViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-2.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "CreateAlbumViewController.h"

@interface CreateAlbumViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, weak) UILabel *placeHolderLabel;

@property (nonatomic, strong) NetWorkManager *netWorkManager;

@end

@implementation CreateAlbumViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新建相册";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //Add right button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"新建"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(createAlbum)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.netWorkManager = [[NetWorkManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 30;
    } else {
        return 110;
    }
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTitleCell" forIndexPath:indexPath];
        
        UITextField *textField = (UITextField*)[cell viewWithTag:1];

        textField.layer.borderColor = [UIColor colorWithRed:200.0/255
                                                                 green:200.0/255
                                                                  blue:200.0/255
                                                                 alpha:1.0].CGColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 2.0;
        
        self.textField = textField;
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumDescCell" forIndexPath:indexPath];

        UITextView *textView = (UITextView*)[cell viewWithTag:1];
        UILabel *label = (UILabel*)[cell viewWithTag:2];
        
        textView.layer.borderColor = [UIColor colorWithRed:200.0/255
                                                                 green:200.0/255
                                                                  blue:200.0/255
                                                                 alpha:1.0].CGColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 2.0;
        
        textView.delegate = self;
        
        self.textView = textView;
        self.placeHolderLabel = label;
    }
    
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.placeHolderLabel setHidden:(textView.text.length == 0) ? NO : YES];
}

#pragma mark - Ubility
#pragma mark -
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createAlbum
{
    if (self.textField.text.length <= 0) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"相册名称没有填写哦"];

        return;
    }
    
    
    [self showWithStatus:nil];
    
    __block CreateAlbumViewController *_self = self;
    [self.netWorkManager buildAblum:[RRTManager manager].loginManager.loginInfo.userId
                         AlbumsName:self.textField.text
                        Description:self.textView.text.length <= 0 ? nil : self.textView.text
                            Privacy:@"2"
                            success:^(NSDictionary *photoListArray) {
                                [self dismiss];
                                
                                [_self performSelector:@selector(goBack)
                                            withObject:nil
                                            afterDelay:0.3f];
                                
                                _self.createAlbumBlock();
                                
    } failed:^(NSString *errorMSG) {
        [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"创建相册失败"];

        [_self performSelector:@selector(goBack)
                    withObject:nil
                    afterDelay:1.5f];
    }];
}

@end

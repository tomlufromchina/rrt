//
//  TheSendRecordViewController.m
//  RenrenTong
//
//  Created by 符其彬 on 15/2/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "TheSendRecordViewController.h"
#import "SendRecordCell.h"

@interface TheSendRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *contacts;// 仿重用

    NSMutableArray *_dataSource;
}

@end

@implementation TheSendRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高级设置";
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    if ([self.mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.mainTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    contacts = [NSMutableArray array];
    _dataSource = [NSMutableArray arrayWithObjects:@"发送接受者姓名",@"同时发送给班主任", nil];
    
    for (int i = 0; i <[_dataSource count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"NO" forKey:@"checked"];
        [contacts addObject:dic];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SendRecordCell";
    SendRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SendRecordCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *myString = [[NSUserDefaults standardUserDefaults] stringForKey:@"isSaveStrOne"];
    NSString *myString1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"isSaveStrTow"];

    NSUInteger row = [indexPath row];
    NSMutableDictionary *dic = [contacts objectAtIndex:row];
    
    if (indexPath.row == 0) {
        cell.footTitleLabel.hidden = YES;
        if (myString || [[dic objectForKey:@"checked"] isEqualToString:@"YES"]) {
            [cell setChecked:YES];
        } else{
            [cell setChecked:NO];
        }
    } else if (indexPath.row == 1){
        if (myString1 || [[dic objectForKey:@"checked"] isEqualToString:@"YES"]) {
            [cell setChecked:YES];
        }else{
            [cell setChecked:NO];
        }
    }
    cell.conmentLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SendRecordCell *cell = (SendRecordCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        NSUInteger row = [indexPath row];
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *myString = @"isSaveStrOne";
            [userDefaultes setObject:myString forKey:@"isSaveStrOne"];
            [userDefaultes synchronize];
            
        }else {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSaveStrOne"];
        }
        self.isSendName = 1;
        
    } else if (indexPath.row == 1){
        self.isPublishToClassMaster = 1;
        
        NSUInteger row = [indexPath row];
        NSMutableDictionary *dic = [contacts objectAtIndex:row];
        if ([[dic objectForKey:@"checked"] isEqualToString:@"NO"]) {
            [dic setObject:@"YES" forKey:@"checked"];
            [cell setChecked:YES];
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *myString = @"isSaveStrTow";
            [userDefaultes setObject:myString forKey:@"isSaveStrTow"];
            [userDefaultes synchronize];
            
        }else {
            [dic setObject:@"NO" forKey:@"checked"];
            [cell setChecked:NO];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isSaveStrTow"];
        }
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(clickTableViewCell:WithIsPublishToClassMaster:)]) {
            [self.delegate clickTableViewCell:self.isSendName WithIsPublishToClassMaster:self.isPublishToClassMaster];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


@end

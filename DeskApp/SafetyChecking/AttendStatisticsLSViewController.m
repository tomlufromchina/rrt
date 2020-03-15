//
//  AttendStatisticsLSViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-10-9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AttendStatisticsLSViewController.h"

@interface AttendStatisticsLSViewController ()

@end

@implementation AttendStatisticsLSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"考勤异常名单";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    datasource=[[NSMutableArray alloc] init];
    if (self.data) {
        mdic=[[NSMutableDictionary alloc] init];
        for (ClassNoSwipingCardNumber *cnsc in self.data) {
            NSArray* arr=cnsc.UsersList;
            for (int i=0; i<[arr count]; i++) {
                NSDictionary* dic=[arr objectAtIndex:i];
                if ([[mdic allKeys] containsObject:[dic objectForKey:@"key"]]) {
                    if (self.type==0) {
                        int v=[[mdic objectForKey:[dic objectForKey:@"key"]] intValue];
                        v+=[[dic objectForKey:@"value"] intValue];
                        [mdic setObject:[NSNumber numberWithInt:v] forKey:[dic objectForKey:@"key"]];
                    }
                    
                }else{
                    [mdic setObject:[NSNumber numberWithInt:[[dic objectForKey:@"value"] intValue]] forKey:[dic objectForKey:@"key"]];
                }
            }
        }
        if (mdic) {
            NSArray* arr=[mdic allValues];
            NSMutableDictionary* temp=[[NSMutableDictionary alloc] init];
            for (NSNumber* str in arr) {
                if (![[temp allValues] containsObject:str]) {
                    [temp setObject:str forKey:str];
                    [datasource addObject:str];
                }
            }
        }
    }
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview setSeparatorColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datasource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }else{
        return 30;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* labletext=@"";
    NSNumber *num=[datasource objectAtIndex:indexPath.section];
    NSArray* keys=[mdic allKeys];
    for (NSString *key in keys) {
        int v= [[mdic objectForKey:key] intValue];
        if (v==[num intValue]) {
            if (labletext.length>0) {
                labletext=[NSString stringWithFormat:@"%@、%@",labletext,key];
            }else{
                labletext=key;
            }
        }
    }
    UIFont *font = [UIFont systemFontOfSize:12];
    //设置一个行高上限
    CGSize size = CGSizeMake(SCREENWIDTH-20,2000);

    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [labletext boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize.height+20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    [datasource sortedArrayUsingSelector:@selector(compare:)];
    
    
    switch (self.type) {
        case 0:
            return [NSString stringWithFormat:@"%@ x%d",@"考勤异常",[[datasource objectAtIndex:section] intValue]];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@ x%d",@"迟到",[[datasource objectAtIndex:section] intValue]];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@ x%d",@"早退",[[datasource objectAtIndex:section] intValue]];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@ x%d",@"未刷卡",[[datasource objectAtIndex:section] intValue]];
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"AttendsvlsCell";
    //自定义cell类
    AttendsvlsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttendsvlsCell" owner:self options:nil] lastObject];
    }
    
    NSString* labletext=@"";
    NSNumber *num=[datasource objectAtIndex:indexPath.section];
    NSArray* keys=[mdic allKeys];
    for (NSString *key in keys) {
        int v= [[mdic objectForKey:key] intValue];
        if (v==[num intValue]) {
            if (labletext.length>0) {
                labletext=[NSString stringWithFormat:@"%@、%@",labletext,key];
            }else{
                labletext=key;
            }
        }
    }
    UIFont *font = [UIFont systemFontOfSize:12];
    //设置一个行高上限
    CGSize size = CGSizeMake(SCREENWIDTH-20,2000);
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [labletext boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    cell.lable.lineBreakMode=NSLineBreakByWordWrapping;
    cell.lable.numberOfLines=0;
    cell.lable.height=retSize.height;
    cell.lable.text=labletext;
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}






- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

@end

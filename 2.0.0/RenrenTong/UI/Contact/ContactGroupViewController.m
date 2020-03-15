//
//  ContactGroupViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ContactGroupViewController.h"
#import "ContactDetailViewController.h"
#import "ViewControllerIdentifier.h"

@interface ContactGroupViewController ()

@end

@implementation ContactGroupViewController

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
    
    self.title = @"高三（1）班";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 320, 21)];
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont fontWithName:@"Arial" size:13];
    
    label.text = section == 0 ? @"老师" : @"学生";
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, 21, 320, 1);
    line.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1];
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 22)];
    [sectionView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
    [sectionView addSubview:label];
    [sectionView addSubview:line];
    
    return sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 2;
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactGroupCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:ContactDetailVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:^(UIViewController *viewController) {
        ContactDetailViewController *vc = (ContactDetailViewController*)viewController;
        if (indexPath.section == 0) {
            vc.bMyFirend = YES;
        } else {
            vc.bMyFirend = NO;
        }
    }];
}

@end

//
//  MoileContactTableViewController.m
//  RenrenTong
//
//  Created by 司月皓 on 14-7-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "MoileContactTableViewController.h"
#import "InviteMoilersViewController.h"

@interface MoileContactTableViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation MoileContactTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"手机联系人";
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    
    
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoileContactCell" forIndexPath:indexPath];
    
    UIButton *acceptBtn = (UIButton*)[cell viewWithTag:4];
    UIButton *addBtn = (UIButton*)[cell viewWithTag:5];
    UILabel *label = (UILabel*)[cell viewWithTag:6];
    
    acceptBtn.layer.cornerRadius = 2.0;
    [acceptBtn addTarget:self action:@selector(acceptFirend:) forControlEvents:UIControlEventTouchUpInside];
    acceptBtn.backgroundColor = appColor;
    
    addBtn.layer.cornerRadius = 2.0;
    [addBtn addTarget:self action:@selector(addFirend:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.layer.borderColor = appColor.CGColor;
    addBtn.layer.borderWidth = 1.0f;
    [addBtn setTitleColor:appColor forState:UIControlStateNormal];
    
    //判断
    if (indexPath.row == 0 || indexPath.row == 1) {
        [acceptBtn setHidden:YES];
        [addBtn setHidden:YES];
        [label setHidden:NO];
    }
    if (indexPath.row == 2) {
        [acceptBtn setHidden:YES];
        [addBtn setHidden:NO];
        [label setHidden:YES];
    }
    if (indexPath.row == 3 || indexPath.row == 4) {
        [acceptBtn setHidden:NO];
        [addBtn setHidden:YES];
        [label setHidden:YES];
    }
    
    return cell;
}

#pragma mark - tableview delegate
#pragma mark -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:sectionView.bounds];
    [sectionView addSubview:self.searchBar];
    
    return sectionView;
    
}

#pragma mark - button event
#pragma mark -
//邀请
- (void)acceptFirend:(UIButton*)button
{
    [self.navigationController pushViewController:InviteMoileVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:nil];
    
}
//添加好友
- (void)addFirend:(UIButton*)button
{
    

}

//- (void)addFirend:(UIButton*)button
//{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
//    
//    
//    ContactSendVerificationViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:
//                                                 ContactSendVerVCID];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
//                                                                 style:UIBarButtonItemStyleBordered
//                                                                target:nil
//                                                                action:nil];
//    [self.navigationItem setBackBarButtonItem:backItem];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickButton:(id)sender {
    NSLog(@"点击了按钮");
}
@end

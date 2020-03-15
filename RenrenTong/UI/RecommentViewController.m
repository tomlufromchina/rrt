//
//  RecommentViewController.m
//  RenrenTong
//
//  Created by 何丽娟 on 15/5/21.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "RecommentViewController.h"
#import "NoNavViewController.h"

@interface RecommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
    UITableView *table;
}

@end

@implementation RecommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资源推送";
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self message:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(message:)
                                                 name: MESSAGE
                                               object: nil];
    // Do any additional setup after loading the view.
}
-(void)message:(NSNotificationCenter*)notify
{
    dataArray = [[IMCache shareIMCache] queryPacketRecomment:NO uid:[RRTManager manager].loginManager.loginInfo.userId];
    [table reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imageView.tag = 1;
        [cell.contentView addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, SCREENWIDTH - CGRectGetMaxX(imageView.frame) - 10, 25)];
        title.textColor = MainTextColor;
        title.font = [UIFont systemFontOfSize:14];
        title.tag = 2;
        [cell.contentView addSubview:title];
        
        UILabel *describtion = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame), title.frame.size.width, 25)];
        describtion.textColor = MainTextColor;
        describtion.font = [UIFont systemFontOfSize:14];
        describtion.tag = 3;
        [cell.contentView addSubview:describtion];
        
        
    }
    Packet *packe = [dataArray objectAtIndex:indexPath.row];
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1];
    [imageView setImageWithURL:[NSURL URLWithString:packe.message.body.urlpic] placeholderImage:[UIImage imageNamed:@"default"]];
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:2];
    label.text = packe.message.body.urldesc;
    label = (UILabel*)[cell.contentView viewWithTag:3];
    label.text = [NSString stringWithFormat:@"%@         %@ ",packe.message.body.sender,packe.message.body.sendtime];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoNavViewController *VC = [[NoNavViewController alloc] init];
    Packet *packet = [dataArray objectAtIndex:indexPath.row];
    VC.URL = packet.message.body.url;
//    VC.title = @"成绩系统";
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

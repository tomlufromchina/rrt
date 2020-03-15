//
//  AddFriendViewController.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "AddFriendViewController.h"
#import "ContactDetailViewController.h"
#import "BindFamilyViewController.h"
#import "MoileContactTableViewController.h"
#import "SendFriendsListController.h"

@interface AddFriendViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AddFriendViewController

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
    
    self.title = @"添加朋友";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button events
#pragma mark -
- (IBAction)searchBtnClicked:(id)sender
{
    if (self.textField.text.length <= 0) {
        [self showWithTitle:@"请输入用户名哦!" defaultStr:nil];
    } else{
        [self.navigationController pushViewController:SendFriendsListVCID
                                       withStoryBoard:ContactStoryBoardName
                                            withBlock:^(UIViewController *viewController) {
            SendFriendsListController *vc = (SendFriendsListController*)viewController;
            vc.text = self.textField.text;
        }];
    }
}

- (IBAction)bindFamily:(id)sender
{
    [self.navigationController pushViewController:BindFamilyVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:nil];
}

- (IBAction)joinClass:(id)sender
{
    
}

- (IBAction)addMobileContact:(id)sender
{
    [self.navigationController pushViewController:MobileContactVCID
                                   withStoryBoard:ContactStoryBoardName
                                        withBlock:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

@end

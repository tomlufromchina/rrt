//
//  TheAllBullentinsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface TheAllBullentinsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UILabel *selectionLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *allElectsButton;
@property (nonatomic, copy) NSString *classID;

- (IBAction)clickDeleteButton:(UIButton *)sender;
- (IBAction)clickAllElectsButton:(UIButton *)sender;

@end

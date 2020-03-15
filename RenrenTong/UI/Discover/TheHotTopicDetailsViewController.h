//
//  TheHotTopicDetailsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/22.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "HotTopic.h"
#import "TheHotTopicModel.h"
@interface TheHotTopicDetailsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic, strong)TheHotTopicModelList *hotTopic;
@property(nonatomic, assign)int tag;

@end

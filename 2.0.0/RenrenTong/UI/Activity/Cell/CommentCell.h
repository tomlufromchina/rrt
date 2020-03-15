//
//  CommentCell.h
//  TableInTable
//
//  Created by jeffrey on 14-6-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCoreLabel.h"
#import "Comment.h"

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HBCoreLabel *commentLabel;

@property (nonatomic, strong, setter = setCellContent:) Comment *comment;

+ (float)height:(Comment*)comment;

@end

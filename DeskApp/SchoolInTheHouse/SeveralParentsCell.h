//
//  SeveralParentsCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-23.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeveralParentsCell : UICollectionViewCell
{
    BOOL			m_checked;

}
@property (weak, nonatomic) IBOutlet UIButton *groupButton;

- (void)setTheChecked:(BOOL)checked;

@end

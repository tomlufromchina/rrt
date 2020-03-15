//
//  CommunicationPicDetailsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/2/10.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
@protocol CommunicationPicDetailsViewControllerDelegate <NSObject>

- (void)deleteTheImage:(NSMutableArray *)imagesArry WithCurrentIndex:(NSInteger)CurrentIndex;

@end

@interface CommunicationPicDetailsViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *picArry;
@property (nonatomic, assign) int curentDex;
@property(nonatomic, weak)id<CommunicationPicDetailsViewControllerDelegate> delegate;

@end

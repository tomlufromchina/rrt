//
//  ErrorModel.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/21.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "JSONModel.h"

@interface ErrorModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional>*result;
@property (nonatomic,strong) NSNumber <Optional>*st;
@property (nonatomic,strong) NSNumber <Optional>*error;
@property (nonatomic,strong) NSNumber <Optional>*status;
@property (nonatomic,strong) NSString <Optional>*msg;
@end

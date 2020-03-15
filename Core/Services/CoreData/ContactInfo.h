//
//  ContactInfo.h
//  RenrenTong
//
//  Created by jeffrey on 14-8-20.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactInfo : NSManagedObject

@property (nonatomic, retain) NSString * contactId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * py;
@property (nonatomic, retain) NSString * belonger;

@end

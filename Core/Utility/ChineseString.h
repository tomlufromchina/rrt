//
//  ChineseString.h
//  ChineseSort
//
//  Created by Bill on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonSchoolInTheHouse.h"
#import "StudentList.h"
#import "GrouperList.h"
#import "TeacherList.h"
#import "Grouper.h"
#import "MessageModel.h"
@interface ChineseString : NSObject

@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;
@property(retain,nonatomic)CurrentStudent* cstu;// 放一个对象最为属性
@property (retain, nonatomic) CurrentTeacher *cste;
@property (strong, nonatomic) StudentList *student;
@property (strong, nonatomic) GrouperList *grouper;
@property (strong, nonatomic) TeacherList *teacher;
@property (strong, nonatomic) GoodFriend *goodFriend;
@property (strong, nonatomic) Grouper *ctGrouper;



@property (strong, nonatomic) GroupModelMsg *group;
@end

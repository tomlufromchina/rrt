//
//  ObjectsEntity.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-21.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ObjectsEntity.h"

@implementation BaiDuPushParams
static BaiDuPushParams* instance=nil;
+(BaiDuPushParams*)shareBaiDuPushParams{
    @synchronized(self){
        if (instance==nil) {
            instance=[[super alloc] init];
        }
        return instance;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@  %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

@end

@implementation Login

@end

@implementation Contact

/*
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userId        forKey:@"userId"];
    [aCoder encodeObject:self.userName      forKey:@"userName"];
    [aCoder encodeObject:self.school        forKey:@"school"];
    [aCoder encodeObject:self.role          forKey:@"role"];
    [aCoder encodeObject:self.imageUrl      forKey:@"imageUrl"];
    [aCoder encodeObject:self.introduction  forKey:@"introduction"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:self.sex]  forKey:@"sex"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.bFollowed]  forKey:@"bFollowed"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.followsCount] forKey:@"followsCount"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self) {
        self.userId       = [aDecoder decodeObjectForKey:@"userId"];
        self.userName     = [aDecoder decodeObjectForKey:@"userName"];
        self.school = [aDecoder decodeObjectForKey:@"school"];
        self.role             = [aDecoder decodeObjectForKey:@"role"];
        self.imageUrl          = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.introduction  = [aDecoder decodeObjectForKey:@"introduction"];
        
        self.sex     = [[aDecoder decodeObjectForKey:@"sex"] intValue];
        self.bFollowed     = [[aDecoder decodeObjectForKey:@"bFollowed"] boolValue];
        self.followsCount    = [[aDecoder decodeObjectForKey:@"followsCount"] intValue];
    }
    
    return self;
}
 */

@end


@implementation NdividualData


@end

@implementation MyselfDetails


@end

@implementation NewActivity


@end


@implementation BlogList

@end


@implementation NewFriends

@end


@implementation UserOfCombo



@end

@implementation SendFriendDetail


@end

@implementation SendParentsDetail


@end

@implementation WeiboList


@end

@implementation MyDynamic


@end

@implementation PhotoList


@end

@implementation RecentlyPhotos


@end

@implementation Photo


@end

@implementation SeacherObject


@end

@implementation StudentRank


@end

@implementation StudentExam


@end

@implementation TheNotice


@end

@implementation GoodFriend
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",self.UserName];
}
@end

@implementation VisitorModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.UserName forKey:@"UserName"];
    [aCoder encodeObject:self.DateTime forKey:@"DateTime"];
    [aCoder encodeObject:self.Body forKey:@"Body"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.UserName = [aDecoder decodeObjectForKey:@"UserName"];
        self.DateTime = [aDecoder decodeObjectForKey:@"DateTime"];
        self.Body = [aDecoder decodeObjectForKey:@"Body"];
    }
    return self;
}

@end

@implementation MyClassLists


@end

@implementation MyClassListsBulletin


@end

@implementation LogModel


@end

@implementation ReleaseClassArticleList


@end

@implementation EducationInformation

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.Detail forKey:@"Detail"];
    [aCoder encodeObject:self.Title forKey:@"Title"];
    [aCoder encodeObject:self.PublishDate forKey:@"PublishDate"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.Detail = [aDecoder decodeObjectForKey:@"Detail"];
        self.Title = [aDecoder decodeObjectForKey:@"Title"];
        self.PublishDate = [aDecoder decodeObjectForKey:@"PublishDate"];
    }
    return self;
}

@end

@implementation MyClassNewActivity

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.UserName forKey:@"UserName"];
    [aCoder encodeObject:self.DateTime forKey:@"DateTime"];
    [aCoder encodeObject:self.Body forKey:@"Body"];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.UserName = [aDecoder decodeObjectForKey:@"UserName"];
        self.DateTime = [aDecoder decodeObjectForKey:@"DateTime"];
        self.Body = [aDecoder decodeObjectForKey:@"Body"];

    }
    return self;
}

@end

@implementation BlogCommentLists


@end








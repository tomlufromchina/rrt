//
//  UserSession.h
//  AsianEducation
//
//  Created by apple on 13-3-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ObjectsEntity.h"
@interface UserSession : NSObject
{

}
@property(nonatomic,readwrite,retain) Login * user;
+(UserSession*)shareUserSession;
@end

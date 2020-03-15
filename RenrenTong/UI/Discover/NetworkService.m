//
//  NetworkService.m
//  RenrenTong
//
//  Created by aedu on 15/4/8.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "NetworkService.h"

@implementation NetworkService

+(void)getPhotoAblumList:(NSString*)classId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error {

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoAblumList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:cache error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.items);
            };
        }
    }];
//        [JSONHTTPClient getJSONFromURLWithString:url params:dic completion:^(id json, JSONModelError *err) {
//            if (err) {
//                
//                return;
//            }
//            AlbumList *albumList = [[AlbumList alloc] initWithDictionary:json error:nil];
//            if (albumList.result == 1) {
//                if (success) {
//                    success(albumList.items);
//                };
//            }else{
//                error(nil);
//            }
//        }];


}

+(void)getPhotoAblumUpPhotoList:(NSString*)classId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{

    NSString *url = [NSString stringWithFormat:@"http://class.%@/api/ClassAblum",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:cache error:nil];
        if (albumList.result == 1) {
            if (cacheData) {
                cacheData(albumList.items);
            };
        }
    }];
    
}


+(void)updatePhotoDes:(NSString*)ids Des:(NSString*)des Successful:(SuccessfulWithData)success Error:(ErrorWithData)error

{

    
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/UpdatePhotoDes",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"ids",des,@"des",nil];
    
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        AlbumList *albumList = [[AlbumList alloc] initWithString:cache error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.items);
            };
        }
    }];
    
}

+(void)updatePhotoOrLogClassId:(NSString *)classId AblumId:(NSString *)ablumId BatchId:(NSString *)batchId Token:(NSString *)token Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{

    NSString *url = [NSString stringWithFormat:@"http://class.%@/api/PhotoLogAdd",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",ablumId,@"ablumId",batchId,@"batchId",token,@"token",nil];
    [HttpUtil GetWithUrl:url
              parameters:dic
                 success:^(id json) {
                     ErrorModel *errors = [[ErrorModel alloc] initWithString:json
                                                                      error:nil];
                     NSLog(@"%@",json);
                     if (errors.error.intValue != 1) {
                         error(errors.msg);
                     }else{
                         success(nil);
                     }
                     
                 } fail:^(id errorss) {
                     error(errorss);
                 } cache:^(id cache) {
                     
                 }];
}

+(void)getPhotoList:(NSString*)AblumId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoListS",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:AblumId,@"AblumId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetPhotoList *albumList = [[GetPhotoList alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
    }];
    
}

+(void)deletePhoto:(NSString*)objectId TypeId:(NSString*)typeId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/DeletePhoto",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:typeId,@"TypeId",objectId,@"ObjectId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        GetPhotoList *albumList = [[GetPhotoList alloc] initWithDictionary:json error:nil];
        if (albumList.result == 1) {
            success(@"");
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetPhotoList *albumList = [[GetPhotoList alloc] initWithString:cache error:nil];
        if (albumList.result == 1) {
            success(@"");
        }
    }];
    
    
}

+(void)getPhotoDetail:(NSString*)PhotoId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{

    NSString *url = [NSString stringWithFormat:@"http://class.%@/class/GetPhotoDetail",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:PhotoId,@"PhotoId",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetPhotoDetail *albumList = [[GetPhotoDetail alloc] initWithString:json error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.photo);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetPhotoDetail *albumList = [[GetPhotoDetail alloc] initWithString:cache error:nil];
        if (albumList.result == 1) {
            if (success) {
                success(albumList.photo);
            };
        }
    }];
    
}
+(void)getPhotoCommentList:(NSString*)PhotoId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetPhotoCommentList",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:PhotoId,@"PhotoId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetPhotoCommentList *list = [[GetPhotoCommentList alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (success) {
                success(list.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetPhotoCommentList *list = [[GetPhotoCommentList alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (cacheData) {
                cacheData(list.items);
            };
        }
    }];
}

+(void)postPhotoComment:(NSString*)archiveId UserId:(NSString*)userId PId:(NSString*)pId CmmentText:(NSString*)commentText Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/PostPhotoComment",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:archiveId,@"photoId",userId,@"userId",pId,@"pId",commentText,@"commentText",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
    
}
+(void)praisePhoto:(NSString*)PhotoId UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/PraisePhoto",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:PhotoId,@"PhotoId",userId,@"userId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
}



+(void)getArchiveList:(NSString*)classId UserId:(NSString*)userId CategoryId:(NSString*)categoryId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveList",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",categoryId,@"categoryId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        NSLog(@"%@",json);
        ArchiveList *list = [[ArchiveList alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (success) {
                success(list.msg.items);
            }
        }else{
           //返回json是字符串，没有将sting转换成nsdictionagry，所以直接写得数据，有空改过来，直接返回网络返回的数据
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }

    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        ArchiveList *list = [[ArchiveList alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (cacheData) {
                cacheData(list.msg.items);
            }
        }
    }];

    
}
+(void)getArchiveCategoryList:(NSString*)classId  PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveCategoryList",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        ArchiveCategoryList *list = [[ArchiveCategoryList alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (success) {
                success(list.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        ArchiveCategoryList *list = [[ArchiveCategoryList alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (cacheData) {
                cacheData(list.items);
            };
        }
    }];
    
}


+(void)getArchiveDetail:(NSString*)archiveId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveDetail",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:archiveId,@"archiveId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetArchiveDetail *list = [[GetArchiveDetail alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (success) {
                success(list);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetArchiveDetail *list = [[GetArchiveDetail alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (success) {
                success(list);
            };
        }
    }];
}
+(void)deleteArchive:(NSString*)archiveId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/DeleteArchive",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:archiveId,@"archiveId",nil];
    
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
}

+(void)postPublishComment:(NSString*)archiveId UserId:(NSString*)userId PId:(NSString*)pId CmmentText:(NSString*)commentText Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/PostPublishComment",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:archiveId,@"archiveId",userId,@"userId",pId,@"pId",commentText,@"commentText",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
}
+(void)praiseArchive:(NSString*)archiveId UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/PraiseArchive",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:archiveId,@"archiveId",userId,@"userId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
}
+(void)getArchiveCommentList:(NSString*)archiveId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{

    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetArchiveCommentList",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:archiveId,@"archiveId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetPhotoCommentList *list = [[GetPhotoCommentList alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (success) {
                success(list.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetPhotoCommentList *list = [[GetPhotoCommentList alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (cacheData) {
                cacheData(list.items);
            };
        }
    }];
}

+(void)postPhoto:(NSString*)classId Token:(NSString*)token AlbumsId:(NSString*)albumsId BatchId:(NSString*)batchId File:(NSData*)imageData Successful:(SuccessfulWithData)success Error:(error)error
{

    NSString *url = @"http://class.co/api/PhotoUpload";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",token,@"token",albumsId,@"ablumId",batchId,@"batch",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
    
}


+(void)getAdvert:(NSString*)type Token:(NSString*)toKen Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://dsjtj.%@/Api/GetAdvert",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type,@"advertType",toKen,@"toKen",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        Adver *result = [[Adver alloc] initWithString:json error:nil];
        if (result.Status == 1 && result.Data.count > 0) {
            success(result.Data);
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        Adver *result = [[Adver alloc] initWithString:cache error:nil];
        if (result.Status == 1 && result.Data.count > 0) {
            success(result.Data);
        }
    }];
}

+(void)getAuthority:(NSString*)classId UserId:(NSString*)userId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetAuthority",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",userId,@"userId",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:json error:nil];
        if (result.result == 1 ) {
            success(result.items);
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetAuthority *result = [[GetAuthority alloc] initWithString:cache error:nil];
        if (result.result == 1 ) {
            success(result.items);
        }
    }];
}


+(void)getMicroblogComment:(NSString*)microblogId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetMicroblogComment",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:microblogId,@"microblogId",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        GetMicroblogComment *result = [[GetMicroblogComment alloc] initWithString:json error:nil];
        if (result.st == 0 ) {
            success(result.msg.list);
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        GetMicroblogComment *result = [[GetMicroblogComment alloc] initWithString:cache error:nil];
        if (result.st == 0 ) {
            success(result.msg.list);
        }
    }];

}

+(void)postPraise:(NSString*)toKen objectId:(NSString *)objectId typeId:(NSString*)typeId  Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/PostPraise",
                     aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:toKen,@"toKen",objectId,@"objectId",typeId,@"typeId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
    
}

+(void)postReplyComments:(NSString*)UserId commentedObjectId:(NSString *)commentedObjectId body:(NSString *)body typeId:(NSString*)typeId parentId:(NSString*)parentId Successful:(SuccessfulWithData)success Error:(ErrorWithData)error
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/PostReplyComments",
                     aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:UserId,@"UserId",commentedObjectId,@"commentedObjectId",typeId,@"typeId",body,@"body",parentId,@"parentId",nil];
    [HttpUtil PostWithUrl:url parameters:dic success:^(id json) {
        success(@"");
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        
    }];
}
+(void)GetMyClassActivity:(NSString*)toKen PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetMyClassActivity",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:toKen,@"toKen",pageI,@"pageIndex",pageS,@"pageSize",nil];
    
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theMyTendency.st == 0) {
            if (success) {
                success(theMyTendency.msg.list);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theMyTendency.st == 0) {
            if (cache) {
                cacheData(theMyTendency.msg.list);
            }
        }
    }];

}

+(void)GetClassList:(NSString*)userId UserRole:(NSString*)userRole Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetClassList",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",userRole,@"UserRole",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (success) {
                success(list.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        MyCurrentClassListModel *list = [[MyCurrentClassListModel alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (cacheData) {
                cacheData(list.items);
            };
        }
    }];
}
+(void)GetNoticeList:(NSString*)classId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://nmapi.%@/class/GetNoticeList",aedudomain];
    NSString *pageS = [NSString stringWithFormat:@"%d",pageSize];
    NSString *pageI = [NSString stringWithFormat:@"%d",pageIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"classId",pageI,@"pageIndex",pageS,@"pageSize",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        MyCurrentClassModelBulletin *list = [[MyCurrentClassModelBulletin alloc] initWithString:json error:nil];
        if (list.result == 1) {
            if (success) {
                success(list.items);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        MyCurrentClassModelBulletin *list = [[MyCurrentClassModelBulletin alloc] initWithString:cache error:nil];
        if (list.result == 1) {
            if (cacheData) {
                cacheData(list.items);
            };
        }
    }];
}

+(void)GetClassActivity:(NSString*)typeId ClassId:(NSString *)classId UserId:(NSString*)userId PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex Successful:(SuccessfulWithData)success Error:(ErrorWithData)error Cache:(SuccessfulWithData)cacheData
{
    NSString *url = [NSString stringWithFormat:@"http://home.%@/api/GetClassActivity",aedudomain];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:typeId,@"typeId",classId,@"classId",userId,@"userId",[NSString stringWithFormat:@"%d",pageSize],@"pageSize",[NSString stringWithFormat:@"%d",pageIndex],@"pageIndex",nil];
    [HttpUtil GetWithUrl:url parameters:dic success:^(id json) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:json error:nil];
        if (theMyTendency.st == 0) {
            if (success) {
                success(theMyTendency.msg.list);
            };
        }else{
            ErrorModel *erromodel = [[ErrorModel alloc] initWithString:json error:nil];
            error(erromodel.msg);
        }
    } fail:^(id errors) {
        error(errors);
    } cache:^(id cache) {
        TheMyTendency *theMyTendency = [[TheMyTendency alloc] initWithString:cache error:nil];
        if (theMyTendency.st == 0) {
            if (cache) {
                cacheData(theMyTendency.msg.list);
            }
        }
    }];

}
@end

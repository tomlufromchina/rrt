//
//  ToolBar.m
//  RenrenTong
//
//  Created by aedu on 15/3/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "ToolBar.h"
#import "ImageCollectionViewCell.h"

@interface ToolBar()<UICollectionViewDataSource,UICollectionViewDelegate,ImageCollectionCellDelegate>
{
    UICollectionView *photoCollectionView;//图片显示
    NSMutableArray *photoAry;
    UIView *contentCommentView;
}

@end

@implementation ToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = LineColor.CGColor;
        contentCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        contentCommentView.userInteractionEnabled = YES;
        [self addSubview:contentCommentView];
        
        UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        [contentCommentView addSubview:iconBtn];
        self.iconBtn = iconBtn;
        [iconBtn setImage:[UIImage imageNamed:@"fxp-"] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(iocnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(50, 10,  SCREENWIDTH - 110, 30)];
        [contentCommentView addSubview:textView];
        self.textView = textView;
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.backgroundColor = [UIColor whiteColor];
//        self.textView.layer.borderColor = [UIColor colorWithRed:235.0/255
//                                                           green:235.0/255
//                                                            blue:235.0/255
//                                                           alpha:1.0].CGColor;
//        self.textView.layer.borderWidth = 1.0;
        
        UILabel *proLable = [[UILabel alloc]initWithFrame:CGRectMake(53, 12,  SCREENWIDTH - 110, 30)];
        proLable.text = @"一起参与话题吧...";
        [proLable setTextColor:[UIColor lightGrayColor]];
        [contentCommentView addSubview:proLable];
        self.procLable = proLable;
        
        _commentlIneImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(textView.frame) - 2, CGRectGetMaxY(textView.frame) - 5, textView.frame.size.width + 4, 4)];
        _commentlIneImage.image = [UIImage imageNamed:@"dhx-"];
        [contentCommentView addSubview:_commentlIneImage];
        
        UIButton * sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH - 55, 10, 50, 30)];
        [contentCommentView addSubview:sendBtn];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.sendBtn = sendBtn;
        sendBtn.backgroundColor = theLoginButtonColor;
    }
    return self;
}
- (void)sendBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(sendBtnClick)]) {
        [self.delegate sendBtnClick];
    }
}
- (void)iocnBtnClick
{
    if ([self.delegate respondsToSelector:@selector(chooseImage)]) {
        [self.delegate chooseImage];
    }
}
//图片显示
-(void)showPicture:(NSArray *)pictureArray
{
    if (pictureArray.count > 0) {
        if (!photoCollectionView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50) collectionViewLayout:layout];
            [photoCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
            photoCollectionView.delegate = self;
            photoCollectionView.dataSource = self;
            photoCollectionView.backgroundColor = [UIColor whiteColor];
            [self addSubview:photoCollectionView];
            contentCommentView.frame = CGRectMake(0, 50, contentCommentView.frame.size.width, contentCommentView.frame.size.height);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 50, self.frame.size.width, self.frame.size.height +50);
        }
        photoAry = (NSMutableArray*)pictureArray;
        [photoCollectionView reloadData];
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photoAry.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.width = 40;
    cell.isSelectToDelete = YES;
    cell.image.image = [UIImage imageWithContentsOfFile:[photoAry objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)deleteEvent:(id)collectionCell
{
    NSIndexPath *path = [photoCollectionView indexPathForCell:(ImageCollectionViewCell*)collectionCell];
    [photoAry removeObjectAtIndex:path.row];
    if (photoAry.count == 0) {
        [self removePicView];
    }else{
        [photoCollectionView reloadData];
    }
}

-(void)removePicView
{
    contentCommentView.frame = CGRectMake(0, 0, contentCommentView.frame.size.width, contentCommentView.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 50, self.frame.size.width, self.frame.size.height - 50);
    [photoCollectionView removeFromSuperview];
    photoCollectionView = nil;
}
@end

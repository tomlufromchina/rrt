//
//  commentaryToolView.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/10.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "commentaryToolView.h"
#import "ImageCollectionViewCell.h"

@interface commentaryToolView()<UICollectionViewDataSource,UICollectionViewDelegate,ImageCollectionCellDelegate,UITextViewDelegate>
{
    UICollectionView *photoCollectionView;//图片显示
    NSMutableArray *photoAry;
    UIView *contentCommentView;
}

@end
@implementation commentaryToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = LineColor.CGColor;
        
        contentCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        contentCommentView.layer.borderColor = LineColor.CGColor;
        [self addSubview:contentCommentView];
        
        self.iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 8, 35, 35)];
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"pll-"] forState:UIControlStateNormal];
        self.iconBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [self.iconBtn setTitle:@"0" forState:UIControlStateNormal];
        [self.iconBtn addTarget:self action:@selector(iocnBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [contentCommentView addSubview:self.iconBtn];
        
         self.textView = [[UITextView alloc]initWithFrame:CGRectMake(55, 10, SCREENWIDTH - CGRectGetMaxX(_iconBtn.frame) - 75, 30)];
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.delegate = self;
        [contentCommentView addSubview: self.textView];
        
        self.procLable = [[UILabel alloc]initWithFrame:CGRectMake(57, 10,  SCREENWIDTH - 110, 30)];
        self.procLable.text = @"输入评论内容...";
        [self.procLable setTextColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]];
        [contentCommentView addSubview:self.procLable];
        
        _lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textView.frame) - 2, contentCommentView.frame.size.height - 10, self.textView.frame.size.width + 4, 4)];
        _lineImgView.image = [UIImage imageNamed: @"dhx-"];
        [contentCommentView addSubview: _lineImgView];
        
        
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBtn.frame = CGRectMake(SCREENWIDTH - 60, 10, 50, 30);
        self.sendBtn.backgroundColor = theLoginButtonColor;
        [self.sendBtn setTitle:@"发表" forState:UIControlStateNormal];
        [self.sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.sendBtn.layer.masksToBounds = YES;
        self.sendBtn.layer.cornerRadius = 3;
        self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [contentCommentView addSubview:self.sendBtn];
    }
    return self;
}

-(void)reloadLineImageFrame
{
    contentCommentView.frame = CGRectMake(0, contentCommentView.frame.origin.y, SCREENWIDTH, CGRectGetMaxY(_textView.frame) + 10);
    _lineImgView.centerY = contentCommentView.frame.size.height - 10;
}

- (void)sendBtnClick:(UIButton *)btn
{
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(clickSendButton)]) {
        [self.delegate clickSendButton];
    }
}
- (void)iocnBtnClick
{
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(clickCommentaryButon)]) {
        [self.delegate clickCommentaryButon];
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
             contentCommentView.layer.borderWidth = 1;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 50, self.frame.size.width, self.frame.size.height +50);
        }
        photoAry = (NSMutableArray*)pictureArray;
        [photoCollectionView reloadData];
    }
    
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
    contentCommentView.layer.borderWidth = 0;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 50, self.frame.size.width, self.frame.size.height - 50);
    [photoCollectionView removeFromSuperview];
    photoCollectionView = nil;
}


#pragma mark - UICollectionViewdelegate

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

#pragma mark - 评论输入视图高度处理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.procLable.hidden = YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length != 0) {
        self.procLable.hidden = YES;
    } else{
        self.procLable.hidden = NO;
    }
    self.procLable.text = @"输入评论内容";
    CGFloat fixedWidth = self.textView.frame.size.width;
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect textframe = self.textView.frame;
    CGFloat y = newSize.height - textframe.size.height;
    if(y != 0)
    {
        textframe.size.height = newSize.height;
        self.textView.frame = textframe;
        CGRect frame = self.frame;
        frame.origin.y = self.frame.origin.y - y;
        frame.size.height = frame.size.height + y;
        self.frame = frame;
        self.iconBtn.centerY = self.textView.centerY;
        self.sendBtn.centerY = self.textView.centerY;
    }
    [self reloadLineImageFrame];
}

-(void)RecoverFrame
{
    [self textViewDidChange:self.textView];
}

@end

//
//  DoodleViewController.m
//  RenrenTong
//
//  Created by 唐彬 on 14-10-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "DoodleViewController.h"

@interface DoodleViewController ()

@end

@implementation DoodleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"涂鸦";
    self.view.backgroundColor=[UIColor whiteColor];
    eraser=NO;
    drawimgs=[[NSMutableArray alloc] init];
    UINavigationBar* nav=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    nav.backgroundColor=appColor;
    UINavigationItem* nitem=[[UINavigationItem alloc] initWithTitle:self.title];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(tycancel)];
    nitem.leftBarButtonItem=cancelItem;
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(tydone)];
    nitem.rightBarButtonItem=doneItem;
    [nav pushNavigationItem:nitem animated:YES];
    [self.view addSubview:nav];
    
    
    pintView = [[MyView alloc] initWithFrame:CGRectMake(0,nav.height, SCREENWIDTH, self.view.height-nav.height-50) ];
    [self.view addSubview:pintView];
    self.selectedColor=[UIColor whiteColor];
    
    UIView* pintToolView=[[UIView alloc] initWithFrame:CGRectMake(0, pintView.bottom, SCREENWIDTH, 50)];
    pintToolView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:pintToolView];
    
    NSArray* toolbtnnomals=@[@"eraser_nomal",@"paint_nomal",@"clear_nomal",@"take_a_photo_nomal",@"from_alumn_nomal"];
    NSArray* toolbtnpresseds=@[@"eraser_pressed",@"paint_pressed",@"clear_pressed",@"take_a_photo_pressed",@"from_alumn_pressed"];
    for (int i=0; i<[toolbtnnomals count]; i++) {
        UIButton* toolbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        int width=SCREENWIDTH/[toolbtnnomals count];
        toolbtn.frame=CGRectMake(width*i+(width-40)*0.5, 2, 40, 40);
        [toolbtn setBackgroundImage:[UIImage imageNamed:[toolbtnnomals objectAtIndex:i]] forState:UIControlStateNormal];
        [toolbtn setBackgroundImage:[UIImage imageNamed:[toolbtnpresseds objectAtIndex:i]] forState:UIControlStateSelected];
        toolbtn.tag=i;
        [toolbtn addTarget:self action:@selector(toolbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [pintToolView addSubview:toolbtn];
    }
}

- (void)showDateAlertWithTag:(int)tag {
    KZColorPicker *picker = [[KZColorPicker alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-40, 250)];
    picker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    picker.selectedColor = self.selectedColor;
    picker.tag=88888;
    [picker.sizeslider setValue:pintView.lineWidth animated:YES];
    picker.sizelable.text=[NSString stringWithFormat:@"%d",(int)pintView.lineWidth];
    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    AttendAlertView* alertView=[[AttendAlertView alloc] init];
    alertView.delegate=self;
    alertView.tag=tag;
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消",@"确定", nil]];//添加按钮
    [alertView setContainerView:picker];
    [alertView show];
}

-(void)toolbtnClick:(UIButton*)sender{
    if (sender.tag==0) {
        eraser=!eraser;
        if (eraser) {
            pintView.lineColor = [UIColor whiteColor];
        }else {
            pintView.lineColor=self.selectedColor;
        }
        for (int i=0; i<[drawimgs count]; i++) {
            DoodleToolImageView* img=[drawimgs objectAtIndex:i];
            [img selfRemoveFromSuperview];
        }
        [drawimgs removeAllObjects];
        return;
    }
    if (sender.tag==1) {
        [self showDateAlertWithTag:888];
        return;
    }
    if (sender.tag==2) {
        [drawimgs removeAllObjects];
        [pintView clean];
        return;
    }
    if (sender.tag==3) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else
        {
            [self showImage:[UIImage imageNamed:@"confirm-err72.png"] status:@"该设备不支持拍照"];

        }
        return;
    }
    if (sender.tag==4) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
        return;
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        DoodleToolImageView *img=[[DoodleToolImageView alloc] init];
        img.pintview=pintView;
        CGSize psize=pintView.bounds.size;
        CGSize isize= image.size;
        if (isize.width>psize.width) {
            img.width=pintView.width;
            img.height=pintView.height;
        }else{
            img.width=isize.width;
            img.height=isize.height;
        }
        img.image=image;
        [img addTopTool];
        img.left=(pintView.width-img.width)*0.5;
        img.top=(pintView.height-img.height)*0.5;
        img.delegate=self;
        [pintView addSubview:img];
        [drawimgs addObject:img];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeLayerTopWithUIimage:(DoodleToolImageView*)img{
    [drawimgs removeObject:img];
    [drawimgs addObject:img];
}
-(void) remveDtI:(DoodleToolImageView*)img{
    [drawimgs removeObject:img];
}


- (void)customAttendAlertViewButtonTouchUpInside: (AttendAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView.tag==888) {
            KZColorPicker *pintcp=(KZColorPicker *)[alertView viewWithTag:88888];
            if (pintcp) {
                eraser=NO;
                self.selectedColor = pintcp.selectedColor;
                pintView.lineColor = pintcp.selectedColor;
                pintView.lineWidth = [pintcp.sizelable.text intValue];
            }
        }
        for (int i=0; i<[drawimgs count]; i++) {
            DoodleToolImageView* img=[drawimgs objectAtIndex:i];
            [img drawImg];
        }
        [drawimgs removeAllObjects];
    }
    [alertView close];
}


- (void) pickerChanged:(KZColorPicker *)cp
{
    
}

-(void)tycancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tydone{
//    UIImage* img=[self imageWithUIView:pintView];
    UIImage* img=[self screenShot];
    if (img&&self.doodledelegate) {
        [self.doodledelegate DoodleWithUIImage:img];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(UIImage*)screenShot{
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
//    截屏代码
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREENWIDTH*scale_screen,SCREENHEIGHT*scale_screen), YES, 0);
    
    //设置截屏大小
    
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    
    CGRect rect = CGRectMake(0, 64*scale_screen, SCREENWIDTH*scale_screen, (SCREENHEIGHT-64-50)*scale_screen);//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    
    
    //以下为图片保存代码
    

    
    CGImageRelease(imageRefRect);
    return sendImage;
    
    //从手机本地加载图片
}

/*
 uiview转化为uiimage
 */
- (UIImage*) imageWithUIView:(UIView*) view{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    //[view.layer drawInContext:currnetContext];
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}


@end

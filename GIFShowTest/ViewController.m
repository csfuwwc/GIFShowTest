//
//  ViewController.m
//  GIFShowTest
//
//  Created by 宇信 on 4/30/14.
//  Copyright (c) 2014 LYP. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import "GifView.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //获得gif图片数据
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"run" ofType:@"gif"];
    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    
    
    [self showImageByImageViewAnimation:fileData];
    [self showimagesByWebView:fileData];
    
   // GifView * gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, self.showThirdView.bounds.size.width, self.showThirdView.bounds.size.height) data:fileData];
    GifView * gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, self.showThirdView.bounds.size.width, self.showThirdView.bounds.size.height)  filePath:filePath];
    [self.showThirdView addSubview:gif];
    
}

/**************UIImageViewAnimation显示gif图片**************/
-(void)showImageByImageViewAnimation:(NSData *)fileData
{
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, NULL);
    
    //用于存储图片得数组
    NSTimeInterval  imageAnimationDuration = 0.0;
    NSMutableArray * imagesArray = [NSMutableArray arrayWithCapacity:0];
    
    size_t m = CGImageSourceGetCount(src);
    
    if (m>1)
    {
        for (size_t i=0; i<m; i++)
        {
            //获得每一祯图片对象
            CGImageRef perImage = CGImageSourceCreateImageAtIndex(src, i, NULL);
            DT(@"perImage--->%@",perImage);
            //获得每一祯图片信息
            NSDictionary * dic = (__bridge NSDictionary *)(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            DT(@"dic---%@",dic);
            
            //按序存储所有图片
            if (perImage)
            {
                [imagesArray addObject:[UIImage imageWithCGImage:perImage]];
                CGImageRelease(perImage);
            }
            
            //获得动画时间
            if (dic)
            {
                NSDictionary * tempDic =  [dic objectForKey:@"{GIF}"];
                DT(@"tempDic---%@",tempDic);
                imageAnimationDuration += [[tempDic objectForKey:@"DelayTime"] doubleValue];
                DT(@"time----%@",[tempDic objectForKey:@"DelayTime"]);
            }
        }
    }
    self.showImageView.animationImages = imagesArray;
    self.showImageView.animationDuration = imageAnimationDuration;
    [self.showImageView startAnimating];
}

/****************UIWebView显示gif图片****************/
-(void)showimagesByWebView:(NSData *)fileData
{
    //除非gif图片背景也是透明，否则gif图片加载后会有原背景显示。
    [self.showWebView loadData:fileData MIMEType:@"image/gif" textEncodingName:Nil baseURL:Nil];
    self.showWebView.backgroundColor = [UIColor clearColor];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  AFNetWorkingText
//
//  Created by kingyee on 16/7/12.
//  Copyright © 2016年 kingyee. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"
@interface ViewController ()<UIAlertViewDelegate>
{

    UILabel *_lable;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [imageView setImageWithURL:[NSURL URLWithString:@"http://static.udz.com/statics/app/images/bannerlvbb2.jpg"] placeholderImage:nil];
    [self.view addSubview:imageView];
    
    
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    button.center=self.view.center;
    button.backgroundColor=[UIColor grayColor];
    [button setTitle:@"获取缓存" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _lable=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+100, 100, 40)];
    _lable.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_lable];
    
    
    UIButton *clearBtn=[[UIButton alloc]initWithFrame:CGRectMake(_lable.frame.origin.x, _lable.frame.origin.y+100, 100, 40)];
    clearBtn.backgroundColor=[UIColor blueColor];
    [clearBtn setTitle:@"清除缓存" forState:UIControlStateNormal];
    [self.view addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:UIControlEventTouchUpInside];

    
    
    
}
-(void)clickAction
{

    [self folderPath];
    

}
-(void)clearBtnAction
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"是否清楚缓存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}
//获取文件夹的大小
-(float)folderPath
{
    NSDictionary *dict=[[NSBundle mainBundle]infoDictionary];
    NSString *identifier=[dict objectForKey:@"CFBundleIdentifier"];
    
    NSString *filePath=[NSString stringWithFormat:@"/%@/%@/%@/%@/%@/%@",NSHomeDirectory(),@"Library",@"Caches",identifier,@"com.alamofire.imagedownloader",@"fsCachedData"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) return 0;
    
    
    NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:filePath] objectEnumerator];
    
    
    NSString* fileName;
    
    
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [filePath stringByAppendingPathComponent:fileName];
//        NSString *fileN=[[NSString alloc]initWithCString:fileName encoding:NSUTF8StringEncoding];
        folderSize += [self fileSizeAtPath:fileAbsolutePath]/1024;
    }
    if (folderSize<1024) {
        _lable.text=[NSString stringWithFormat:@"%.2lldkb",folderSize];
    }
    if (folderSize>1024&&folderSize<1024*1024) {
        _lable.text=[NSString stringWithFormat:@"%.2lldM",folderSize/1024];
    }
    return folderSize;
    
    
    
    
    

    
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(void)clearFolder
{
    NSDictionary *dict=[[NSBundle mainBundle]infoDictionary];
    NSString *identifier=[dict objectForKey:@"CFBundleIdentifier"];
    
    NSString *filePath=[NSString stringWithFormat:@"/%@/%@/%@/%@",NSHomeDirectory(),@"Library",@"Caches",identifier];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) return;
    if ([fileManager fileExistsAtPath:filePath]) {

        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    
    
   

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==1) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 0), ^{
            [self clearFolder];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _lable.text=[NSString stringWithFormat:@"%f",[self folderPath]];
                
            });
            
        });
        
        
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

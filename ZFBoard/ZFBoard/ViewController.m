//
//  ViewController.m
//  ZFBoard
//
//  Created by 张帆 on 2018/12/19.
//  Copyright © 2018 张帆. All rights reserved.
//

#import "ViewController.h"
#import "ZFboard/ZFBoard.h"

@interface ViewController ()
@property (nonatomic, strong) ZFBoard *board;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (IBAction)show:(id)sender {
    ZFBoard *board = [[ZFBoard alloc] init];
    self.board = board;
    ZFBoardItem *item = [[ZFBoardItem alloc] init];
    item.title = @"更新·Gladius Pro";
    item.imageName = @"device_pic";
    item.detial1text = @"更新版本:1.5.3.2";
    item.detial2text = @"当前版本:1.0.0.0";
    item.introduceText = @"【1】优化缩略图生成方法，避免由其导致的SD卡损坏\n【2】增加一些新的相机可调整参数\n升级可能会重启两次";
    item.actionButtonTitle = @"开始更新";
    item.actionButtonAction = ^(ZFBoardButton * _Nonnull button) {
        [board loadNext];
    };
    
    
    ZFBoardItem *item1 = [[ZFBoardItem alloc] init];
    item1.title = @"更新·Gladius Pro";
    item1.imageName = @"device_pic";
    item1.detial2text = @"请保证互联网的正常连接";
    item1.actionButtonTitle = @"下载固件";
    item1.actionButtonAction = ^(ZFBoardButton * _Nonnull button) {
        board.boardVc.actionButton.type = ZFBoardButtonTypeLOADING;
        [board.boardVc.actionButton setTitle:@"正在尝试下载更新" forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            float f = 0;
            __block typeof(f) weak_f = f;
            NSTimer *tier = [NSTimer timerWithTimeInterval:.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                
                NSString *title = [NSString stringWithFormat:@"正在下载固件 %d%%", (int)(weak_f * 100)];
                [button setTitle:title forState:UIControlStateNormal];
                [button setProgress:weak_f];
                if (weak_f > 1) {
                    [timer invalidate];
                    [self.board loadNext];
                    return;
                }
                weak_f += .05;
            }];
            [[NSRunLoop currentRunLoop] addTimer:tier forMode:NSRunLoopCommonModes];
        });
    };
    
    
    ZFBoardItem *item2 = [[ZFBoardItem alloc] init];
    item2.title = @"更新·Gladius Pro";
    item2.imageName = @"device_pic";
    item2.actionButtonTitle = @"上传固件";
    item2.detial2text = @"上传固件前请保证已连接机器WIFI";
    item2.actionButtonAction = ^(ZFBoardButton * _Nonnull button) {
        board.boardVc.actionButton.type = ZFBoardButtonTypeLOADING;
        [board.boardVc.actionButton setTitle:@"正在尝试上传固件" forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            float f = 0;
            __block typeof(f) weak_f = f;
            NSTimer *tier = [NSTimer timerWithTimeInterval:.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                
                NSString *title = [NSString stringWithFormat:@"正在上传固件 %d%%", (int)(weak_f * 100)];
                [button setTitle:title forState:UIControlStateNormal];
                [button setProgress:weak_f];
                if (weak_f > 1) {
                    [timer invalidate];
                    [self.board loadNext];
                    return;
                }
                weak_f += .05;
            }];
            [[NSRunLoop currentRunLoop] addTimer:tier forMode:NSRunLoopCommonModes];
        });
        
    };
    
    
    
    
    ZFBoardItem *item3 = [[ZFBoardItem alloc] init];
    item3.title = @"更新·Gladius Pro";
    item3.imageName = @"device_pic";
    item3.actionButtonTitle = @"更新中";
    item3.didShow = ^(ZFBoardItem * _Nonnull x) {
        board.boardVc.actionButton.type = ZFBoardButtonTypeUNABLE;
    };
    
  
    item.next(item1).next(item2).next(item3);
    [board showItem:item];

}




@end

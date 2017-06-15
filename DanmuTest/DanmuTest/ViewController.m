//
//  ViewController.m
//  DanmuTest
//
//  Created by WangChen on 17/6/15.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import "ViewController.h"
#import <BarrageRenderer.h>
#import "MyBarrageWalkTextSprite.h"

@interface ViewController ()

@property (nonatomic, strong) BarrageRenderer           *renderer;
@property (nonatomic, strong) NSTimer                   *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureUI];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(autoSenderDanmu) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}


- (void)dealloc {
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark -
#pragma mark - --事件响应
- (IBAction)buttonClick:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    
    switch (tag) {
        case 0:
        {
            //开始
            [self.renderer start];
            [self.timer setFireDate:[NSDate distantPast]];
        }
            break;
        case 1:
        {
            //暂停
            [self.renderer pause];
            [self.timer setFireDate:[NSDate distantFuture]];
        }
            break;
        case 2:
        {
            //停止
            [self.renderer stop];
            [self.timer setFireDate:[NSDate distantFuture]];
        }
            break;
        case 3:
        {
            //发送弹幕
            
        }
            break;
        default:
            break;
    }
}

///弹幕数据模拟
- (void)autoSenderDanmu {
    
    NSArray *types = @[@(0), @(1), @(2)];
    
    NSNumber *t = types[arc4random()%types.count];
    
    switch (t.integerValue) {
        case 0:
            //正常从右向左
            [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideDefault]];
            break;
        case 1:
            //顶部悬浮
            [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideDefault]];
            break;
        case 2:
            //底部悬浮
            [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideDefault]];
            break;
        default:
            break;
    }
}

- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side
{
    static NSInteger index = 0;
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([MyBarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"过场文字弹幕:%ld",index++];
    descriptor.params[@"textColor"] = [UIColor blueColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
//    descriptor.params[@"clickAction"] = ^{
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alertView show];
//    };
    return descriptor;
}



#pragma mark -
#pragma mark - --Configure UI
- (void)configureUI {
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 40)];
    [imageView setImage:[UIImage imageNamed:@"2bbabed235715b1418c7d26e9256bcee.jpg"]];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    self.renderer = [[BarrageRenderer alloc] init];
    [imageView addSubview:_renderer.view];
    
    _renderer.canvasMargin = UIEdgeInsetsMake(40, 40, CGRectGetHeight(imageView.frame) - 40 - 200, 40);
    _renderer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [imageView sendSubviewToBack:_renderer.view];
}

#pragma mark -
#pragma mark - < Lazy Loading >
//- (BarrageRenderer *)renderer {
//    
//    if(!_renderer)
//    {
//        
//    }
//    return _renderer;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

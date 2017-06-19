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
#import "MyBarrageFloatTextSprite.h"
#import "MySenderWalkTextSprite.h"
#import "MySenderFloatTextSprite.h"

//View
#import "BarrageSenderView.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BarrageRenderer           *renderer;
@property (nonatomic, strong) NSTimer                   *timer;

@property (nonatomic, strong) BarrageSenderView         *senderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureUI];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(autoSenderDanmu) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)dealloc {
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            [self startSenderBarrage];
        }
            break;
        default:
            break;
    }
}

///弹幕数据模拟
- (void)autoSenderDanmu {
    
    NSArray *types = @[@(0), @(1), @(2), @(3)];
    
    NSNumber *t = types[arc4random()%types.count];
    
    switch (t.integerValue) {
        case 0:
            //正常从右向左
            [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideDefault]];
            break;
        case 1:
            //顶部悬浮
            [self.renderer receive:[self floatTextSpriteDescriptorWithDirection:BarrageFloatDirectionT2B side:BarrageFloatSideCenter]];
            break;
        case 2:
            //底部悬浮
//            [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideDefault]];
            [self.renderer receive:[self floatTextSpriteDescriptorWithDirection:BarrageWalkDirectionB2T side:BarrageFloatSideCenter]];
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
    descriptor.params[@"fontSize"] = @(21);
//    descriptor.params[@"clickAction"] = ^{
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alertView show];
//    };
    return descriptor;
}

/// 生成精灵描述 - 浮动文字弹幕
- (BarrageDescriptor *)floatTextSpriteDescriptorWithDirection:(NSInteger)direction side:(BarrageFloatSide)side
{
    static NSInteger index = 0;
    
    UIColor *color = direction == BarrageFloatDirectionT2B ? [UIColor redColor] : [UIColor purpleColor];
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([MyBarrageFloatTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"悬浮文字弹幕:%ld",(long)index++];
    descriptor.params[@"textColor"] = color;
    descriptor.params[@"duration"] = @(3);
    descriptor.params[@"fadeInTime"] = @(1);
    descriptor.params[@"fadeOutTime"] = @(1);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
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
    
//    _renderer.canvasMargin = UIEdgeInsetsMake(40, 40, CGRectGetHeight(imageView.frame) - 40 - 200, 40);
    _renderer.canvasMargin = UIEdgeInsetsZero;
    _renderer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [imageView sendSubviewToBack:_renderer.view];
}

#pragma mark -
#pragma mark - -- < TextFieldDelegate >
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self stopSenderBarrage];
    
    return YES;
}

#pragma mark -
#pragma mark - -- < Logic Helper >
- (void)startSenderBarrage {
    
    [self.senderView.textField becomeFirstResponder];
}

- (void)keyboardChanged:(NSNotification *)notify {
    
    CGRect frame = [[notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat reduce = CGRectGetHeight([UIScreen mainScreen].bounds) - frame.origin.y;
    
    if(reduce > 0)
        reduce += 70;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.senderView.transform = CGAffineTransformMakeTranslation(0, -reduce);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)stopSenderBarrage {
    
    [self.senderView.textField resignFirstResponder];
    
    if(self.senderView.textField.text != nil
       && ![self.senderView.textField.text isEqualToString:@""]
       && self.senderView.textField.text.length > 0) {
        BarrageDescriptor *descriptor = [[BarrageDescriptor alloc] init];
        
        
        if(self.senderView.barrageStyle == SendBarrageTypeRightToLeft) {
            
            
            descriptor.spriteName = NSStringFromClass([MySenderWalkTextSprite class]);
            descriptor.params[@"text"] = self.senderView.textField.text;
            descriptor.params[@"textColor"] = self.senderView.textColor;
            descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
            descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
            descriptor.params[@"side"] = @(0);
            descriptor.params[@"font"] = @(17);
            
        }else {
            
            NSInteger deriction = self.senderView.barrageStyle == SendBarrageTypeTopToBottom ? BarrageFloatDirectionT2B : BarrageFloatDirectionB2T;
            
            descriptor = [self senderFloatBarrage:deriction text:self.senderView.textField.text];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.renderer receive:descriptor];
            self.senderView.textField.text = @"";
        });
    }
}

- (BarrageDescriptor *)senderFloatBarrage:(NSInteger)deriction text:(NSString *)text{
    
    UIColor *color = deriction == BarrageFloatDirectionT2B ? [UIColor redColor] : [UIColor purpleColor];
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([MySenderFloatTextSprite class]);
    descriptor.params[@"text"] = text;
    descriptor.params[@"textColor"] = color;
    descriptor.params[@"duration"] = @(3);
    descriptor.params[@"fadeInTime"] = @(1);
    descriptor.params[@"fadeOutTime"] = @(1);
    descriptor.params[@"direction"] = @(deriction);
    descriptor.params[@"side"] = @(0);
    return descriptor;
}

#pragma mark -
#pragma mark - < Lazy Loading >
- (BarrageSenderView *)senderView {
    
    if(!_senderView) {
        
        CGFloat height = 70;
        
        self.senderView = [[BarrageSenderView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), height)];
        
        _senderView.textField.delegate = self;
        
        [self.view addSubview:_senderView];
        
        _senderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _senderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

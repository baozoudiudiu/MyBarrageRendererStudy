//
//  MySenderFloatTextSprite.m
//  DanmuTest
//
//  Created by chenwang on 2017/6/19.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import "MySenderFloatTextSprite.h"

@implementation MySenderFloatTextSprite

- (instancetype)init {
    
    if(self = [super init]) {
        self.cornerRadius = 2.5;
        self.borderColor = [UIColor blueColor];
        self.borderWidth = 1.0;
        self.fontSize = 17;
    }
    return self;
}

@end

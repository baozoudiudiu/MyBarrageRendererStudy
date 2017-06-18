//
//  MySenderWalkTextSprite.m
//  DanmuTest
//
//  Created by WangChen on 17/6/18.
//  Copyright © 2017年 ChenWang. All rights reserved.
//

#import "MySenderWalkTextSprite.h"

@implementation MySenderWalkTextSprite

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

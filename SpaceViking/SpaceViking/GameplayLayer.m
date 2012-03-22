//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by default on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer
-(id)init{
    self = [super init];
    if(self != nil){
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        self.isTouchEnabled = YES;  //Enable Touches
        vikingSprite = [CCSprite spriteWithFile:@"sv_anim_1.png"];
        [vikingSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
        [self addChild:vikingSprite];
        
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){   //Not iPad, so scale vikingSprite down
            [vikingSprite setScaleX:screenSize.width/1024.0f];
            [vikingSprite setScaleY:screenSize.height/768.0f];
        }
    }
    return self;         
}
@end

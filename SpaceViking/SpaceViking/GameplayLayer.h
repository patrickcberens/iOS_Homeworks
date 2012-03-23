//
//  GameplayLayer.h
//  SpaceViking
//
//  Created by default on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyButton.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyButtonSkinnedBase.h"

@interface GameplayLayer : CCLayer{
    CCSprite *vikingSprite;
    SneakyJoystick *leftJoystick;
    SneakyButton *jumpButton;
    SneakyButton *attackButton;
}

@end

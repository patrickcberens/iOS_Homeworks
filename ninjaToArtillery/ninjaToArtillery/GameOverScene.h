//
//  GameOverScene.h
//  NinjaGame
//
//  Created by default on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuScene.h"
//#import "GameplayLayer.h"

@interface GameOverLayer : CCLayerColor{
    CCLabelTTF *_label;
}
@property (nonatomic, retain) CCLabelTTF *label;
@end


@interface GameOverScene : CCScene {
    GameOverLayer *_layer;
}
@property (nonatomic, retain) GameOverLayer *layer;
@end

//
//  GameScene.m
//  ninjaToArtillery
//
//  Created by default on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

-(id)init{
    if((self = [super init]) != nil){
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:0];
    }
    return self;
}
@end

//
//  GameScene.m
//  ninjaToArtillery
//
//  Created by default on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

/*
 * Scene for gameplay. Contains one layer called gameplayLayer.
 */

@implementation GameScene

-(id)init{
    if((self = [super init]) != nil){
        gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:0];
    }
    return self;
}
-(id)initWithGameType:(GameType)gameType{
    if((self = [super init]) != nil){
        gameplayLayer = [GameplayLayer node];
        [gameplayLayer setGameType:gameType];
        [self addChild:gameplayLayer z:0];
    }
    return self;    
}
-(void)setOpponentType:(GameType)gameType{
    [gameplayLayer setGameType:gameType];
}
@end

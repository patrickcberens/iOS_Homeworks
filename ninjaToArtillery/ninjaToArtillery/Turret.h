//
//  Character.h
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayerDelegate.h"
#import "Character.h"

#define WIN_SCORE (5) //5 kills to win
#define TOP_TURRET_OFFSET (19)

typedef enum {
    leftSide,
    rightSide
} PlayerPosition;

@interface Turret : Character {
    PlayerPosition position;
    
    CCSprite *_baseTurret;
    CCSprite *_topTurret;
    
    CCSprite *_nextProjectile;
    NSMutableArray *_projectiles;
    
    
    CCLabelTTF *_scoreLabel;
    NSInteger _score;
    
    id <GameLayerDelegate> gameLayerDelegate;
}
@property (retain) id gameLayerDelegate;

-(BOOL)updateScore;
-(void)detectProjectileCollisions:(NSMutableArray*)enemies;

-(id)initPlayerWithPosition:(PlayerPosition) pos;   //custom init method

@end

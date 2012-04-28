//
//  Character.h
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameLayerDelegate.h"

#define WIN_SCORE (10)          //kills to win
#define TOP_TURRET_OFFSET (19)  //top turret sprite slightly off-center of base

typedef enum {
    leftSide,
    rightSide
} PlayerPosition;

@interface Turret : CCNode
{
    PlayerPosition position;        
    
    //Sprites
    CCSprite *_baseTurret;
    CCSprite *_topTurret;
    
    //Projectiles associated with this turret
    CCSprite *_nextProjectile;
    NSMutableArray *_projectiles;
    
    //Score and label
    CCLabelTTF *_scoreLabel;
    NSInteger _score;
    
    //Delegate used to communicate with GameplayLayer
    id <GameLayerDelegate> gameLayerDelegate;
}
@property (retain) id gameLayerDelegate;

-(BOOL)updateScore;
-(void)detectProjectileCollisions:(NSMutableArray*)enemies;

-(id)initPlayerWithPosition:(PlayerPosition) pos;   //custom init method

@end

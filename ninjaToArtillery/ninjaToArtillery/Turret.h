//
//  Character.h
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayerDelegate.h"
#import "Character.h"

typedef enum {
    leftSide,
    rightSide
} PlayerPosition;

@interface Turret : Character {
    PlayerPosition position;
    
    CCSprite *_baseTurret;
    CCSprite *_topTurret;
    NSInteger _topTurretOffset;
    
    CCSprite *_nextProjectile;
    NSMutableArray *_projectiles;
    
    
    CCLabelTTF *_scoreLabel;
    NSInteger _score;
    
    id <GameLayerDelegate> gameLayerDelegate;
}
@property (retain) id gameLayerDelegate;
-(void)rotationFinished;
-(void)updateScore:(NSInteger)increment;

-(id)initPlayerWithPosition:(PlayerPosition) pos;   //custom init method

@end

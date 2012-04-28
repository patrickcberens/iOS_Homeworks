//
//  FighterJet.m
//  ninjaToArtillery
//
//  Created by default on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FighterJet.h"

@implementation FighterJet

//Calcualtes enemy offscreen point, moves enemy to that point across screen.
//--Top to bottom
-(void)spawnEnemy
{
    // Determine speed of the _enemy
    int rangeDuration = maxMoveDuration - minMoveDuration;
    int actualDuration = (arc4random() % rangeDuration) + minMoveDuration;
 
    CGPoint offscreenPoint = ccp(_enemy.position.x, -_enemy.contentSize.height);
    
    //Move enemy offscreen, top to bottom
    [_enemy runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:actualDuration position:offscreenPoint],
                                [CCCallFuncN actionWithTarget:self selector:@selector(enemyMoveFinished:)],
                            nil]];
}

@end

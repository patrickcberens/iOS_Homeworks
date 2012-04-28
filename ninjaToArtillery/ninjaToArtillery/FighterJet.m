//
//  FighterJet.m
//  ninjaToArtillery
//
//  Created by default on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FighterJet.h"

@implementation FighterJet

-(void)spawnEnemy
{
    // Determine speed of the _enemy
    int rangeDuration = maxMoveDuration - minMoveDuration;
    int actualDuration = (arc4random() % rangeDuration) + minMoveDuration;
    //int actualDuration = 2;
    // Create the actions
    //Create the actions(go until off the screen)
    //id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(_enemy.position.x,_enemy.position.y  -_enemy.contentSize.height/2)];
    //id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(enemyMoveFinished:)];
    //[_enemy runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    

    CGPoint offscreenPoint = ccp(_enemy.position.x, -_enemy.contentSize.height);
    
    [_enemy runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:actualDuration position:offscreenPoint],
                                [CCCallFuncN actionWithTarget:self selector:@selector(enemyMoveFinished:)],
                            nil]];
}

@end

//
//  Enemy.m
//  ninjaToArtillery
//
//  Created by default on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

/*
 * Main method for enemies whether FighterPlane or something else
 *  -Acts as a sort of controller for all Enemy classes
 *   -Information being passed to gameplay layer must pass through here(protocol)
 *  -All player/computer similarities abstracted to here
 *
 */

@implementation Enemy

@synthesize gameLayerDelegate;

//Called when enemy off screen
//-Removes enemy from scene and array.
-(void)enemyMoveFinished:(id)sender{
    CCSprite *sprite = (CCSprite *)sender;
    [[self gameLayerDelegate]removeEnemy:sprite];
    
    [[self gameLayerDelegate] removeChild:sprite cleanup:YES];
}


-(id)initEnemyWithFilename:(NSString*)filename
{
    if((self = [super init]) != nil){
        minMoveDuration = 2;    //2
        maxMoveDuration = 4;
        
        _enemy = [[CCSprite spriteWithFile:filename] retain];
        // Add to _enemys array
        [[self gameLayerDelegate] addEnemy:_enemy];
        
        //Determine where to spawn the target along top X-axis
        //  Will only spawn between the left turret and the right turret(won't fly through either one).
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        //int minX = target.contentSize.width/2 + _leftTopTurret.contentSize.width;
        int minX = _enemy.contentSize.width/2;
        int maxX = winSize.width - _enemy.contentSize.width/2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        // Create the _enemy slightly off-screen along the right edge,
        // and along a random position along the X axis as calculated above
        _enemy.position = ccp(actualX, winSize.height + (_enemy.contentSize.height/2));
        [[self gameLayerDelegate] addChild:_enemy z:1];
        
        
        
    }
    return self;
}
- (void) dealloc
{
    [super dealloc];
    
    [_enemy release];
    _enemy = nil;
}
@end

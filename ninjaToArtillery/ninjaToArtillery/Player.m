//
//  Player.m
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

/*
 * Human Player
 *   -Responsible for firing projectile, called by Gameplay Layer
 */

@implementation Player

//Calculates offscreen location
//-Then rotates and fires.
-(void)fireProjectile:(CGPoint)touchLocation{
    if(_nextProjectile != nil) return;
    
    //_nextProjectile = [[CCSprite spriteWithFile:@"Projectile2.jpeg"] retain];
    _nextProjectile = [[CCSprite spriteWithFile:@"ProjectilesRound.png"] retain];
    [_nextProjectile setScale:0.5];
    _nextProjectile.position = _topTurret.position;

    //Rotate turret
    CGPoint shootVector = ccpSub(touchLocation, _nextProjectile.position);
    CGFloat shootAngle = ccpToAngle(shootVector);
    CGFloat cocosAngle;
    if(position == leftSide)
        cocosAngle = CC_RADIANS_TO_DEGREES(-1* shootAngle);
    else
        cocosAngle = CC_RADIANS_TO_DEGREES(-1* shootAngle)+180;
    
    CGFloat currentAngle = _topTurret.rotation;
    CGFloat rotateDifference = cocosAngle - currentAngle;
    
    //Speeds up rotatation
    if(rotateDifference > 180)
        rotateDifference -= 360;
    else if(rotateDifference < -180)
        rotateDifference += 360;
    
    CGFloat rotationSpeed = 0.5/180;   //0.5 seconds to rotate 180 degrees
    CGFloat rotationDuration = fabs(rotateDifference * rotationSpeed);
    
    //Rotate to proper position
    [_topTurret runAction:[CCSequence actions:
                           [CCRotateTo actionWithDuration:rotationDuration angle:cocosAngle],
                           [CCCallFunc actionWithTarget:self selector:@selector(rotationFinished)],
                           nil]];

    //Move projectile until offscreen
    ccTime delta = 1.0;
    CGPoint normalizedShootVector = ccpNormalize(shootVector);
    CGPoint overshotVector = ccpMult(normalizedShootVector, 420+10);    //+10 makes sure goes off screen(wasn't quite making it to the corners).
    CGPoint offscreenPoint = ccpAdd(_nextProjectile.position, overshotVector);
    
    [_nextProjectile runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:delta position:offscreenPoint],
                                [CCCallFuncN actionWithTarget:self selector:@selector(projectileMoveFinished:)],
                                nil]];
        
}

@end

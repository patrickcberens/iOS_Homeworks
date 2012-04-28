//
//  Computer.m
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Computer.h"

@implementation Computer

-(void)fireProjectile:(CGPoint)enemyLocation{
    if(_nextProjectile != nil) return;
    
    _nextProjectile = [[CCSprite spriteWithFile:@"Projectile2.jpeg"] retain];
    _nextProjectile.position = _topTurret.position;
    
    CGPoint fireToPosition = enemyLocation;
    
    CGFloat xDistance = abs(_nextProjectile.position.x - fireToPosition.x);
    fireToPosition.y -= xDistance/2;    //x=100

    
    //Rotate turret
    CGPoint shootVector = ccpSub(fireToPosition, _nextProjectile.position);
    CGFloat shootAngle = ccpToAngle(shootVector);
    CGFloat cocosAngle;
    if(position == leftSide)
        cocosAngle = CC_RADIANS_TO_DEGREES(-1* shootAngle);
    else
        cocosAngle = CC_RADIANS_TO_DEGREES(-1* shootAngle)+180;
    
    CGFloat currentAngle = _topTurret.rotation;
    CGFloat rotateDifference = cocosAngle - currentAngle;
    
    //This code speeds up rotation logic(otherwise slowwwww)
    if(rotateDifference > 180)
        rotateDifference -= 360;
    else if(rotateDifference < -180)
        rotateDifference += 360;
    
    CGFloat rotationSpeed = 0.5/180;   //0.5 seconds to rotate 180 degrees
    CGFloat rotationDuration = fabs(rotateDifference * rotationSpeed);
    
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

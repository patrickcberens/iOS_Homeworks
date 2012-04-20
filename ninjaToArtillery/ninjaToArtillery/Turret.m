//
//  Character.m
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Turret.h"


@implementation Turret

@synthesize gameLayerDelegate;

-(void)rotationFinished{
    NSLog(@"Player: rotationFinished");
    //[[self fireDelegate] finishShoot:_nextProjectile];
    [[self gameLayerDelegate] addChild:_nextProjectile z:1];
    [_projectiles addObject:_nextProjectile];
    
    [_nextProjectile release];
    _nextProjectile = nil;
}
-(void)projectileMoveFinished:(id)sender{
    NSLog(@"Player: spriteMoveFinished");
    CCSprite *sprite = (CCSprite *)sender;
    [_projectiles removeObject:sprite];
    
    [[self gameLayerDelegate] removeChild:sprite cleanup:YES];
    
}
-(void)updateScore:(NSInteger)increment{
    _score += increment;
    NSString *scoreText = [NSString stringWithFormat:@"Score: %d", _score];
    [_scoreLabel setString:scoreText];
}

-(id)init{
    [super init];
    
    return self;
}
-(id)initPlayerWithPosition:(PlayerPosition) pos
{
    if((self = [super init]) != nil){
        _score = 0;
        position = pos;
        _topTurretOffset = 19; 
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        _baseTurret = [[CCSprite spriteWithFile:@"Turret_Bottom.png"] retain];
        _topTurret = [[CCSprite spriteWithFile:@"Turret_Top.png"] retain];
        
        _scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:20];
        [_scoreLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        
        //Set positions based on if on left or right side of screen
        if(position == leftSide){
            _baseTurret.position = ccp(_baseTurret.contentSize.width/2+50, winSize.height/2);
            _topTurret.position = ccp(_topTurret.contentSize.width/2+50-_topTurretOffset, winSize.height/2);
            [_scoreLabel setPosition:ccp(150, winSize.height-10)];
        }
        else{
            _baseTurret.position = ccp(winSize.width - _baseTurret.contentSize.width/2-50, winSize.height/2);
            _topTurret.position = ccp(winSize.width - _topTurret.contentSize.width/2-50+_topTurretOffset, winSize.height/2);     
            [_topTurret setFlipX:YES];
            
            [_scoreLabel setPosition:ccp(winSize.width-150, winSize.height-10)];
        }
        [[self gameLayerDelegate] addChild:_baseTurret z:5];
        [[self gameLayerDelegate] addChild:_topTurret z:10];
        [[self gameLayerDelegate] addChild:_scoreLabel z:20];
        
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    
    [_baseTurret release];
    _baseTurret = nil;
    [_topTurret release];
    _topTurret = nil;
    [_scoreLabel release];
    _scoreLabel = nil;
    [_nextProjectile release];
    _nextProjectile = nil;
    [_projectiles release];
    _projectiles = nil;
}
@end

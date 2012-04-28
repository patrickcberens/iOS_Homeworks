//
//  Character.m
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Turret.h"

/*
 * Main method for turrets whether Player or Computer
 *  -Acts as a sort of controller for Players and Computers
 *   -Information being passed to gameplay layer must pass through here(protocol)
 *  -All player/computer similarities abstracted to here
 *
 */
@implementation Turret

@synthesize gameLayerDelegate;

//Called when rotation is finished.
//--Creates projectile.
-(void)rotationFinished{
    [[self gameLayerDelegate] addChild:_nextProjectile z:1];
    [_projectiles addObject:_nextProjectile];
    
    [_nextProjectile release];
    _nextProjectile = nil;
}
//Called when projectile is off screen.
//--Removes projectile from scene and array.
-(void)projectileMoveFinished:(id)sender{
    CCSprite *sprite = (CCSprite *)sender;
    [_projectiles removeObject:sprite];
    
    [[self gameLayerDelegate] removeChild:sprite cleanup:YES];
    
}

//Detects if a projectile for this turrent has collided with an enemy
//--Draws box around all, then detects of collide(AABB)
//---Inefficient and not that accurate, but sufficient for our purposes.
-(void)detectProjectileCollisions:(NSMutableArray*)enemies{
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];

    //Create rectangles around projectiles and enemies.
    //Iterate through each projectile, check if intersects rectangle of enemy.
    //-If intersects, delete enemy
    for (CCSprite *projectile in _projectiles) {
        CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
                                           projectile.position.y - (projectile.contentSize.height/2), 
                                           projectile.contentSize.width, 
                                           projectile.contentSize.height);
        
        NSMutableArray *enemiesToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *enemy in enemies) {
            CGRect enemyRect = CGRectMake(enemy.position.x - (enemy.contentSize.width/2), 
                                           enemy.position.y - (enemy.contentSize.height/2), 
                                           enemy.contentSize.width, 
                                           enemy.contentSize.height);
            
            if (CGRectIntersectsRect(projectileRect, enemyRect)) {
                [enemiesToDelete addObject:enemy];
				NSLog(@"DELETE");
            }						
        }
        
        for (CCSprite *enemy in enemiesToDelete) {
            [enemies removeObject:enemy];
            [[self gameLayerDelegate] removeChild:enemy cleanup:YES];

            _score++;
        }
        
        if (enemiesToDelete.count > 0) {    //Hit a target so delete projectile
            [projectilesToDelete addObject:projectile];
        }
        [enemiesToDelete release];
    }
    //Remove projectiles that collided with enemies
    for (CCSprite *projectile in projectilesToDelete) {
        [self projectileMoveFinished:projectile];
    }
    [projectilesToDelete release];

}

//Updates the score after collisions detected
//--Tells whether turret has won.
-(BOOL)updateScore{
    NSString *scoreText = [NSString stringWithFormat:@"Score: %d/%d", _score, WIN_SCORE];
    [_scoreLabel setString:scoreText];
    if(_score >= WIN_SCORE)
        return YES;
    return NO;
}

//Initializes a turret
-(id)initPlayerWithPosition:(PlayerPosition) pos
{
    if((self = [super init]) != nil){
        _score = 0;
        position = pos; 
        _projectiles = [[NSMutableArray alloc] init];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        _baseTurret = [[CCSprite spriteWithFile:@"Turret_Bottom.png"] retain];
        _topTurret = [[CCSprite spriteWithFile:@"Turret_Top.png"] retain];
        
        NSString *scoreText = [NSString stringWithFormat:@"Score: %d/%d", _score, WIN_SCORE];
        _scoreLabel = [CCLabelTTF labelWithString:scoreText fontName:@"Helvetica" fontSize:20];
        [_scoreLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        
        //Set positions based on if on left or right side of screen
        if(position == leftSide){
            _baseTurret.position = ccp(_baseTurret.contentSize.width/2+50, winSize.height/2);
            _topTurret.position = ccp(_topTurret.contentSize.width/2+50-TOP_TURRET_OFFSET, winSize.height/2);
            [_scoreLabel setPosition:ccp(150, winSize.height-10)];
        }
        else{
            _baseTurret.position = ccp(winSize.width - _baseTurret.contentSize.width/2-50, winSize.height/2);
            _topTurret.position = ccp(winSize.width - _topTurret.contentSize.width/2-50+TOP_TURRET_OFFSET, winSize.height/2);     
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

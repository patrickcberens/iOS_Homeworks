//
//  HelloWorldLayer.m
//  NinjaGame
//
//  Created by default on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

//http://www.raywenderlich.com/352/how-to-make-a-simple-iphone-game-with-cocos2d-tutorial

// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(int)projectilesUpdate:(NSMutableArray *)projectiles score:(int)destroyedCount{
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    //Create rectangles around projectiles and targets.
    //Iterate through each projectile, check if intersects rectangle of target.
    //-If intersects, delete target
    for (CCSprite *projectile in projectiles) {
        CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
                                           projectile.position.y - (projectile.contentSize.height/2), 
                                           projectile.contentSize.width, 
                                           projectile.contentSize.height);
        
        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *target in _targets) {
            CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2), 
                                           target.position.y - (target.contentSize.height/2), 
                                           target.contentSize.width, 
                                           target.contentSize.height);
            
            if (CGRectIntersectsRect(projectileRect, targetRect)) {
                [targetsToDelete addObject:target];				
            }						
        }
        
        for (CCSprite *target in targetsToDelete) {
            [_targets removeObject:target];
            [self removeChild:target cleanup:YES];
            
            destroyedCount++;
        }
        
        if (targetsToDelete.count > 0) {    //Hit a target so delete projectile
            [projectilesToDelete addObject:projectile];
        }
        [targetsToDelete release];
    }
    //Remove projectiles that collided with targets
    for (CCSprite *projectile in projectilesToDelete) {
        [projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
    return destroyedCount;
}
-(void)update:(ccTime)dt{
    //Left Update
    _leftProjectilesDestroyed = [self projectilesUpdate:_leftProjectiles score:_leftProjectilesDestroyed];
    NSString *left = [NSString stringWithFormat:@"Score: %d", _leftProjectilesDestroyed];
    [leftScoreLabel setString:left];
    //Check for game over
    if(_leftProjectilesDestroyed > WIN_SCORE){ //Win
        GameOverScene *gameOverScene = [GameOverScene node];
        _leftProjectilesDestroyed = 0;
        _rightProjectilesDestroyed = 0;
        [gameOverScene.layer.label setString:@"Left wins!"];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
    
    //Right Update
    _rightProjectilesDestroyed = [self projectilesUpdate:_rightProjectiles score:_rightProjectilesDestroyed];
    NSString *right = [NSString stringWithFormat:@"Score: %d", _rightProjectilesDestroyed];
    [rightScoreLabel setString:right];
    //Check for game over
    if(_rightProjectilesDestroyed > WIN_SCORE){ //Win
        GameOverScene *gameOverScene = [GameOverScene node];
        _leftProjectilesDestroyed = 0;
        _rightProjectilesDestroyed = 0;
        [gameOverScene.layer.label setString:@"Right wins!"];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
}


-(void)spriteMoveFinished:(id)sender{
    CCSprite *sprite = (CCSprite *)sender;
    if(sprite.tag == 1){
        [_targets removeObject:sprite];
        
        //GameOverScene *gameOverScene = [GameOverScene node];
        //[gameOverScene.layer.label setString:@"You lose :["];
        //[[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
    else if(sprite.tag == 2)
        [_leftProjectiles removeObject:sprite];
    else if(sprite.tag == 3)
        [_rightProjectiles removeObject:sprite];
    [self removeChild:sprite cleanup:YES];
    
}
-(void)addTarget{
    CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)];
    target.tag = 1;
    [_targets addObject:target];
    
    //Determine where to spawn the target along Y-axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    //Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];
    
    //Determine the speed of the target;
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    //Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"Detected Touch Ended");
    
    if(_nextProjectile != nil) return;
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _nextProjectile = [[CCSprite spriteWithFile:@"Projectile2.jpeg"] retain];
    

    float realMoveDuration;
    CGPoint realDest;
    if(location.x < winSize.width/2){
        _nextProjectile.position = ccp(20, winSize.height/2);
        _nextProjectile.tag = 2;
        //Determine offset of location to projectile
        int offX = location.x - _nextProjectile.position.x;
        int offY = location.y - _nextProjectile.position.y;
        //Bail out if we are shooting down or backwards(to left)
        if(offX <= 0) return;
        
        //Determine where we wish to shoot the projectile to
        int realX = winSize.width + (_nextProjectile.contentSize.width/2);
        float ratio = (float) offY / (float) offX;
        int realY = (realX * ratio) + _nextProjectile.position.y;
        realDest = ccp(realX, realY);
        
        //Determine the length of how far we're shooting
        int offRealX = realX - _nextProjectile.position.x;
        int offRealY = realY - _nextProjectile.position.y;
        float length = sqrtf((offRealX * offRealX) + (offRealY * offRealY));
        float velocity = 480/1; //480 pixels per 1 second
        realMoveDuration = length/velocity;
        
        NSLog(@"Calculations done");
        
        //Rotate turret calculations
        float angleRadians = atanf((float)offRealY / (float)offRealX);
        float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
        float cocosAngle = -1 * angleDegrees;
        float rotateSpeed = 0.5/M_PI; //Would take 0.5 seconds to rotate half a circle
        float rotateDuration = fabs(angleRadians * rotateSpeed);
        
        [_leftPlayer runAction:[CCSequence actions:
                                [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                                [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
                                nil]];
    }
    else{
        _nextProjectile.position = ccp(winSize.width - 20, winSize.height/2);
        _nextProjectile.tag = 3;
        //Determine offset of location to projectile
        int offX = _nextProjectile.position.x - location.x;
        int offY = _nextProjectile.position.y - location.y;
        //Bail out if we are shooting down or backwards(to right)
        if(offX <= 0) return;
        
        //Determine where we wish to shoot the projectile to
        int realX = -(_nextProjectile.contentSize.width/2);
        float ratio = (float) offY / (float) offX;
        int realY = -((realX+_nextProjectile.position.x) * ratio) + _nextProjectile.position.y;
        realDest = ccp(realX, realY);
        
        //Determine the length of how far we're shooting
        int offRealX = realX - _nextProjectile.position.x;
        int offRealY = realY - _nextProjectile.position.y;
        float length = sqrtf((offRealX * offRealX) + (offRealY * offRealY));
        float velocity = 480/1; //480 pixels per 1 second
        realMoveDuration = length/velocity;
        
        //NSLog(@"Calculations done");
        
        //Rotate turret calculations
        float angleRadians = atanf((float)offRealY / (float)offRealX);
        float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
        float cocosAngle = -1 * angleDegrees;
        float rotateSpeed = 0.5/M_PI; //Would take 0.5 seconds to rotate half a circle
        float rotateDuration = fabs(angleRadians * rotateSpeed);
        
        [_rightPlayer runAction:[CCSequence actions:
                                [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                                [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
                                nil]];
    }
    //NSLog(@"Added projectile");
    
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    //NSLog(@"Audio done");
    
    //Move projectile to actual endpoint
    [_nextProjectile runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                                [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], nil]];
    //NSLog(@"runAction done");
}
-(void)finishShoot{
    //Finished rotating so add/shoot projectile.
    [self addChild:_nextProjectile];
    if(_nextProjectile.tag == 2)
        [_leftProjectiles addObject:_nextProjectile];
    else if(_nextProjectile.tag == 3)
        [_rightProjectiles addObject:_nextProjectile];
    
    [_nextProjectile release];
    _nextProjectile = nil;
}
-(void)gameLogic:(ccTime)dt{
    [self addTarget];
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)])) {
        self.isTouchEnabled = YES;
        NSLog(@"Entered init");
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        //CCSprite *player = [CCSprite spriteWithFile:@"Player2.jpeg"];
        //player.position = ccp(player.contentSize.width/2, winSize.height/2);
        //[self addChild:player];
        _leftPlayer = [[CCSprite spriteWithFile:@"Player2.jpeg"] retain];
        _leftPlayer.position = ccp(_leftPlayer.contentSize.width/2, winSize.height/2);
        [self addChild:_leftPlayer];
        _rightPlayer = [[CCSprite spriteWithFile:@"Player2.jpeg"] retain];
        _rightPlayer.position = ccp(winSize.width - _rightPlayer.contentSize.width/2, winSize.height/2);
        [_rightPlayer setFlipX:YES];
        [self addChild:_rightPlayer];
        
        leftScoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:20];
        [leftScoreLabel setPosition:ccp(45, winSize.height-10)];
        [leftScoreLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        [self addChild:leftScoreLabel];
        rightScoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:20];   
        [rightScoreLabel setPosition:ccp(winSize.width-45, winSize.height-10)];
        [rightScoreLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        [self addChild:rightScoreLabel];
        
        _targets = [[NSMutableArray alloc] init];
        _leftProjectiles = [[NSMutableArray alloc] init];
        _rightProjectiles = [[NSMutableArray alloc] init];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pew-pew-lei.caf"];
        
        [self schedule:@selector(gameLogic:) interval:1.0];
        [self schedule:@selector(update:)];
	}
	return self;
}
-(void)draw{
    [super draw];
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    glLineWidth(2.0f);
    ccDrawLine(ccp(winSize.width/2.0, winSize.height), ccp(winSize.width/2.0, 0));
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
    [_targets release];
    _targets = nil;
    [_leftProjectiles release];
    _leftProjectiles = nil;
    [_rightProjectiles release];
    _rightProjectiles = nil;
    [_leftPlayer release];
    _leftPlayer = nil;
    [_rightPlayer release];
    _rightPlayer = nil;
}
@end

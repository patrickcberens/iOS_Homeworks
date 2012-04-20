//
//  HelloWorldLayer.m
//  NinjaGame
//
//  Created by default on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

//http://www.raywenderlich.com/352/how-to-make-a-simple-iphone-game-with-cocos2d-tutorial

// Import the interfaces
#import "GameplayLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"

// HelloWorldLayer implementation
@implementation GameplayLayer

/*+(CCScene *) scene
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
*/
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
    [_leftPlayer updateScore:_leftProjectilesDestroyed];
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
    [_rightPlayer updateScore:_rightProjectilesDestroyed];
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
    if(sprite.tag == 1)
        [_targets removeObject:sprite];
/*    else if(sprite.tag == 2)
        [_leftProjectiles removeObject:sprite];
    else if(sprite.tag == 3)
        [_rightProjectiles removeObject:sprite];*/
    [self removeChild:sprite cleanup:YES];
    
}
-(void)addTarget{
    //CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)];
    CCSprite *target = [CCSprite spriteWithFile:@"Target_Jet_Blue_mod.png"];
    target.tag = 1;
    [_targets addObject:target];
    
    //Determine where to spawn the target along top X-axis
    //  Will only spawn between the left turret and the right turret(won't fly through either one).
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //int minX = target.contentSize.width/2 + _leftTopTurret.contentSize.width;
    int minX = target.contentSize.width/2;
    //int maxX = winSize.width - target.contentSize.width/2 - _rightTopTurret.contentSize.width;
    int maxX = winSize.width - target.contentSize.width/2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    //Create the target slightly off-screen along the top edge,
    // and along a random position along the X axis as calculated above
    target.position = ccp(actualX, winSize.height + (target.contentSize.height/2));
    [self addChild:target];
    
    //Determine the speed of the target;
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    //Create the actions(go until off the screen)
    id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(actualX, -target.contentSize.height/2)];
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
    
    //if(_nextProjectile != nil) return;
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //_nextProjectile = [[CCSprite spriteWithFile:@"Projectile2.jpeg"] retain];
    
    

    //float realMoveDuration;
    //CGPoint realDest;
    if(location.x < winSize.width/2){   //left players side
//        printf("Location  x: %f,  y: %f\n", location.x, location.y);
        [_leftPlayer fireProjectile:location];
/*        _nextProjectile.position = _leftTopTurret.position;
        printf("_nextProjectile.position: x: %f, y: %f\n", _nextProjectile.position.x, _nextProjectile.position.y);       
        // Rotate player to face shooting direction
        CGPoint shootVector = ccpSub(location, _nextProjectile.position);
        CGFloat shootAngle = ccpToAngle(shootVector);
        CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
        
        CGFloat curAngle = _leftTopTurret.rotation;
        CGFloat rotateDiff = cocosAngle - curAngle;
        printf("rotateDiff: %f\n", rotateDiff);
        if (rotateDiff > 180)
            rotateDiff -= 360;
        if (rotateDiff < -180)
            rotateDiff += 360;
            printf("rotateDiff: %f\n", rotateDiff);
        CGFloat rotateSpeed = 0.5 / 180; // Would take 0.5 seconds to rotate half a circle
        CGFloat rotateDuration = fabs(rotateDiff * rotateSpeed);
        
        // Move player slightly backwards
        //CGPoint position = ccpAdd(_player.position, ccp(-10, 0));
        printf("rotateSpeed: %f, rotatenDuration: %f\n", rotateSpeed, rotateDuration);
        [_leftTopTurret runAction:[CCSequence actions:
                            //[CCMoveBy actionWithDuration:0.1 position:ccp(-10, 0)],
                            [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                            [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
                            nil]];
        
        // Move projectile offscreen
        ccTime delta = 1.0;
        CGPoint normalizedShootVector = ccpNormalize(shootVector);
        CGPoint overshotVector = ccpMult(normalizedShootVector, 420);
        CGPoint offscreenPoint = ccpAdd(_nextProjectile.position, overshotVector);
        
        [_nextProjectile runAction:[CCSequence actions:
                                    [CCMoveTo actionWithDuration:delta position:offscreenPoint],
                                    [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                                    nil]];
        
        // Add to projectiles array
        _nextProjectile.tag = 2;
        _nextProjectile.position = ccp(20, winSize.height/2);
        _nextProjectile.tag = 2;
        //Determine offset of location to projectile
        int offX = location.x - _nextProjectile.position.x;
        int offY = location.y - _nextProjectile.position.y;
        
        //Bail out if we are shooting down or backwards(to left)
        //if(offX <= 0) return;
        
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
        
        [_leftTopTurret runAction:[CCSequence actions:
         [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
         [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
         nil]];
        
        [_leftPlayer runAction:[CCSequence actions:
                                [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                                [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
                                nil]];*/
        
    }
    else{
        [_rightPlayer fireProjectile:location];
/*        _nextProjectile.position = ccp(winSize.width - 20, winSize.height/2);
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
        
        [_rightTopTurret runAction:[CCSequence actions:
         [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
         [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
         nil]];
        
        [_rightPlayer runAction:[CCSequence actions:
                                [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                                [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
                                nil]];*/
        
    }
    
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
    //Move projectile to actual endpoint
    /*[_nextProjectile runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                                [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], nil]];*/
}
/*-(void)finishShoot:(id)sender data:(CCSprite*)nextProjectile
-(void)finishShoot:(CCSprite*)nextProjectile
{
    NSLog(@"HelloWorldLayer: finishShoot:nextProjectile");
    
}*/
/*-(void)finishShoot{
    //Finished rotating so add/shoot projectile.
    NSLog(@"HelloWorldLayer: finishShoot");
    [self addChild:_nextProjectile];
    if(_nextProjectile.tag == 2)
        [_leftProjectiles addObject:_nextProjectile];
    else if(_nextProjectile.tag == 3)
        [_rightProjectiles addObject:_nextProjectile];
    
    [_nextProjectile release];
    _nextProjectile = nil;
}*/
-(void)gameLogic:(ccTime)dt{
    [self addTarget];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(135,206,250,255)])) {
        self.isTouchEnabled = YES;
        //NSLog(@"Entered init");
		//CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        _leftPlayer = [Player alloc];
        [_leftPlayer setGameLayerDelegate:self];
        [_leftPlayer initPlayerWithPosition:leftSide];
        
        _rightPlayer = [Player alloc];
        [_rightPlayer setGameLayerDelegate:self];
        [_rightPlayer initPlayerWithPosition:rightSide];
        
/*        _leftBottomTurret = [[CCSprite spriteWithFile:@"Turret_Bottom.png"] retain];
        _leftBottomTurret.position = ccp(_leftBottomTurret.contentSize.width/2, winSize.height/2);
        [self addChild: _leftBottomTurret z:5];

        _leftTopTurret = [[CCSprite spriteWithFile:@"Turret_Top.png"] retain];
        _leftTopTurret.position = ccp(_leftTopTurret.contentSize.width/2-19, winSize.height/2);
        [self addChild: _leftTopTurret z:10];
        
        _rightBottomTurret = [[CCSprite spriteWithFile:@"Turret_Bottom.png"] retain];
        _rightBottomTurret.position = ccp(winSize.width - _rightBottomTurret.contentSize.width/2, winSize.height/2);
        [self addChild: _rightBottomTurret z:5];
        
        _rightTopTurret = [[CCSprite spriteWithFile:@"Turret_Top.png"] retain];
        _rightTopTurret.position = ccp(winSize.width - _rightTopTurret.contentSize.width/2+19, winSize.height/2);
        [_rightTopTurret setFlipX:YES];
        [self addChild: _rightTopTurret z:10];

        
        leftScoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:20];
        [leftScoreLabel setPosition:ccp(45, winSize.height-10)];
        [leftScoreLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        [self addChild:leftScoreLabel];
        rightScoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:20];   
        [rightScoreLabel setPosition:ccp(winSize.width-45, winSize.height-10)];
        [rightScoreLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        [self addChild:rightScoreLabel];
 */
        
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
    
    //[_leftBottomTurret release];
    //_leftBottomTurret = nil;
    //[_rightBottomTurret release];
    //_rightBottomTurret = nil;
    
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
    [_rightComputer release];
    _rightComputer = nil;
    
}
@end

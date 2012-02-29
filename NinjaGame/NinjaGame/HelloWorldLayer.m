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

-(void)update:(ccTime)dt{
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    //Create rectangles around projectiles and targets.
    //Iterate through each projectile, check if intersects rectangle of target.
    //-If intersects, delete target
    for (CCSprite *projectile in _projectiles) {
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
            
            _projectilesDestroyed++;
            if(_projectilesDestroyed > 4){ //Win
                GameOverScene *gameOverScene = [GameOverScene node];
                _projectilesDestroyed = 0;
                [gameOverScene.layer.label setString:@"You win!"];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
        }
        
        if (targetsToDelete.count > 0) {    //Hit a target so delete projectile
            [projectilesToDelete addObject:projectile];
        }
        [targetsToDelete release];
    }
    //Remove projectiles that collided with targets
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}

-(void)spriteMoveFinished:(id)sender{
    CCSprite *sprite = (CCSprite *)sender;
    if(sprite.tag == 1){
        [_targets removeObject:sprite];
        
        GameOverScene *gameOverScene = [GameOverScene node];
        [gameOverScene.layer.label setString:@"You lose :["];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
    else if(sprite.tag == 2)
        [_projectiles removeObject:sprite];
    
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

//-(void)ccTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event{
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"Detected Touch Ended");
    //Choose one of the touches to work with
    //UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"Projectile.png" rect:CGRectMake(0, 0, 20, 20)];
    projectile.position = ccp(20, winSize.height/2);
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    
    //Determine offset of location to projectile
    int offX = location.x - projectile.position.x;
    int offY = location.y - projectile.position.y;
    
    //Bail out if we are shooting down or backwards
    if(offX <= 0) return;
    
    //Ok to add now - we've double checked position
    [self addChild:projectile];
    
    //Determine where we wish to shoot the projectile to
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offY / (float) offX;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    //Determine the length of how far we're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX * offRealX) + (offRealY * offRealY));
    float velocity = 280/1; //480 pixels per 1 second
    float realMoveDuration = length/velocity;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
    //Move projectile to actual endpoint
    [projectile runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)], nil]];
    
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
        CCSprite *player = [CCSprite spriteWithFile:@"Player.png" rect:CGRectMake(0, 0, 27, 40)];
        player.position = ccp(player.contentSize.width/2, winSize.height/2);
        
        _targets = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        
        [self addChild:player];
        [self schedule:@selector(gameLogic:) interval:1.0];
        [self schedule:@selector(update:)];
        
		
	}
	return self;
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
    [_projectiles release];
    _projectiles = nil;
}
@end

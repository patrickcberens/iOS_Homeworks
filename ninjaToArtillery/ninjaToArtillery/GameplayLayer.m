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

@implementation GameplayLayer


//Performs collision detection and checks if anyone has won.
//--Is called whenever it can be(by CCDirector)
-(void)update:(ccTime)dt{
    //Left Update
    [_leftPlayer detectProjectileCollisions:_enemies];
    if([_leftPlayer updateScore]){
        GameOverScene *gameOverScene = [GameOverScene node];
        [gameOverScene.layer.label setString:@"Left wins!"];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
    
    //Right Update
    if(_gameType == human){
        [_rightPlayer detectProjectileCollisions:_enemies];
        if([_rightPlayer updateScore]){
            GameOverScene *gameOverScene = [GameOverScene node];
            [gameOverScene.layer.label setString:@"Right wins!"];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];    
        }
    }
    else if(_gameType == computer){
        [_rightComputer detectProjectileCollisions:_enemies];
        if([_rightComputer updateScore]){
            GameOverScene *gameOverScene = [GameOverScene node];
            [gameOverScene.layer.label setString:@"Right wins!"];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];    
        }
    }
}

//Fire once towards where expect enemy to be(estimation)
//--Fires every 1.5 seconds.
-(void)computerFire:(ccTime)dt{
    if(_enemies.count > 0){
        Enemy *enemy = [_enemies objectAtIndex:_enemies.count-1];
        
        [_rightComputer fireProjectile:enemy.position];
    }
}

//----Enemy Methods--------------------------------
-(void)addEnemy:(CCNode *)node{
    [_enemies addObject:(CCSprite *)node];
    
}
-(void)removeEnemy:(CCNode *)node{
    [_enemies removeObject:(CCSprite*)node];
}
-(void)addTarget{    
    FighterJet *enemy = [FighterJet alloc];
    [enemy setGameLayerDelegate:self];
    [enemy initEnemyWithFilename:@"Target_Jet_Blue_mod.png"];
    [enemy spawnEnemy];
}
-(void)enemySpawn:(ccTime)dt{
    [self addTarget];
}


//----------Touch Methods-----------------------------
//NOTE: Only detects one touch at a time..maybe use Set vs UITouch...
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

//When touch ended, fires projectile towards point
//--If human vs human, fires from turret closest to finger
//--If human vs computer, fires from left turret always
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    //Get touch location
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //Fire projectile towards that location
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    if(_gameType == human){ //human vs human
        if(location.x < winSize.width/2)    //left side of screen
            [_leftPlayer fireProjectile:location];
        else                                //right side of screen
            [_rightPlayer fireProjectile:location];
    }
    else{   //human vs computer...always human fires on click, no matter where
        [_leftPlayer fireProjectile:location];
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
}

//Setup based upon whether the game is human vs human or human vs computer
//-Allocates right turret sprite, if computer schedules an event to fire
//--Called from MenuScene
-(void)setGameType:(GameType)type{
    _gameType = type;
    
    if(_gameType == human){
        _rightPlayer = [Player alloc];
        [_rightPlayer setGameLayerDelegate:self];
        [_rightPlayer initPlayerWithPosition:rightSide];
    }
    else if(_gameType == computer){
        _rightComputer = [Computer alloc];
        [_rightComputer setGameLayerDelegate:self];
        [_rightComputer initPlayerWithPosition:rightSide];
        //Computer will fire every 1.5 seconds
        [self schedule:@selector(computerFire:) interval:1.5];
    }
}

//Initializes layer
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(135,206,250,255)])) {
        self.isTouchEnabled = YES;
        
        //Allocate left player, always human
        _leftPlayer = [Player alloc];
        [_leftPlayer setGameLayerDelegate:self];        //links player with scene
        [_leftPlayer initPlayerWithPosition:leftSide];
        
        //Enemies array initialization
        _enemies = [[NSMutableArray alloc] init];
        
        //Preload audio to save time
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pew-pew-lei.caf"];
        
        //Create enemy at top of screen every second
        [self schedule:@selector(enemySpawn:) interval:1.0];
        //Update as often as possible(collision detection)
        [self schedule:@selector(update:)];
	}
	return self;
}

//Draws blank line down middle of screen, separating each players half
-(void)draw{
    [super draw];
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
    glLineWidth(2.0f);
    ccDrawLine(ccp(winSize.width/2.0, winSize.height), ccp(winSize.width/2.0, 0));
}

//Release memory
- (void) dealloc
{
	[super dealloc];
    
    [_leftPlayer release];
    _leftPlayer = nil;
    [_rightPlayer release];
    _rightPlayer = nil;
    [_rightComputer release];
    _rightComputer = nil;
    
    [_enemies release];
    _enemies = nil;
    
}
@end

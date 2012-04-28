//
//  GameOverScene.m
//  NinjaGame
//
//  Created by default on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"

/*
 * The Game over scene...just says game over and who won. Then after 3 seconds
 *    returns to Main Menu
 *
 */

@implementation GameOverScene
@synthesize layer = _layer;

- (id)init {
  
    if(self = [super init]) {
        self.layer = [GameOverLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}
@end

@implementation GameOverLayer
@synthesize label = _label;

-(id) init{
    
    //Create label with winner, setup action to run in 3 seconds
    if(self=[super initWithColor:ccc4(255,255,255,255)]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.label = [CCLabelTTF labelWithString: @"" fontName:@"Arial" fontSize:32];
        _label.color = ccc3(0,0,0);
        _label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_label];
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3],
                         [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
                         nil]];
    }
    return self;
}

//Replace scene with MenuScene
-(void)gameOverDone{
    [[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}
-(void)dealloc{
    [_label release];
    _label = nil;
    [super dealloc];
}
@end

//
//  MenuScene.m
//  ninjaToArtillery
//
//  Created by default on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"

/*
 * Menu Scene.
 *  Lets user selct whether he wants to play against a computer or another human.
 *   -Then initializes GameScene, sending Game Type to it.
 *
 */
@implementation MenuScene
-(id)init{
    if((self = [super init]) != nil){
        
        //Create menu items and add to scene
        CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Play Against Computer" target:self selector:@selector(onComputer:)];
        CCMenuItemFont *menuItem2 = [CCMenuItemFont itemFromString:@"Play Against Human" target:self selector:@selector(onHuman:)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

//Computer menu item selected
-(void)onComputer:(id)sender
{
    //Initialize next scene, set type to human vs computer, then replace scene
    GameScene *nextScene = [GameScene node];
    [nextScene initWithGameType:computer];
    NSLog(@"on computer");
    [[CCDirector sharedDirector] replaceScene:nextScene];
}

//Human menu item selected
-(void)onHuman:(id)sender
{
    //Initialize next scene, set type to human vs human, then replace scene
    GameScene *nextScene = [GameScene node];
    [nextScene setOpponentType:human];
    NSLog(@"on human");
    [[CCDirector sharedDirector] replaceScene:nextScene];
    
}
@end

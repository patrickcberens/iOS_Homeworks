//
//  MenuScene.m
//  ninjaToArtillery
//
//  Created by default on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene
-(id)init{
    if((self = [super init]) != nil){
        CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Play Against Computer" target:self selector:@selector(onComputer:)];
        CCMenuItemFont *menuItem2 = [CCMenuItemFont itemFromString:@"Play Against Human" target:self selector:@selector(onHuman:)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

-(void)onComputer:(id)sender
{
    nextScene = [GameScene node];
    [nextScene initWithGameType:computer];
    NSLog(@"on computer");
    [[CCDirector sharedDirector] replaceScene:nextScene];
}

-(void)onHuman:(id)sender
{
    nextScene = [GameScene node];
    [nextScene setOpponentType:human];
    NSLog(@"on human");
    [[CCDirector sharedDirector] replaceScene:nextScene];
    
}
@end

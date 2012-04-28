//
//  HelloWorldLayer.h
//  NinjaGame
//
//  Created by default on 2/26/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Computer.h"
#import "FighterJet.h"

typedef enum {
    computer,
    human
} GameType;


// HelloWorldLayer
@interface GameplayLayer : CCLayerColor <GameLayerDelegate>
{
    NSInteger _gameType;    //whether vs computer or human
    
    Player *_leftPlayer;
    Player *_rightPlayer;
    Computer *_rightComputer;
    
    NSMutableArray *_enemies;
    
}

-(void)setGameType:(GameType)type;

@end


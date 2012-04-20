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

#define WIN_SCORE 4 //5 kills to win

// HelloWorldLayer
@interface GameplayLayer : CCLayerColor <GameLayerDelegate>
{
    //CCSprite *_leftBottomTurret;
    //CCSprite *_rightBottomTurret;
    //CCSprite *_leftTopTurret;
    //CCSprite *_rightTopTurret;
    
    Player *_leftPlayer;
    Player *_rightPlayer;
    Computer *_rightComputer;
    
    //CCSprite *_nextProjectile;
    NSMutableArray *_targets;
    NSMutableArray *_leftProjectiles;
    NSMutableArray *_rightProjectiles;
    
    //CCLabelTTF *leftScoreLabel;
    NSInteger _leftProjectilesDestroyed;
    //CCLabelTTF *rightScoreLabel;
    NSInteger _rightProjectilesDestroyed;
}


// returns a CCScene that contains the HelloWorldLayer as the only child
//+(CCScene *) scene;
@end


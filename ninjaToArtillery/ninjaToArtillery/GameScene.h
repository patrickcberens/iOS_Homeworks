//
//  GameScene.h
//  ninjaToArtillery
//
//  Created by default on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameplayLayer.h"



@interface GameScene : CCScene {
    GameplayLayer *gameplayLayer;
}
-(id)initWithGameType:(GameType)gameType;
-(void)setOpponentType:(GameType)gameType;
@end

//
//  FireDelegate.h
//  ninjaToArtillery
//
//  Created by default on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol GameLayerDelegate <NSObject>

@required
//-(void)finishShoot:(CCSprite*)nextProjectile;
-(void)addChild:(CCNode*)node z:(NSInteger)z;
-(void)removeChild:(CCNode*)node cleanup:(BOOL)cleanup;
-(void)addEnemy:(CCNode*)node;
-(void)removeEnemy:(CCNode*)node;
@end

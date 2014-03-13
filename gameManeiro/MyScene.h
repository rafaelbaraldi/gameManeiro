//
//  MyScene.h
//  gameManeiro
//

//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const UInt32 cabecaCategory = 0x1 << 0;

static const UInt32 barrilCategory = 0x1 << 1;

static const UInt32 chaoCategory = 0x1 << 2;

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property SKSpriteNode* moto;
@property SKSpriteNode* cabeca;
@property SKSpriteNode *background;
@property SKSpriteNode* chao;
@property SKSpriteNode* leftWheelNode;
@property SKSpriteNode* rightWheelNode;
@property NSMutableArray* timeArray;

@property NSArray *motoFrames;
@property NSArray *backgroundFrames;


@end

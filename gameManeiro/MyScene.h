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

static const UInt32 bordaCategory = 0x1 << 3;

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property SKSpriteNode* moto;
@property SKSpriteNode* cabeca;
@property SKSpriteNode *background;
@property SKSpriteNode* chao;
@property SKSpriteNode* leftWheelNode;
@property SKSpriteNode* rightWheelNode;
@property SKSpriteNode* barrel;

@property NSMutableArray* timeArray;

@property int transparencia;

@property NSArray *motoFrames;
@property NSArray *backgroundFrames;
@property NSArray* barrelFrames;

@property SKSpriteNode *cloud;
@property SKSpriteNode *cloud2;

@property SKLabelNode* playNode;

@property BOOL firstTouch;

@property NSTimer* tempoNuvem;

@end

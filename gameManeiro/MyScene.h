//
//  MyScene.h
//  gameManeiro
//

//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

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

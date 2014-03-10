//
//  MyScene.m
//  gameManeiro
//
//  Created by RAFAEL BARALDI on 10/03/14.
//  Copyright (c) 2014 RAFAEL BARALDI. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        
        self.moto = [SKSpriteNode spriteNodeWithImageNamed:@"moto1.png"];
        
        [self.moto setSize:CGSizeMake(150, 133)];
        [self.moto setPosition:CGPointMake(120, 375)];
        
        self.moto.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.moto.size.width / 2];
        self.moto.physicsBody.dynamic = YES;
        self.moto.physicsBody.affectedByGravity = YES;
        self.moto.physicsBody.allowsRotation = YES;
        self.moto.physicsBody.density = 0.6f;
        self.moto.physicsBody.restitution = 0;
        
        
        [self addChild:self.moto];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        

    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

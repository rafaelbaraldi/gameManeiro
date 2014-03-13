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
        
        _timeArray = [[NSMutableArray alloc]init];
        
        self.physicsWorld.contactDelegate = self;
        
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self createFrameWithAtlasBackground:@"Background" :@"background"];
        [self movingBackground:@"MovingBike" :_backgroundFrames];
        
//        [self createFrameWithAtlas];
//        [self walkingMoto];
        
        
        
        CGRect borderRect = CGRectMake(0, 0, self.size.width, self.size.height);
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderRect];
        
        
//        self.moto = [SKSpriteNode spriteNodeWithImageNamed:@"moto1.png"];
        self.moto = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.4f green:0.5f blue:0.7f alpha:1.0f] size:CGSizeMake(120, 35)];
        
//        SKSpriteNode* imagemMoto = [SKSpriteNode spriteNodeWithImageNamed:@"moto1.png"];
//        [imagemMoto setSize:CGSizeMake(150, 133)];
//        [imagemMoto setPosition:CGPointMake(120, 500)];
//        [self addChild:imagemMoto];
        
//        [self.moto setSize:CGSizeMake(150, 133)];
        [self.moto setPosition:CGPointMake(120, 500)];
        
        self.moto.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120, 35)];
        self.moto.physicsBody.dynamic = YES;
        self.moto.physicsBody.affectedByGravity = YES;
        self.moto.physicsBody.allowsRotation = YES;
        self.moto.physicsBody.density = 0.6f;
        self.moto.physicsBody.restitution = 0.3;
        
        [self addChild:self.moto];
        
        _cabeca = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(28, 45)];
        _cabeca.position = CGPointMake(113, 542);
        _cabeca.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(28, 45)];
        _cabeca.physicsBody.dynamic = YES;
//        _cabeca.alpha = 0;
        _cabeca.physicsBody.categoryBitMask = cabecaCategory;
        _cabeca.physicsBody.contactTestBitMask = barrilCategory | chaoCategory;
        _cabeca.physicsBody.usesPreciseCollisionDetection = YES;
        
        [self addChild:_cabeca];
        
        SKPhysicsJointFixed* headJoint = [SKPhysicsJointFixed jointWithBodyA:_moto.physicsBody bodyB:_cabeca.physicsBody anchor:CGPointMake(113, 519.5)];
        
        [self.physicsWorld addJoint:headJoint];
        
        
        // Create the left wheel
        self.leftWheelNode = [SKSpriteNode spriteNodeWithImageNamed:@"bolaL.png"];
//        self.leftWheelNode.alpha = 0;
        self.leftWheelNode.size = CGSizeMake(45, 45);
        self.leftWheelNode.position = CGPointMake(self.moto.position.x-51, 457);
        self.leftWheelNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:22.5];
        self.leftWheelNode.physicsBody.dynamic = YES;
        [self addChild:self.leftWheelNode];
        
        // Create the right wheel
        self.rightWheelNode = [SKSpriteNode spriteNodeWithImageNamed:@"bolaR.png"];
//        self.rightWheelNode.alpha = 0;
        self.rightWheelNode.size = CGSizeMake(45, 45);
        self.rightWheelNode.position = CGPointMake(self.moto.position.x+51, 457);
        self.rightWheelNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:22.5];
        self.rightWheelNode.physicsBody.dynamic = YES;
        [self addChild:self.rightWheelNode];
        
        SKPhysicsJointFixed* leftPinJoint = [SKPhysicsJointFixed jointWithBodyA:self.moto.physicsBody bodyB:self.leftWheelNode.physicsBody anchor:CGPointMake(90, 483)];
        SKPhysicsJointFixed* rightPinJoint = [SKPhysicsJointFixed jointWithBodyA:self.moto.physicsBody bodyB:self.rightWheelNode.physicsBody anchor:CGPointMake(150, 483)];
        
        [self.physicsWorld addJoint:leftPinJoint];
        [self.physicsWorld addJoint:rightPinJoint];

        
        
        self.chao = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.8f green:0.68f blue:0.3f alpha:1.0f] size:CGSizeMake(self.size.width, 40)];
        
        [self.chao setPosition:CGPointMake(self.size.width/2, 290)];
        self.chao.alpha = 0;
        
        self.chao.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.chao.size];
        self.chao.physicsBody.dynamic = NO;
        self.chao.physicsBody.density = 1.0f;
        self.chao.physicsBody.restitution = 0;
        self.chao.physicsBody.categoryBitMask = chaoCategory;
        self.chao.physicsBody.contactTestBitMask = cabecaCategory;
        
        [self addChild:self.chao];
        
        
        
        SKSpriteNode* bola = [SKSpriteNode spriteNodeWithImageNamed:@"bola.png"];
        [bola setSize:CGSizeMake(120, 120)];
        [bola setPosition:CGPointMake(120-19, 350)];
        
        bola.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bola.size.width / 2];
        bola.physicsBody.dynamic = NO;
        bola.physicsBody.density = 1.0f;
        bola.physicsBody.restitution = 0;
        
//        [self addChild:bola];

    }
    return self;
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if(contact.bodyA.categoryBitMask == cabecaCategory || contact.bodyB.categoryBitMask == cabecaCategory){
        NSLog(@"morreu");
    }
}

-(void)createFrameWithAtlasBackground:(NSString*)pasta :(NSString*)imagem{
    
    NSMutableArray *backgroundFrame = [NSMutableArray array];
    SKTextureAtlas *bgAnimationAtlas = [SKTextureAtlas atlasNamed:pasta];
    
    int numImages = bgAnimationAtlas.textureNames.count;
    for (int i = 1; i <= numImages / 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@%d",imagem, i];
        SKTexture *temp = [bgAnimationAtlas textureNamed:textureName];
        [backgroundFrame addObject:temp];
    }
    
    _backgroundFrames = backgroundFrame;
    
    SKTexture *temp = _backgroundFrames[0];
    _background = [SKSpriteNode spriteNodeWithTexture:temp];
    _background.size = CGSizeMake(768, 580);
    _background.position = CGPointMake(384, 512);
    [self addChild:_background];
    [self backgroundFrames];
}

-(void)movingBackground:(NSString*)key :(NSArray*)frames
{
    //This is our general runAction method to make our bear walk.
    [_background runAction:[SKAction repeatActionForever:
                            [SKAction animateWithTextures:frames
                                             timePerFrame:0.15f
                                                   resize:NO
                                                  restore:YES]] withKey:key];
    return;
}

-(void)createFrameWithAtlas{
    
    NSMutableArray *motoFrame = [NSMutableArray array];
    SKTextureAtlas *motoAnimationAtlas = [SKTextureAtlas atlasNamed:@"Moto"];
    
    int numImages = motoAnimationAtlas.textureNames.count;
    for (int i = 1; i <= numImages / 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"moto%d", i];
        SKTexture *temp = [motoAnimationAtlas textureNamed:textureName];
        [motoFrame addObject:temp];
    }
    _motoFrames = motoFrame;
    
    SKTexture *temp = _motoFrames[0];
    _moto = [SKSpriteNode spriteNodeWithTexture:temp];
//    _moto.size = CGSizeMake(150, 133);
//    _moto.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_moto];
    [self motoFrames];
}

-(void)walkingMoto
{
    //This is our general runAction method to make our bear walk.
    [_moto runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:_motoFrames
                                       timePerFrame:0.1f
                                             resize:NO
                                            restore:YES]] withKey:@"ridingMoto"];
    return;
}


-(void)empina{
    //[self.rightWheelNode.physicsBody applyImpulse:CGVectorMake(0, 20)];
    [self.moto.physicsBody applyTorque:6];
}
-(void)desempina{
//    [self.rightWheelNode.physicsBody applyImpulse:CGVectorMake(0, -20)];
    [self.moto.physicsBody applyTorque:-5];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    
        
        if(location.x > self.size.width/2){
            [self mataTime];
            NSTimer* empinaTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(empina) userInfo:nil repeats:YES];
            [_timeArray addObject:empinaTime];        }
        else{
            [self mataTime];
            NSTimer* empinaTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(desempina) userInfo:nil repeats:YES];
            [_timeArray addObject:empinaTime];
        }

    }
}

-(void)mataTime{
    for (NSTimer* tempo in _timeArray) {
        [tempo invalidate];
        [_timeArray removeObject:tempo];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self mataTime];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self mataTime];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

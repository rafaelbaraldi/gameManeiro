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
        
        _metros = 0;
        _prefs = [NSUserDefaults standardUserDefaults];

        NSInteger* record = (NSInteger*)[_prefs integerForKey:@"recorde"];
        if(record != nil){
            _recorde = (long)record;
        }
        else{
            _recorde = 0;
        }
        
        NSInteger* last = (NSInteger*)[_prefs integerForKey:@"anterior"];
        if(record != nil){
            _anterior = (long)last;
        }
        else{
            _anterior = 0;
        }
        
        _transparencia = 0;
        _firstTouch = YES;
        
        _timeArray = [[NSMutableArray alloc]init];
        _listaObstaculos = [[NSMutableArray alloc]init];
        
        self.physicsWorld.contactDelegate = self;
        
        [self criaFrameFundo];
        [self criaMoto];
        
//        //testa os corpos da moto ( precisa comentar dois os metodos de cima)
//        [self testBodyWithImages];
        
        [self createRodas];
        [self createCabeca];
        
        [self createChao];
        [self createBordas];
      
        [self createPlayButton];
    }
    return self;
}

-(void)criaPontos{
    _metros = 0;
    
    _pontosNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _pontosNode.fontSize = 30;
    _pontosNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200);
    _pontosNode.fontColor = [UIColor grayColor];
    _pontosNode.text = [NSString stringWithFormat:@"Distancia: %ld metros", _metros];
    [self addChild:_pontosNode];
    
    _recordeNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _recordeNode.fontSize = 11;
    _recordeNode.position = CGPointMake(CGRectGetMidX(self.frame) - 315, CGRectGetMidY(self.frame) + 260);
    _recordeNode.fontColor = [UIColor grayColor];
    _recordeNode.text = [NSString stringWithFormat:@"Recorde: %ld metros", _recorde];
    [self addChild:_recordeNode];
    
    _anteriorNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _anteriorNode.fontSize = 11;
    _anteriorNode.position = CGPointMake(CGRectGetMidX(self.frame) - 315, CGRectGetMidY(self.frame) + 245);
    _anteriorNode.fontColor = [UIColor grayColor];
    _anteriorNode.text = [NSString stringWithFormat:@"Ultimo: %ld metros", _anterior];
    [self addChild:_anteriorNode];
}

-(void)createBarril{
    SKSpriteNode* barrel;
    barrel = [SKSpriteNode spriteNodeWithImageNamed:@"barrel.png"];
    barrel.size = CGSizeMake(80, 56);
    barrel.position = CGPointMake(800, 327);
    
    barrel.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:25];
    barrel.physicsBody.allowsRotation = NO;
    barrel.physicsBody.dynamic = YES;
    barrel.physicsBody.restitution = 0.5;
    barrel.physicsBody.categoryBitMask = barrilCategory;
    barrel.physicsBody.contactTestBitMask = cabecaCategory;
    
    self.barrelFrames = [self loadSpriteSheetFromImageWithName:@"barrel.png" withNumberOfSprites:4 withNumberOfRows:1 withNumberOfSpritesPerRow:4];
    
    SKAction *barrelAnim = [SKAction animateWithTextures:_barrelFrames timePerFrame:0.1f];
    SKAction *moveBarrelLeft = [SKAction moveTo:CGPointMake(-120, barrel.position.y) duration:6];
//    SKAction *moveBarrelRight = [SKAction moveTo:CGPointMake(800, _barrel.position.y) duration:0];
    SKAction *killBarrel = [SKAction removeFromParent];
    
    [barrel runAction:[SKAction repeatActionForever:barrelAnim]];
    [barrel runAction:[SKAction repeatActionForever:[SKAction sequence:@[moveBarrelLeft, killBarrel]]]];
    
    
    [self addChild:barrel];
    
    [_listaObstaculos addObject:barrel];
}

-(NSMutableArray*)loadSpriteSheetFromImageWithName:(NSString*)name withNumberOfSprites:(int)numSprites withNumberOfRows:(int)numRows withNumberOfSpritesPerRow:(int)numSpritesPerRow {
    NSMutableArray* animationSheet = [NSMutableArray array];
    
    SKTexture* mainTexture = [SKTexture textureWithImageNamed:name];
    
    for(int j = numRows-1; j >= 0; j--) {
        for(int i = 0; i < numSpritesPerRow; i++) {
            
            SKTexture* part = [SKTexture textureWithRect:CGRectMake(i*(1.0f/numSpritesPerRow), j*(1.0f/numRows), 1.0f/numSpritesPerRow, 1.0f/numRows) inTexture:mainTexture];
            
            [animationSheet addObject:part];
            
            if(animationSheet.count == numSprites)
                break;
        }
        
        if(animationSheet.count == numSprites)
            break;
        
    }
    return animationSheet;
}

-(void)createPlayButton{
    _playNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _playNode.fontSize = 50;
    _playNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    _playNode.fontColor = [UIColor redColor];
    _playNode.text = @"PLAY";
    [self addChild:_playNode];
}

-(void)testBodyWithImages{
    _moto = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.4f green:0.5f blue:0.7f alpha:1.0f] size:CGSizeMake(120, 35)];
    _moto.position = CGPointMake(120, 500);
    _moto.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120, 35)];
    _moto.physicsBody.dynamic = YES;
    _moto.physicsBody.affectedByGravity = YES;
    _moto.physicsBody.allowsRotation = YES;
    _moto.physicsBody.density = 0.6f;
    _moto.physicsBody.restitution = 0.3;

    SKSpriteNode* imagemMoto = [SKSpriteNode spriteNodeWithImageNamed:@"moto1.png"];
    [imagemMoto setSize:CGSizeMake(150, 133)];
    [imagemMoto setPosition:CGPointMake(120, 500)];
    [self addChild:imagemMoto];

    [self addChild:self.moto];
    
    _transparencia = 1;
}

-(void)removeObstaculos{
    for (SKSpriteNode* no in _listaObstaculos) {
        [no removeAllActions];
        [no removeFromParent];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if((contact.bodyA.categoryBitMask == cabecaCategory || contact.bodyB.categoryBitMask == cabecaCategory) && (contact.bodyA.categoryBitMask != bordaCategory && contact.bodyB.categoryBitMask != bordaCategory)){
            NSLog(@"morreu");
        
        _anterior = _metros;
        if(_metros > _recorde){
            _recorde = _metros;
        }
        [_prefs setInteger:_recorde forKey:@"recorde"];
        [_prefs setInteger:_anterior forKey:@"anterior"];
        [_prefs synchronize];
        
        
        [_tempoObstaculos invalidate];
        _tempoObstaculos = nil;
        
        
        [_tempoPontos invalidate];
        _tempoPontos = nil;
        
        [self mataTime];
        
        [_tempoNuvem invalidate];
        _tempoNuvem = nil;
        
        [_cloud removeAllActions];
        [_cloud2 removeAllActions];
//        [_barrel removeAllActions];
        
        [_cabeca removeFromParent];
        [_leftWheelNode removeFromParent];
        [_rightWheelNode removeFromParent];
        [_moto removeFromParent];
        [_cloud removeFromParent];
        [_cloud2 removeFromParent];
        [_background removeFromParent];
//        [_barrel removeFromParent];
        [_pontosNode removeFromParent];
        [_recordeNode removeFromParent];
        [_anteriorNode removeFromParent];
        
        [self removeObstaculos];
        
        _cabeca = nil;
        _leftWheelNode = nil;
        _rightWheelNode = nil;
        _moto = nil;
        _cloud = nil;
        _cloud2 = nil;
        _background = nil;
//        _barrel = nil;
        _pontosNode = nil;
        _recordeNode = nil;
        _anteriorNode = nil;
        
        [_listaObstaculos removeAllObjects];
        
        [self criaFrameFundo];
        [self criaMoto];
        [self createRodas];
        [self createCabeca];
        [self createPlayButton];
        
        _firstTouch = YES;
    }
}

-(void)criaFrameFundo{
    
    NSMutableArray *backgroundFrame = [NSMutableArray array];
    SKTextureAtlas *bgAnimationAtlas = [SKTextureAtlas atlasNamed:@"Background"];
    
    int numImages = bgAnimationAtlas.textureNames.count;
    for (int i = 1; i <= numImages / 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"background%d", i];
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

-(void)moverFundo
{
    [_background runAction:[SKAction repeatActionForever:
                            [SKAction animateWithTextures:_backgroundFrames
                                             timePerFrame:0.2f
                                                   resize:NO
                                                  restore:YES]] withKey:@"movendoFundo"];
    return;
}


-(void)criaMoto{
    
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
    _moto.size = CGSizeMake(150, 133);
    _moto.position = CGPointMake(120, 500);
    _moto.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(120, 35)];
    _moto.physicsBody.dynamic = NO;
    _moto.physicsBody.affectedByGravity = YES;
    _moto.physicsBody.allowsRotation = YES;
    [self addChild:_moto];
    [self motoFrames];
}

-(void)createRodas{
    // Create the left wheel
    _leftWheelNode = [SKSpriteNode spriteNodeWithImageNamed:@"bolaL.png"];
    _leftWheelNode.alpha = _transparencia;
    _leftWheelNode.size = CGSizeMake(45, 45);
    _leftWheelNode.position = CGPointMake(_moto.position.x-51, 457);
    _leftWheelNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:22.5];
    _leftWheelNode.physicsBody.dynamic = YES;
    _leftWheelNode.physicsBody.restitution = 0.5;
    [self addChild:_leftWheelNode];
    
    // Create the right wheel
    _rightWheelNode = [SKSpriteNode spriteNodeWithImageNamed:@"bolaR.png"];
    _rightWheelNode.alpha = _transparencia;
    _rightWheelNode.size = CGSizeMake(45, 45);
    _rightWheelNode.position = CGPointMake(_moto.position.x+51, 457);
    _rightWheelNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:22.5];
    _rightWheelNode.physicsBody.dynamic = YES;
    _rightWheelNode.physicsBody.restitution = 0.5;
    [self addChild:_rightWheelNode];
    
    SKPhysicsJointFixed* leftPinJoint = [SKPhysicsJointFixed jointWithBodyA:_moto.physicsBody bodyB:_leftWheelNode.physicsBody anchor:CGPointMake(90, 483)];
    SKPhysicsJointFixed* rightPinJoint = [SKPhysicsJointFixed jointWithBodyA:_moto.physicsBody bodyB:_rightWheelNode.physicsBody anchor:CGPointMake(150, 483)];
    
    [self.physicsWorld addJoint:leftPinJoint];
    [self.physicsWorld addJoint:rightPinJoint];
}

-(void)createCabeca{
    _cabeca = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(28, 45)];
    _cabeca.position = CGPointMake(113, 542);
    _cabeca.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(28, 45)];
    _cabeca.physicsBody.dynamic = YES;
    _cabeca.alpha = _transparencia;
    _cabeca.physicsBody.categoryBitMask = cabecaCategory;
    _cabeca.physicsBody.contactTestBitMask = barrilCategory | chaoCategory;
    _cabeca.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:_cabeca];
    
    SKPhysicsJointFixed* headJoint = [SKPhysicsJointFixed jointWithBodyA:_moto.physicsBody bodyB:_cabeca.physicsBody anchor:CGPointMake(113, 519.5)];
    
    [self.physicsWorld addJoint:headJoint];
}

-(void)createChao{
    _chao = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0.8f green:0.68f blue:0.3f alpha:1.0f] size:CGSizeMake(self.size.width, 40)];
    
    [_chao setPosition:CGPointMake(self.size.width/2, 290)];
    _chao.alpha = 0;
    
    _chao.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.chao.size];
    _chao.physicsBody.dynamic = NO;
    _chao.physicsBody.density = 1.0f;
    _chao.physicsBody.restitution = 0;
    _chao.physicsBody.categoryBitMask = chaoCategory;
    _chao.physicsBody.contactTestBitMask = cabecaCategory;
    
    [self addChild:_chao];
}

-(void)createBordas{
    CGRect borderRect = CGRectMake(0, 0, self.size.width, self.size.height);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:borderRect];
    self.physicsBody.restitution = 0.6;
    self.physicsBody.categoryBitMask = bordaCategory;
    self.physicsBody.contactTestBitMask = cabecaCategory;
}

-(void)moverMoto
{
    [_moto runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:_motoFrames
                                       timePerFrame:0.1f
                                             resize:NO
                                            restore:YES]] withKey:@"ridingMoto"];
    return;
}


-(void)empina{
    //[_rightWheelNode.physicsBody applyImpulse:CGVectorMake(0, 20)];
    [_moto.physicsBody applyTorque:6];
}
-(void)desempina{
//    [_rightWheelNode.physicsBody applyImpulse:CGVectorMake(0, -20)];
    [_moto.physicsBody applyTorque:-5];
}

-(void)moverNuvens{
    
    _cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud.png"];
    _cloud.size = CGSizeMake(700, 377);
    _cloud.position = CGPointMake(1100, 730);
    [self addChild:_cloud];
    
    SKAction *moveToLeftCloud = [SKAction moveTo:CGPointMake(-210, _cloud.position.y) duration:8];
    SKAction *moveToRightCloud = [SKAction moveTo:CGPointMake(1100, 730) duration:0];
    
    SKAction *sequenceCloud = [SKAction sequence:@[moveToLeftCloud, moveToRightCloud]];
    [_cloud runAction:[SKAction repeatActionForever:sequenceCloud]];
    
    _tempoNuvem = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(moverNuvem2) userInfo:nil repeats:NO];
}

-(void)moverNuvem2{
    
    _cloud2 = [SKSpriteNode spriteNodeWithImageNamed:@"cloud.png"];
    _cloud2.size = CGSizeMake(700, 377);
    _cloud2.position = CGPointMake(1100, 730);
    [self addChild:_cloud2];
    
    SKAction *moveToLeftCloud2 = [SKAction moveTo:CGPointMake(-210, _cloud2.position.y) duration:8];
    SKAction *moveToRightCloud2 = [SKAction moveTo:CGPointMake(1100, 730) duration:0];
    
    SKAction *sequenceCloud2 = [SKAction sequence:@[moveToLeftCloud2, moveToRightCloud2]];
    [_cloud2 runAction:[SKAction repeatActionForever:sequenceCloud2]];
}

-(void)incrementaMetros{
    _metros += 1.7361111125;
    _pontosNode.text = [NSString stringWithFormat:@"Distancia: %ld metros", _metros];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if(_firstTouch){
        _moto.physicsBody.dynamic = YES;
        
        [self moverMoto];
        [self moverFundo];
        [self moverNuvens];
//        [self createBarril];
        
        _tempoObstaculos = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createBarril) userInfo:nil repeats:YES];
        
        [_playNode removeFromParent];
        
        [self criaPontos];
        
        _tempoPontos = [NSTimer scheduledTimerWithTimeInterval:0.125 target:self selector:@selector(incrementaMetros) userInfo:nil repeats:YES];
        
        _firstTouch = NO;
    }
    else{
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

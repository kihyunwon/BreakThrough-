//
//  Level1.m
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/9/13.
//
//
#import "Level1.h"
#import "PauseScene.h"
#import "GlassDoor.h"
#import "Fist.h"

CCSprite *bg, *npc, *cop, *tem;
CCMenu *menu;
int timeToPlay;
int playtime;
int score;
int copCount;
CCLabelTTF *prepareLabel;
CCLabelTTF *timeoutLabel;
CCLabelTTF *playtimeLabel;
CCLabelTTF *scoreLabel;
BOOL win;
BOOL enableItem;
int ammo;

//variables for sprite
Fist* ddol;
int glassCount;
NSMutableArray* glassArray;
NSMutableArray* itemArray;
NSMutableArray * _monsters;
NSMutableArray * _projectiles;

@implementation Level1
-(id) init
{
    if(self=[super init])
    {
        
        // create and initialize our seeker sprite, and add it to this layer
        bg = [CCSprite spriteWithFile: @"stage1bg.png"];
        bg.position = ccp( 240, 160 );
        [self addChild:bg];
        
        CCMenuItem *Pause = [CCMenuItemImage itemWithNormalImage:@"pause.png"
                                                   selectedImage: @"pause.png"
                                                          target:self
                                                        selector:@selector(pause:)];
        CCMenu *PauseButton = [CCMenu menuWithItems: Pause, nil];
        PauseButton.position = ccp(30, 300);
        [self addChild:PauseButton z:1000];
        
        
        //initialize arrays
        glassCount = 10;
        glassArray = [[NSMutableArray alloc] initWithCapacity:glassCount];
        itemArray = [[NSMutableArray alloc] initWithCapacity:glassCount];
        for(int i=0;i<glassCount;i++)
        {
            GlassDoor* door = [GlassDoor createGate];
            if(i <= 4){
                [door setPosition:ccp(80 + 80*i,220)];
            } else {
                [door setPosition:ccp(80 + 80*(i-5),140)];
            }
            [self addChild:door];
            [glassArray addObject:door];
            [itemArray addObject:[NSNull null]];
        }
        //initialize DDOL
        ddol = [Fist createWeapon];
        ddol.position = ccp(100,80);
        [self addChild:ddol];
        
        //initialize game timer
        timeToPlay = 4;
        playtime = 60;
        
        CGSize s = [CCDirector sharedDirector].winSize;
        prepareLabel = [CCLabelTTF labelWithString:@"Prepare to play!" fontName:@"Marker Felt" fontSize:40];
        prepareLabel.position = ccp(s.width/2.0f, 150);
        
        timeoutLabel = [CCLabelTTF labelWithString:@"3" fontName:@"Marker Felt" fontSize:60];
        timeoutLabel.position = ccp(s.width/2.0f, 90);
        
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", score] fontName:@"Marker Felt" fontSize:30];
        scoreLabel.position = ccp(440,300);
        
        [self addChild:prepareLabel];
        [self addChild:timeoutLabel];
        [self addChild:scoreLabel];
        
        timeoutLabel.visible=NO;
        prepareLabel.visible=NO;
        scoreLabel.visible=NO;
        
        [self aboutToPlay];
        copCount = 1;
        [self schedule:@selector(gameLogic:) interval:7.0];
        [self schedule:@selector(intersect:)];
        _monsters = [[NSMutableArray alloc] init];
        _projectiles = [[NSMutableArray alloc] init];
        [self schedule:@selector(update:)];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self checkWin];
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    id move = [CCMoveTo actionWithDuration:0.1f position:location];
    [ddol runAction:move];
    
    for(CCSprite *glass in glassArray)
    {
        if(CGRectContainsPoint([glass boundingBox], ddol.position))
        {
            GlassDoor* glassPtr = ((GlassDoor*) glass);
            NSInteger index = [glassArray indexOfObject:glassPtr];
            
            if(glassPtr.health == 0){
                score+=10;
                [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
                glassPtr.visible = NO;
                glassPtr.deadOnce = YES;
                if(glassPtr.reborn){
                    tem = [itemArray objectAtIndex: index];
                    tem.visible = YES;
                }
            }
            int random = (arc4random() % 9);
            if(!glassPtr.reborn && glassPtr.deadOnce && index == random){
                [glassPtr setTexture:[[CCTextureCache sharedTextureCache] addImage:@"brokenwin.png"]];
                glassPtr.health = 30.0f;
                glassPtr.reborn = YES;
                CCSprite *item = [[CCSprite alloc] initWithFile:@"Fist.png"];
                item.visible = NO;
                item.position = glassPtr.position;
                [itemArray replaceObjectAtIndex:index withObject:item];
                [self addChild:item];
                glass.visible = YES;
            }
            [(GlassDoor*) glass takeDamage: ddol.hitpoints];
            break;
        }
    }
    for(CCSprite *fist in itemArray){
        if([fist isKindOfClass:[CCSprite class]] && fist.visible && CGRectContainsPoint([fist boundingBox], ddol.position))
        {
            enableItem = YES;
            ammo = 30;
            break;
        }
    }
}

-(void) checkWin
{
    int destructed = 0;
    for(CCSprite *glass in glassArray)
    {
        GlassDoor* glassPtr = ((GlassDoor*) glass);
        if(!glassPtr.visible){
            destructed++;
        }
    }
    if(destructed == glassCount){
        win = YES;
    }
}


-(void) initialDisplay
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Goal" message:@"Break All the Windows in 60 Seconds! \nAvoid the Cops!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [[CCDirector sharedDirector] pause];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [[CCDirector sharedDirector] resume];
    
}

-(void) pause: (id) sender
{
    NSString*string, *pause;
    if(win){
        string = @"Win~~~~";
    } else if(!win && playtime == -1){
        string = @"Lose~~ㅜ.ㅜ";
        pause = @"GameOver~";
    } else {
        string = @"Pause";
    }
    PauseScene *pauseScene = [PauseScene createPause:string:score: pause];
    pauseScene.parent = self;
    [[CCDirector sharedDirector] pushScene: (CCScene*)pauseScene];
}

-(void) tick: (ccTime) dt
{
    if(timeToPlay==1){
        timeoutLabel.visible=NO;
        prepareLabel.visible=NO;
        timeoutLabel = NULL;
        prepareLabel = NULL;
        self.touchEnabled = YES;
        [self schedule: @selector(playTick:) interval:1];
    } else {
        timeToPlay--;
        NSString * countStr;
        
        if(timeToPlay==1){
            countStr = [NSString stringWithFormat:@"GO!"];
            scoreLabel.visible = YES;
        } else{
            countStr = [NSString stringWithFormat:@"%d", timeToPlay-1];
        }
        timeoutLabel.string = countStr;
        [self displayer: timeoutLabel.position :timeoutLabel.string :60];
    }
}

-(void) aboutToPlay
{
    [self initialDisplay];
    timeoutLabel.visible=YES;
    prepareLabel.visible=YES;
    [self schedule: @selector(tick:) interval:1];
}

-(void) playTick : (ccTime) dt
{
    if(win){
        playtimeLabel.visible = NO;
        playtimeLabel.visible = NULL;
        self.touchEnabled = NO;
        [self pause:self];
    }
    if(playtime == -1){
        playtimeLabel.visible = NO;
        playtimeLabel.visible = NULL;
        self.touchEnabled = NO;
        [self pause:self];
    } else{
        [self displayer: ccp(240, 300) :[NSString stringWithFormat:@"%d", playtime] :30];
        playtime--;
    }
}

-(void) displayer : (CGPoint) pos : (NSString*) string : (int) fontsize
{
    CCLabelTTF* label = [CCLabelTTF labelWithString:string fontName:@"Marker Felt" fontSize:fontsize];
    label.position = pos;
    [self addChild: label z: 1001];
    id scoreAction = [CCSequence actions:
                      [CCSpawn actions:
                       [CCScaleBy actionWithDuration:0.4 scale:2.0],
                       [CCEaseIn actionWithAction:[CCFadeOut actionWithDuration:0.4] rate:2], nil],
                      [CCCallBlock actionWithBlock:^{
        [self removeChild:label cleanup:YES];}],nil];
    [label runAction:scoreAction];
}

- (void) addSimin {
    
    npc = [CCSprite spriteWithFile:@"simin.png"];
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = npc.contentSize.height / 2;
    int maxY = winSize.height - npc.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    npc.position = ccp(winSize.width + npc.contentSize.width/2, actualY);
    [self addChild:npc];
    
    // Determine speed of the monster
    int minDuration = 20.0;
    int maxDuration = 28.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(-npc.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    [npc runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}


- (void) addSecurity {
    
    cop = [CCSprite spriteWithFile:@"security.png"];
    cop.tag = 1;
    [_monsters addObject:cop];
    
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = cop.contentSize.height / 2;
    int maxY = winSize.height - cop.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    cop.position = ccp(winSize.width + cop.contentSize.width/2, actualY);
    [self addChild:cop];
    
    // Determine speed of the monster
    int minDuration = 19.0;
    int maxDuration = 27.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(-cop.contentSize.width/2, actualY)];
    //CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
    //                                            position:ccp(ddol.position.x, ddol.position.y)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [_monsters removeObject:node];
    }];
    [cop runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}



-(void)gameLogic:(ccTime)dt {
    
    [self addSimin];
    for(int i = 0; i<copCount; i++){
        [self addSecurity];
    }
    copCount++;
}

-(void) intersect:(ccTime)dt{
    if (CGRectIntersectsRect(ddol.boundingBox, npc.boundingBox)) {
        [self displayer: ccp(440,280) :@"-10" :30];
        if(score >= 10){
            score-=10;
            [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
        }
    }
    if (CGRectIntersectsRect(ddol.boundingBox, cop.boundingBox)) {
        playtime = -1;
        [self pause:self];
    }
}


-(void) dealloc
{
	
#ifndef KK_ARC_ENABLED
	// don't forget to call "super dealloc"
	[super dealloc];
#endif // KK_ARC_ENABLED
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(enableItem && ammo != 0) {
        tem.visible = NO;
        ammo--;
        // Choose one of the touches to work with
        UITouch *touch = [touches anyObject];
        CGPoint location = [self convertTouchToNodeSpace:touch];
        
        // Set up initial location of projectile
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *projectile = [[CCSprite alloc] initWithFile:@"Fist.png"];
        projectile.position = ddol.position;
        projectile.tag = 2;
        [_projectiles addObject:projectile];
        
        // Determine offset of location to projectile
        CGPoint offset = ccpSub(location, projectile.position);
        
        // Bail out if you are shooting down or backwards
        //if (offset.x <= 0) return;
        
        // Ok to add now - we've double checked position
        [self addChild:projectile];
        if (offset.x > 0) {
            int realX = winSize.width + (projectile.contentSize.width/2);
            float ratio = (float) offset.y / (float) offset.x;
            int realY = (realX * ratio) + projectile.position.y;
            CGPoint realDest = ccp(realX, realY);
            
            // Determine the length of how far you're shooting
            int offRealX = realX - projectile.position.x;
            int offRealY = realY - projectile.position.y;
            float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
            float velocity = 180/1; // 180pixels/1sec
            float realMoveDuration = length/velocity;
            
            // Move projectile to actual endpoint
            [projectile runAction:
             [CCSequence actions:
              [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
              [CCCallBlockN actionWithBlock:^(CCNode *node) {
                 [node removeFromParentAndCleanup:YES];
                 // CCCallBlockN in ccTouchesEnded
                 [_projectiles removeObject:node];
             }],
              nil]];
        }else if ((offset.x <= 0)&&(offset.y >0)) {
            int realX = winSize.width + (projectile.contentSize.width/2);
            float ratio = (float) offset.y / (float) offset.x;
            int realY = (realX * ratio) + projectile.position.y;
            CGPoint realDest = ccp(-realX, -realY);
            
            // Determine the length of how far you're shooting
            int offRealX = realX - projectile.position.x;
            int offRealY = realY - projectile.position.y;
            float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
            float velocity = 180/1; // 180pixels/1sec
            float realMoveDuration = length/velocity;
            
            // Move projectile to actual endpoint
            [projectile runAction:
             [CCSequence actions:
              [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
              [CCCallBlockN actionWithBlock:^(CCNode *node) {
                 [node removeFromParentAndCleanup:YES];
                 // CCCallBlockN in ccTouchesEnded
                 [_projectiles removeObject:node];
             }],
              nil]];
            
        }else {
            int realX = winSize.width + (projectile.contentSize.width/2);
            float ratio = (float) offset.y / (float) offset.x;
            int realY = (realX * ratio) + projectile.position.y;
            CGPoint realDest = ccp(-realX, realY);
            
            // Determine the length of how far you're shooting
            int offRealX = realX - projectile.position.x;
            int offRealY = realY - projectile.position.y;
            float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
            float velocity = 180/1; // 180pixels/1sec
            float realMoveDuration = length/velocity;
            
            // Move projectile to actual endpoint
            [projectile runAction:
             [CCSequence actions:
              [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
              [CCCallBlockN actionWithBlock:^(CCNode *node) {
                 [node removeFromParentAndCleanup:YES];
                 // CCCallBlockN in ccTouchesEnded
                 [_projectiles removeObject:node];
             }],
              nil]];
        }
    } else{
        enableItem = NO;
    }
}

- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *monster in _monsters) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                [monstersToDelete addObject:monster];
            }
        }
        
        for (CCSprite *monster in monstersToDelete) {
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
        }
        
        if (monstersToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }
        
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    
}


@end

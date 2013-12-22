//
//  Bat.h
//  BreakThrough!
//
//  Created by Ki Hyun Won on 11/11/13.
//
//

#import "Weapon.h"
#import "CCSprite.h"

@interface Bat : CCSprite <Weapon>
@property float hitpoints;
@property BOOL steel;
+(id) createWeapon;
-(id) initWithWeaponImage;
-(void) hitAction;
@end
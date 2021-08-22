//
//  SimpleType.m
//  play04
//
//  Created by xiaerfei on 2021/8/22.
//

#import "SimpleType.h"

@implementation SimpleType

- (instancetype)initWithName:(NSString *)name
                  upperTypes:(NSArray <SimpleType *>*)upperTypes {
    self = [super initWithName:name];
    if (self) {
        self.upperTypes = upperTypes;
    }
    return self;
}

@end

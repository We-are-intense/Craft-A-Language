//
//  Decl.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Decl.h"

@implementation Decl

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];
    }
    return self;
}

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(NSString *)name {
    self = [super initWithBeginPos:beginPos
                            endPos:endPos
                       isErrorNode:isErrorNode];
    if (self) {
        _name = [name copy];
    }
    return self;
}




@end

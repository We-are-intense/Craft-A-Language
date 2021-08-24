//
//  Variable.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Variable.h"
#import "AstVisitor.h"

@implementation Variable
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(nonnull NSString *)name {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        _name = [name copy];
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitVariable:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@Variable: %@%@", prefix, self.name, self.decl ? @", resolved" : @", not resolved");
}
@end

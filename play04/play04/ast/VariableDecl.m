//
//  VariableDecl.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "VariableDecl.h"
#import "AstVisitor.h"

@implementation VariableDecl

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(NSString *)name
                         varType:(SimpleType *)varType
                           initi:(Expression * _Nullable )initi {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode name:name];
    if (self) {
        _varType = varType;
        _initi   = initi;
    }
    return self;
}



- (void)dump:(NSString *)prefix {
    NSLog(@"%@VariableDecl%@, type: %@" ,prefix, self.name, self.varType);
    if (self.init == nil) {
        NSLog(@"%@no initialization.", prefix);
    } else {
        [self.init dump:[NSString stringWithFormat:@"%@    ", prefix]];
    }
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitVariableDecl:self additional:additional];
}


@end

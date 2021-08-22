//
//  CallSignature.m
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "CallSignature.h"
#import "AstVisitor.h"

@implementation CallSignature

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                       paramList:(ParameterList * _Nullable)params
                            type:(Type * _Nullable)type; {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        self.paramList = params;
        self.type = type;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitCallSignature:self additional:additional];
}


@end

//
//  VariableDecl.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "VariableDecl.h"
#import "AstVisitor.h"

@implementation VariableDecl

- (instancetype)initWithName:(NSString *)name
                     varType:(NSString *)varType
                        initi:(id)initi {
    self = [super initWithName:name];
    if (self) {
        _varType = [varType copy];
        _initi = initi;
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

- (id)accept:(AstVisitor *)visitor {
    return [visitor visitVariableDecl:self];
}


@end

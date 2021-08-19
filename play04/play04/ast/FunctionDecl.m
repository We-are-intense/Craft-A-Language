//
//  FunctionDecl.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "FunctionDecl.h"
#import "Block.h"
@interface FunctionDecl ()

@property (nonatomic, strong, readwrite) Block *body;

@end

@implementation FunctionDecl

- (instancetype)initWithName:(NSString *)name body:(Block *)body {
    self = [super initWithName:name];
    if (self) {
        _body = body;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitFunctionDecl:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionDecl%@",prefix, self.name);
    [self.body dump:[NSString stringWithFormat:@"%@\t", prefix]];
}

@end

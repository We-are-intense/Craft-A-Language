//
//  Prog.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Prog.h"
#import "AstVisitor.h"

@implementation Prog

- (void)dump:(NSString *)prefix {
    NSLog(@"%@Prog", prefix);
    for (Statement *stmt in self.stmts) {
        [stmt dump:[NSString stringWithFormat:@"%@\t", prefix]];
    }
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitProg:self additional:additional];
}

@end

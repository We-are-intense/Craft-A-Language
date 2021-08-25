//
//  ErrorExp.m
//  play04
//
//  Created by 夏二飞 on 2021/8/25.
//

#import "ErrorExp.h"
#import "AstVisitor.h"

@implementation ErrorExp


- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitErrorExp:self additional:additional];
}

@end

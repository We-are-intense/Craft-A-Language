//
//  NullLiteral.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "NullLiteral.h"
#import "AstVisitor.h"
@implementation NullLiteral
- (instancetype)init {
    self = [super init];
    if (self) {
        _value = @"null";
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor {
    return [visitor visitNullLiteral:self];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@%@", prefix, self.value);
}
@end

//
//  DecimalLiteral.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "DecimalLiteral.h"
#import "AstVisitor.h"

@implementation DecimalLiteral
- (instancetype)initWithValue:(NSNumber *)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor {
    return [visitor visitDecimalLiteral:self];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@%@", prefix, self.value);
}

@end

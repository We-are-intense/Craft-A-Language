//
//  Symbol.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Symbol.h"

@implementation Symbol
- (instancetype)initWithName:(NSString *)name
                        decl:(Decl *)decl
                        kind:(SymKind)kind {
    self = [super init];
    if (self) {
        _name = [name copy];
        _decl = decl;
        _kind = kind;
    }
    return self;
}


@end

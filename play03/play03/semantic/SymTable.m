//
//  SymTable.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "SymTable.h"

@implementation SymTable
- (instancetype)init
{
    self = [super init];
    if (self) {
        _table = [NSMutableDictionary dictionary];
    }
    return self;
}


@end

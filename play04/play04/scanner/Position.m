//
//  Position.m
//  play04
//
//  Created by 夏二飞 on 2021/8/18.
//

#import "Position.h"

@implementation Position

- (instancetype)initWithBegin:(NSUInteger)begin
                          end:(NSUInteger)end
                         line:(NSUInteger)line
                          col:(NSUInteger)col {
    self = [super init];
    if (self) {
        _begin = begin;
        _end = end;
        _line = line;
        _col = col;
    }
    
    return self;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"line: %ld col: %ld pos: %ld", self.line, self.col, self.begin];
}


@end

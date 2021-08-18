//
//  CharStream.m
//  play02
//
//  Created by 夏二飞 on 2021/8/11.
//

#import "CharStream.h"

@interface CharStream ()

@property (nonatomic, assign, readwrite) NSUInteger pos;
@property (nonatomic, assign, readwrite) NSUInteger line;
@property (nonatomic, assign, readwrite) NSUInteger col;

@property (nonatomic, copy) NSString *data;

@end

@implementation CharStream

- (instancetype)initWithData:(NSString *)data {
    self = [super init];
    if (self) {
        _data = [data copy];
        _line = 1;
    }
    return self;
}

- (unichar)peek {
    if (self.pos >= self.data.length) {
        return '\0';
    }
    return [self.data characterAtIndex:self.pos];
}

- (unichar)next {
    unichar ch = [self.data characterAtIndex:self.pos++];
    if (ch == '\n') {
        self.line ++;
        self.col = 0;
    } else {
        self.col ++;
    }
    return ch;
}

- (BOOL)eof {
    return self.peek == '\0';
}

- (Position *)getPosition {
    return NPosition(self.pos + 1, self.pos + 1, self.line, self.col);
}


@end

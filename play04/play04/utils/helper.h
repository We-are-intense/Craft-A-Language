//
//  helper.h
//  play04
//
//  Created by 夏二飞 on 2021/8/17.
//

#ifndef helper_h
#define helper_h

#define EnumKind(aa) + (NSInteger)aa;

#define EnumKindImp(aa) \
+ (NSInteger)aa { \
    return aa; \
}

#define InnerEnum(aa, ...) \
typedef NS_ENUM(NSInteger, aa) {\
    __VA_ARGS__ \
};

#endif /* helper_h */

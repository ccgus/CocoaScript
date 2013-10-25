//
//  MochaDefines.h
//  Mocha
//
//  Created by Logan Collins on 5/10/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//


#define MOCHA_EXTERN extern __attribute__((visibility("default")))
#define MOCHA_INLINE static inline __attribute__((visibility("default")))

#if (__has_feature(objc_fixed_enum))
#define MOCHA_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define MOCHA_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#else
#define MOCHA_ENUM(_type, _name) _type _name; enum
#define MOCHA_OPTIONS(_type, _name) _type _name; enum
#endif

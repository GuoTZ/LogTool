//
//  NSObject+LogToolRuntime.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "NSObject+LogToolRuntime.h"
#import <objc/message.h>
@implementation NSObject (LogToolRuntime)

- (BOOL)logtool_hasOverrideMethod:(SEL)selector ofSuperclass:(Class)superclass {
    return [NSObject logtool_hasOverrideMethod:selector forClass:self.class ofSuperclass:superclass];
}

+ (BOOL)logtool_hasOverrideMethod:(SEL)selector forClass:(Class)aClass ofSuperclass:(Class)superclass {
    if (![aClass isSubclassOfClass:superclass]) {
        return NO;
    }
    
    if (![superclass instancesRespondToSelector:selector]) {
        return NO;
    }
    
    Method superclassMethod = class_getInstanceMethod(superclass, selector);
    Method instanceMethod = class_getInstanceMethod(aClass, selector);
    if (!instanceMethod || instanceMethod == superclassMethod) {
        return NO;
    }
    return YES;
}

- (id)logtool_performSelectorToSuperclass:(SEL)aSelector {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector);
}

- (id)logtool_performSelectorToSuperclass:(SEL)aSelector withObject:(id)object {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL, ...) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector, object);
}

- (void)logtool_performSelector:(SEL)selector {
    [self logtool_performSelector:selector withReturnValue:NULL arguments:NULL];
}

- (void)logtool_performSelector:(SEL)selector withArguments:(void *)firstArgument, ... {
    [self logtool_performSelector:selector withReturnValue:NULL arguments:firstArgument, NULL];
}

- (void)logtool_performSelector:(SEL)selector withReturnValue:(void *)returnValue {
    [self logtool_performSelector:selector withReturnValue:returnValue arguments:NULL];
}

- (void)logtool_performSelector:(SEL)selector withReturnValue:(void *)returnValue arguments:(void *)firstArgument, ... {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    if (firstArgument) {
        [invocation setArgument:firstArgument atIndex:2];
        
        va_list args;
        va_start(args, firstArgument);
        void *currentArgument;
        NSInteger index = 3;
        while ((currentArgument = va_arg(args, void *))) {
            [invocation setArgument:currentArgument atIndex:index];
            index++;
        }
        va_end(args);
    }
    
    [invocation invoke];
    
    if (returnValue) {
        [invocation getReturnValue:returnValue];
    }
}

- (void)logtool_enumrateIvarsUsingBlock:(void (^)(Ivar ivar, NSString *ivarName))block {
    [NSObject logtool_enumrateIvarsOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)logtool_enumrateIvarsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Ivar, NSString *))block {
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(aClass, &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        if (block) block(ivar, [NSString stringWithFormat:@"%s", ivar_getName(ivar)]);
    }
    free(ivars);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject logtool_enumrateIvarsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

- (void)logtool_enumratePropertiesUsingBlock:(void (^)(objc_property_t property, NSString *propertyName))block {
    [NSObject logtool_enumratePropertiesOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)logtool_enumratePropertiesOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(objc_property_t, NSString *))block {
    unsigned int propertiesCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertiesCount);
    
    for (unsigned int i = 0; i < propertiesCount; i++) {
        objc_property_t property = properties[i];
        if (block) block(property, [NSString stringWithFormat:@"%s", property_getName(property)]);
    }
    
    free(properties);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject logtool_enumratePropertiesOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

- (void)logtool_enumrateInstanceMethodsUsingBlock:(void (^)(Method, SEL))block {
    [NSObject logtool_enumrateInstanceMethodsOfClass:self.class includingInherited:NO usingBlock:block];
}

+ (void)logtool_enumrateInstanceMethodsOfClass:(Class)aClass includingInherited:(BOOL)includingInherited usingBlock:(void (^)(Method, SEL))block {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(aClass, &methodCount);
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (block) block(method, selector);
    }
    
    free(methods);
    
    if (includingInherited) {
        Class superclass = class_getSuperclass(aClass);
        if (superclass) {
            [NSObject logtool_enumrateInstanceMethodsOfClass:superclass includingInherited:includingInherited usingBlock:block];
        }
    }
}

+ (void)logtool_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL))block {
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methods[i];
        if (block) {
            block(methodDescription.name);
        }
    }
    free(methods);
}

@end


@implementation NSObject (logtool_DataBind)

static char kAssociatedObjectKey_logtoolAllBoundObjects;
- (NSMutableDictionary<id, id> *)logtool_allBoundObjects {
    NSMutableDictionary<id, id> *dict = objc_getAssociatedObject(self, &kAssociatedObjectKey_logtoolAllBoundObjects);
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &kAssociatedObjectKey_logtoolAllBoundObjects, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)logtool_bindObject:(id)object forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return;
    }
    if (object) {
        [[self logtool_allBoundObjects] setObject:object forKey:key];
    } else {
        [[self logtool_allBoundObjects] removeObjectForKey:key];
    }
}

- (void)logtool_bindObjectWeakly:(id)object forKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return;
    }
    if (object) {
//        logtoolWeakObjectContainer *container = [[logtoolWeakObjectContainer alloc] initWithObject:object];
//        [self logtool_bindObject:container forKey:key];
    } else {
        [[self logtool_allBoundObjects] removeObjectForKey:key];
    }
}

- (id)logtool_getBoundObjectForKey:(NSString *)key {
    if (!key.length) {
        NSAssert(NO, @"");
        return nil;
    }
    id storedObj = [[self logtool_allBoundObjects] objectForKey:key];
//    if ([storedObj isKindOfClass:[logtoolWeakObjectContainer class]]) {
//        storedObj = [(logtoolWeakObjectContainer *)storedObj object];
//    }
    return storedObj;
}

- (void)logtool_bindDouble:(double)doubleValue forKey:(NSString *)key {
    [self logtool_bindObject:@(doubleValue) forKey:key];
}

- (double)logtool_getBoundDoubleForKey:(NSString *)key {
    id object = [self logtool_getBoundObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        double doubleValue = [(NSNumber *)object doubleValue];
        return doubleValue;
        
    } else {
        return 0.0;
    }
}

- (void)logtool_bindBOOL:(BOOL)boolValue forKey:(NSString *)key {
    [self logtool_bindObject:@(boolValue) forKey:key];
}

- (BOOL)logtool_getBoundBOOLForKey:(NSString *)key {
    id object = [self logtool_getBoundObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        BOOL boolValue = [(NSNumber *)object boolValue];
        return boolValue;
        
    } else {
        return NO;
    }
}

- (void)logtool_bindLong:(long)longValue forKey:(NSString *)key {
    [self logtool_bindObject:@(longValue) forKey:key];
}

- (long)logtool_getBoundLongForKey:(NSString *)key {
    id object = [self logtool_getBoundObjectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        long longValue = [(NSNumber *)object longValue];
        return longValue;
        
    } else {
        return 0;
    }
}

- (void)logtool_clearBindingForKey:(NSString *)key {
    [self logtool_bindObject:nil forKey:key];
}

- (void)logtool_clearAllBinding {
    [[self logtool_allBoundObjects] removeAllObjects];
}

- (NSArray<NSString *> *)logtool_allBindingKeys {
    NSArray<NSString *> *allKeys = [[self logtool_allBoundObjects] allKeys];
    return allKeys;
}

- (BOOL)logtool_hasBindingKey:(NSString *)key {
    return [[self logtool_allBindingKeys] containsObject:key];
}
@end

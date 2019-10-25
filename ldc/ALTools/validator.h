NS_INLINE id validateObject(id object)
{
    if (!object) return nil;
    else if (object == [NSNull null]) return nil;
    else if ([object respondsToSelector:@selector(length)] && [object length] == 0) return nil;
    else if ([object respondsToSelector:@selector(count)] && [object count] == 0) return nil;

    return object;
}

NS_INLINE bool objectEmpty(id object)
{
    if (!object) return YES;
    else if (object == [NSNull null]) return YES;
    else if ([object respondsToSelector:@selector(length)] && [object length] == 0) return YES;
    else if ([object respondsToSelector:@selector(count)] && [object count] == 0) return YES;

    return NO;
}

#pragma mark - Realm Validators

NS_INLINE id validateObjectWithDefault(id object, id defaultObject)
{
    if (!object) return defaultObject;
    else if (object == [NSNull null]) return defaultObject;
    else if ([object respondsToSelector:@selector(length)] && [object length] == 0) return defaultObject;
    else if ([object respondsToSelector:@selector(count)] && [object count] == 0) return defaultObject;

    return object;
}

#pragma mark - Primative Validators

NS_INLINE int validateInt(id object)
{
    if (!object) return 0;
    else if (object == [NSNull null]) return 0;
    else if ([object respondsToSelector:@selector(count)]) return 0;

    return [object intValue];
}

NS_INLINE NSInteger validateInteger(id object)
{
    if (!object) return 0;
    else if (object == [NSNull null]) return 0;
    else if ([object respondsToSelector:@selector(count)]) return 0;

    return [object integerValue];
}

NS_INLINE long long validateLong(id object)
{
    if (!object) return 0;
    else if (object == [NSNull null]) return 0;
    else if ([object respondsToSelector:@selector(count)]) return 0;

    return [object longLongValue];
}

NS_INLINE BOOL validateBOOL(id object)
{
    if (!object) return NO;
    else if (object == [NSNull null]) return NO;
    else if ([object respondsToSelector:@selector(count)]) return NO;

    return [object boolValue];;
}

NS_INLINE double validateDouble(id object)
{
    if (!object) return 0;
    else if (object == [NSNull null]) return 0;
    else if ([object respondsToSelector:@selector(count)]) return 0;

    return [object doubleValue];
}
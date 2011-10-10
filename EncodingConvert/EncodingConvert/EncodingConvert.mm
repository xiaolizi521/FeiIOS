//
//  EncodingConvert.m
//  EncodingConvert
//
//  Created by KaiKai on 11-10-3.
//  Copyright 2011年 TTPod. All rights reserved.
//

#import "EncodingConvert.h"

@interface NSString()

- (NSInteger)intValueWithUChar:(unichar)c;

@end

@implementation NSString(HEX)

- (NSInteger)intValueWithUChar:(unichar)c
{
	NSInteger nValue = 0;
	
	if (c >= '0' && c <= '9')
	{
		nValue = c - '0';
	}
	else if (c >= 'A' && c <= 'F')
	{
		nValue = c - 'A' + 10;
	}
	else if (c >= 'a' && c <= 'f')
	{
		nValue = c - 'a' + 10;
	}
	
	return nValue;
}

- (NSInteger)hexIntegerValue
{
	if (self == nil || self.length == 0)
	{
		return 0;
	}
//	static NSArray arrValue = NSArray arrayWithObjects:<#(id), ...#>, nil
	
	NSInteger nHexValue = 0;
	NSInteger len = self.length;
	NSInteger idx = len - 1;
	NSInteger radio = 1;
	for (; idx >= 0; --idx)
	{
		nHexValue += radio * [self intValueWithUChar:[self characterAtIndex:idx]];
		radio *= 16;
	}
	
	return nHexValue;
}

@end

@implementation EncodingConvert

- (id)init
{
    self = [super init];
    if (self)
	{
        // Initialization code here.
    }
    
    return self;
}

+ (NSString *)convertChineseToUnicode:(NSString *)aChinese
{
	if (aChinese == nil)
	{
		return nil;
	}
	
	NSMutableString* str = [[[NSMutableString alloc] init] autorelease];
	NSUInteger len = [aChinese length];
	NSUInteger idx = 0;
	for (; idx < len; ++idx)
	{
		unichar c = [aChinese characterAtIndex:idx];
		[str appendFormat:@"\\u%04x", c];
	}
	
	return str;
}

+ (NSString *)convertUnicodeToUTF8:(NSString *)aUnicode
{
	if (aUnicode == nil)
	{
		return nil;
	}
	
	NSMutableString* str = [[[NSMutableString alloc] init] autorelease];
	const char* cstr = [aUnicode UTF8String];
	unsigned int len = (unsigned int)strlen(cstr);
	unsigned int idx = 0;
	for (; idx < len; ++idx)
	{
		unsigned char c = *(cstr++);
		[str appendFormat:@"%%%02X", c];
	}
	
	return str;
}

+ (NSString *)convertUnicodeToGBK:(NSString *)aUnicode
{
	if (aUnicode == nil)
	{
		return nil;
	}
	
	NSMutableString* str = [[[NSMutableString alloc] init] autorelease];
	NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	const char* cstr = [aUnicode cStringUsingEncoding:gbkEncoding];
	unsigned int len = (unsigned int)strlen(cstr);
	unsigned int idx = 0;
	for (; idx < len; ++idx)
	{
		unsigned char c = *(cstr++);
		[str appendFormat:@"%%%02X", c];
	}
	
	return str;
}

+ (NSString *)convertUnicodeToChinese:(NSString *)aUnicode
{
	if (aUnicode == nil)
	{
		return nil;
	}
	
	NSString* separateStr = @"\\u";
	NSRange range = [aUnicode rangeOfString:separateStr];
	if (range.length <= 0)
	{
		separateStr = @"\\x";
	}
	NSArray* arr = [aUnicode componentsSeparatedByString:separateStr];
	NSUInteger count = [arr count];
	NSUInteger idx = 0;
	
	NSMutableString* str = [[[NSMutableString alloc] init] autorelease];
	for (; idx < count; ++idx)
	{
		NSString* arrStr = [arr objectAtIndex:idx];
		if ([arrStr length] == 0)
		{
			continue;
		}
		NSInteger nV = [arrStr hexIntegerValue];
		[str appendFormat:@"%C", nV];
	}
	
	return str;
}

+ (NSString *)convertUTF8ToUnicode:(NSString *)aUTF8
{
	if (aUTF8 == nil)
	{
		return nil;
	}
	
	NSArray* arr = [aUTF8 componentsSeparatedByString:@"%"];
	NSUInteger count = [arr count];
	NSUInteger idx = 0;
	NSUInteger idxCStr = 0;
	char* cstr = new char[count + 1];
	for (; idx < count; ++idx)
	{
		NSString* arrStr = [arr objectAtIndex:idx];
		if ([arrStr length] == 0)
		{
			continue;
		}
		NSInteger nV = [arrStr hexIntegerValue];
		*(cstr + idxCStr++) = nV;
	}
	*(cstr + idxCStr) = 0;
	NSString* unicodeStr = [NSString stringWithUTF8String:cstr];
	delete cstr;
	return unicodeStr;
}

+ (NSString *)convertGBKToUnicode:(NSString *)aGBK
{
	if (aGBK == nil)
	{
		return nil;
	}
	
	NSArray* arr = [aGBK componentsSeparatedByString:@"%"];
	NSUInteger count = [arr count];
	NSUInteger idx = 0;
	NSUInteger idxCStr = 0;
	char* cstr = new char[count + 1];
	for (; idx < count; ++idx)
	{
		NSString* arrStr = [arr objectAtIndex:idx];
		if ([arrStr length] == 0)
		{
			continue;
		}
		NSInteger nV = [arrStr hexIntegerValue];
		*(cstr + idxCStr++) = nV;
	}
	*(cstr + idxCStr) = 0;
	NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
	NSString* unicodeStr = [NSString stringWithCString:cstr encoding:gbkEncoding];
	delete cstr;
	return unicodeStr;

}

// Calculate MD5
NSString *NSUtil::MD5(NSString *str)
{
	if (str == nil) return nil;
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	const char *cstr = [str UTF8String];
	CC_MD5(cstr, strlen(cstr), result);
	return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

// Calculate SHA1
NSString *NSUtil::HmacSHA1(NSString *text, NSString *secret)
{
	NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
	NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
	
	unsigned char result[20];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
	return BASE64Encode(result, 20);
}

// BASE64 encode
NSString *NSUtil::BASE64Encode(const unsigned char *data, NSUInteger length, NSUInteger lineLength)
{
	// BASE64 table
	const static char c_baseTable[64] =
	{
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
		'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
		'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
		'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/'
	};
	
	NSMutableString *result = [NSMutableString stringWithCapacity:length];
	unsigned long ixtext = 0;
	unsigned long lentext = length;
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	short i = 0;
	short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while (YES)
	{
		ctremaining = lentext - ixtext;
		if (ctremaining <= 0) break;
		
		for (i = 0; i < 3; i++)
		{
			ix = ixtext + i;
			if (ix < lentext)
			{
				inbuf[i] = data[ix];
			}
			else
			{
				inbuf [i] = 0;
			}
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch (ctremaining)
		{
			case 1: 
				ctcopy = 2; 
				break;
			case 2: 
				ctcopy = 3; 
				break;
		}
		
		for (i = 0; i < ctcopy; i++)
		{
			[result appendFormat:@"%c", c_baseTable[outbuf[i]]];
		}
		
		for (i = ctcopy; i < 4; i++)
		{
			[result appendFormat:@"%c",'='];
		}
		
		ixtext += 3;
		charsonline += 4;
		
		if (lineLength > 0)
		{
			if (charsonline >= lineLength)
			{
				charsonline = 0;
				[result appendString:@"\n"];
			}
		}
	}
	
	return result;
}

// BASE64 decode
NSData *NSUtil::BASE64Decode(NSString *string)
{
	NSMutableData *mutableData = nil;
	
	if (string)
	{
		unsigned long ixtext = 0;
		unsigned long lentext = 0;
		unsigned char ch = 0;
		unsigned char inbuf[3], outbuf[4];
		short i = 0, ixinbuf = 0;
		BOOL flignore = NO;
		BOOL flendtext = NO;
		NSData *base64Data = nil;
		const unsigned char *base64data = nil;
		
		// Convert the string to ASCII data.
		base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
		base64data = (const unsigned char *)[base64Data bytes];
		mutableData = [NSMutableData dataWithCapacity:[base64Data length]];
		lentext = [base64Data length];
		
		while (YES)
		{
			if( ixtext >= lentext )
			{
				break;
			}
			ch = base64data[ixtext++];
			flignore = NO;
			
			if ((ch >= 'A') && (ch <= 'Z')) ch = ch - 'A';
			else if ((ch >= 'a') && (ch <= 'z')) ch = ch - 'a' + 26;
			else if ((ch >= '0') && (ch <= '9')) ch = ch - '0' + 52;
			else if (ch == '+') ch = 62;
			else if (ch == '=') flendtext = YES;
			else if (ch == '/') ch = 63;
			else flignore = YES; 
			
			if (!flignore)
			{
				short ctcharsinbuf = 3;
				BOOL flbreak = NO;
				
				if (flendtext)
				{
					if (!ixinbuf) break;
					if ((ixinbuf == 1) || (ixinbuf == 2)) ctcharsinbuf = 1;
					else ctcharsinbuf = 2;
					ixinbuf = 3;
					flbreak = YES;
				}
				
				inbuf [ixinbuf++] = ch;
				
				if (ixinbuf == 4)
				{
					ixinbuf = 0;
					outbuf [0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
					outbuf [1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
					outbuf [2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
					
					for (i = 0; i < ctcharsinbuf; i++)
					{
						[mutableData appendBytes:&outbuf[i] length:1];
					}
				}
				
				if (flbreak)
				{
					break;
				}
			}
		}
	}
	
	return mutableData;
}

@end

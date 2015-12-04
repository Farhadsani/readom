//
//  ErrorCode.h
//  
//
//  Created by wang hufei on 13-9-30.
//  Copyright (c) 2013年 Tendyron. All rights reserved.
//



#ifdef __SHOW_ERROR_CODE__

#define LocalizedStringFromTable(key, tbl, comment) \
[NSString stringWithFormat:@"%@(错误码:%@)", [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)], key]

#else

#define LocalizedStringFromTable(key, tbl, comment) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:(tbl)]

#endif




#include "base/ccConfig.h"
#ifndef __qmap_sqlite_h__
#define __qmap_sqlite_h__

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

int register_all_qmap_sqlite(lua_State* tolua_S);

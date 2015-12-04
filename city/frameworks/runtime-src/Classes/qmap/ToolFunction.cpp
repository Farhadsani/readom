//
//  ToolFunction.cpp
//  qmap
//
//  Created by 石头人6号机 on 15/7/13.
//
//

#include <stdio.h>

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

//#include "CCLuaEngine.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"
#include "CCLuaValue.h"
#include "CCLuaEngine.h"
//#include "LuaScriptHandlerMgr.h"

#include "ToolFunction.h"

static int lua_getSSID(lua_State *L)
{
    std::string strSSID = getSSID();
    lua_pushstring(L, strSSID.c_str());
    return 1;
}

static int lua_getSSIDCheck(lua_State *L)
{
    std::string strSSID_check = getSSID_Check();
    lua_pushstring(L, strSSID_check.c_str());
    return 1;
}

static int lua_getSSIDVerify(lua_State *L)
{
    std::string strSSID_verify = getSSID_Verify();
    lua_pushstring(L, strSSID_verify.c_str());
    return 1;
}

static int lua_ymOnEvent(lua_State *L)
{
    std::string value = luaL_checkstring(L , 1);
    ymOnEvent(value);
    return 1;
}

static int lua_getRequestHeader(lua_State *L)
{
    std::string strRequestHeader = getRequestHeader();
    lua_pushstring(L, strRequestHeader.c_str());
    return 1;
}

static int lua_getAppVersion(lua_State *L)
{
    std::string strAppVersion = getAppVersion();
    lua_pushstring(L, strAppVersion.c_str());
    return 1;
}

static int lua_showWebView(lua_State *L)
{
    //    luaL_checkudata(L, 1, "Scene");
    std::string strUrl = luaL_checkstring(L , 1);
    showWebView(strUrl.c_str());
    return 1;
}


static int lua_userLogin(lua_State *L)
{
    if (NULL == L)
        return 0;
    
//    lua_callback = luaL_ref(L, LUA_REGISTRYINDEX);
    
    lua_Number autoLogin =  tolua_tonumber(L, 1, 0);
    
    LUA_FUNCTION handler =  toluafix_ref_function(L, 2, 0);
    
    userLogin(autoLogin, [=](int ret, long userid, std::string name, std::string intro, std::string zone, std::string thumblink, std::string imglink ) {
        CCLOG("C++ 中转 %d", ret);
        
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 7;
        stack->pushLuaValue(LuaValue::intValue(ret));
        stack->pushLong(userid);  // ID
        stack->pushLuaValue(LuaValue::stringValue(name));   //name
        stack->pushLuaValue(LuaValue::stringValue(intro));    // intro
        stack->pushLuaValue(LuaValue::stringValue(zone));   // zone
        stack->pushLuaValue(LuaValue::stringValue(thumblink));   // user small image
        stack->pushLuaValue(LuaValue::stringValue(imglink));   // user big image
        
        
//        Director::getInstance()->getTextureCache()->
//        TextureCache* cache = Director::getInstance()->getTextureCache();
//        cache->addImage(<#cocos2d::Image *image#>, <#const std::string &key#>)
//        Texture2D *texture = Director::getInstance()->getTextureCache()->addImage("res/ui/image/shitouren.png");

//        stack->pushObject(userTexture, "Texture2D");  //
        
//        stack->push
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();

    });
    return 0;
    
 
}


//打开关于对话框
static int lua_openAbout(lua_State *L)
{
    LUA_FUNCTION handler =  toluafix_ref_function(L, 1, 0);
    openAbout([=](int ret){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 1;
        stack->pushLuaValue(LuaValue::intValue(ret));
        //        stack->push
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();

    });
    return 0;
}

//进入话题
static int lua_openTopic(lua_State *L)
{
//    lua_tointeger();
    long topicID = lua_tointeger(L, 1);
    LUA_FUNCTION handler =  toluafix_ref_function(L, 2, 0);
    
    openTopic(topicID, [=](){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 1;
        stack->pushLuaValue(LuaValue::intValue(0));
//        stack->pushLong(topicID);
        //        stack->push
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });
    
    return 0;
}

//出访
static int lua_openBuddy(lua_State *L)
{
    long ID =  lua_tointeger(L, 1);
    std::string name = tolua_tostring(L, 2, "");
    std::string intro = tolua_tostring(L, 3, "");
    std::string zone = tolua_tostring(L, 4, "");
    std::string thumblink = tolua_tostring(L, 5, "");
    std::string imglink = tolua_tostring(L, 6, "");
    LUA_FUNCTION handler =  toluafix_ref_function(L, 7, 0);
    
    long userID = ID;
    openBuddy(userID, name, intro, zone, thumblink, imglink, [=](long oldUserID){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 1;
        stack->pushLong(oldUserID);
        //        stack->push
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();

    });
    return 0;
}

static int lua_openUserHome(lua_State *L)
{
    LUA_FUNCTION handler =  toluafix_ref_function(L, 1, 0);
    openUserHome([=](long userid, std::string name, std::string intro, std::string zone, std::string thumblink, std::string imglink){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 6;
        stack->pushLong(userid);  // ID
        stack->pushLuaValue(LuaValue::stringValue(name));   //name
        stack->pushLuaValue(LuaValue::stringValue(intro));    // intro
        stack->pushLuaValue(LuaValue::stringValue(zone));   // zone
        stack->pushLuaValue(LuaValue::stringValue(thumblink));   // user small image
        stack->pushLuaValue(LuaValue::stringValue(imglink));   // user big image
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();

    });
    return 0;
}

static int lua_registBackToUserHome(lua_State *L)
{
    LUA_FUNCTION handler =  toluafix_ref_function(L, 1, 0);
    registBackToUserHome([=](long userid){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 1;
        stack->pushLong(userid);  // ID
//        stack->pushLuaValue(LuaValue::stringValue(name));   //name
//        stack->pushLuaValue(LuaValue::stringValue(intro));    // intro
//        stack->pushLuaValue(LuaValue::stringValue(zone));   // zone
//        stack->pushLuaValue(LuaValue::stringValue(thumblink));   // user small image
//        stack->pushLuaValue(LuaValue::stringValue(imglink));   // user big image
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
        
    });
    return 0;
}

static int lua_goback(lua_State *L)
{
    goback();
    return 0;
}

static int lua_openMail(lua_State *L)
{
    LUA_FUNCTION handler =  toluafix_ref_function(L, 1, 0);
    openMail([=](){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });
    return 0;
}

static int lua_openSendmail(lua_State *L)
{
    long ID =  lua_tointeger(L, 1);
    LUA_FUNCTION handler =  toluafix_ref_function(L, 2, 0);
    openSendmail(ID, [=](){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();

    });
    return 0;
}

//打开基本资料
static int lua_openUserCenter(lua_State *L)
{
    long ID =  lua_tointeger(L, 1);
    std::string name = tolua_tostring(L, 2, "");
    std::string intro = tolua_tostring(L, 3, "");
    std::string zone = tolua_tostring(L, 4, "");
    std::string thumblink = tolua_tostring(L, 5, "");
    std::string imglink = tolua_tostring(L, 6, "");
    LUA_FUNCTION handler =  toluafix_ref_function(L, 7, 0);
    
    long userID = ID;
    openUsercenter(userID, name, intro, zone, thumblink, imglink, [=](std::string intro, std::string zone){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 2;
        stack->pushLuaValue(LuaValue::stringValue(intro));    // intro
        stack->pushLuaValue(LuaValue::stringValue(zone));   // zone
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
        
    });

    return 0;
}

static int lua_openDetail(lua_State *L)
{
    long userID = lua_tointeger(L, 1);
    LUA_FUNCTION handler = toluafix_ref_function(L, 2, 0);
    openDetail(userID, [=](){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });
    return 0;
}

static int lua_openCallout(lua_State *L)
{
    LUA_FUNCTION handler = toluafix_ref_function(L, 1, 0);
    openSpeak([=](std::string str1, std::string str2, std::string str3){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 3;
        stack->pushLuaValue(LuaValue::stringValue(str1));
        stack->pushLuaValue(LuaValue::stringValue(str2));
        stack->pushLuaValue(LuaValue::stringValue(str3));
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });

    return 0;
}

static int lua_openCollect(lua_State *L)
{
    long userID = lua_tointeger(L, 1);
    LUA_FUNCTION handler = toluafix_ref_function(L, 2, 0);
    openCollect(userID, [=](){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });

    return 0;
}

//void TestFD()
//{
//    
//}

static int lua_openMap(lua_State *L)
{
//    lua_Number userID = tolua_tonumber(L, 1, 0);
    LUA_FUNCTION handler = toluafix_ref_function(L, 1, 0);
    openMap([=](int categoryType, std::string categoryID){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 2;
//        lua_CFunction f;
//        stack->pushFunctionByHandler(TestFD);
        stack->pushLuaValue(LuaValue::intValue(categoryType));
        stack->pushLuaValue(LuaValue::stringValue(categoryID));
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });
    return 0;
}

static int lua_openFriendTrend(lua_State *L)
{
    long userID = lua_tointeger(L, 1);
    LUA_FUNCTION handler = toluafix_ref_function(L, 2, 0);
    openFriendTrend(userID, [=](){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });

    return 0;
}

static int tolua_CUserManager_getInstance(lua_State *tolua_S)
{
    int argc = 0;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_getInstance'", nullptr);
            return 0;
        }
        CUserManager* ret = CUserManager::getInstance();
        object_to_luaval<CUserManager>(tolua_S, "qm.UserManager",(CUserManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "qm.UserManager:getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_getInstance'.",&tolua_err);
#endif
    return 0;
}

static int tolua_CUserManager_userid(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_userid'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_userid'", nullptr);
            return 0;
        }
        long ret = cobj->userid();
//        vec2_to_luaval(tolua_S, ret);
        
        lua_pushinteger(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:userid",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_userid'.",&tolua_err);
#endif
    
    return 0;
}

static int tolua_CUserManager_role(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_role'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_role'", nullptr);
            return 0;
        }
        long ret = cobj->role();
        //        vec2_to_luaval(tolua_S, ret);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:role",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_role'.",&tolua_err);
#endif
    
    return 0;
}

static int tolua_CUserManager_name(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_name'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_name'", nullptr);
            return 0;
        }
        std::string ret = cobj->name();
        lua_pushstring(tolua_S, ret.c_str());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:name",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_name'.",&tolua_err);
#endif
    
    return 0;
}
static int tolua_CUserManager_zone(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_zone'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_zone'", nullptr);
            return 0;
        }
        std::string ret = cobj->zone();
        lua_pushstring(tolua_S, ret.c_str());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:zone",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_zone'.",&tolua_err);
#endif
    
    return 0;
}
static int tolua_CUserManager_intro(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_intro'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_intro'", nullptr);
            return 0;
        }
        std::string ret = cobj->intro();
        lua_pushstring(tolua_S, ret.c_str());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:intro",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_intro'.",&tolua_err);
#endif
    
    return 0;
}
static int tolua_CUserManager_imglink(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_imglink'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_imglink'", nullptr);
            return 0;
        }
        std::string ret = cobj->imglink();
        lua_pushstring(tolua_S, ret.c_str());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:imglink",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_imglink'.",&tolua_err);
#endif
    
    return 0;
}
static int tolua_CUserManager_thumblink(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_thumblink'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_thumblink'", nullptr);
            return 0;
        }
        std::string ret = cobj->thumblink();
        lua_pushstring(tolua_S, ret.c_str());
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:thumblink",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_thumblink'.",&tolua_err);
#endif
    
    return 0;
}

static int tolua_CUserManager_userLoginStatus(lua_State *tolua_S)
{
    int argc = 0;
    CUserManager* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"qm.UserManager",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (CUserManager*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'tolua_CUserManager_userLoginStatus'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'tolua_CUserManager_userLoginStatus'", nullptr);
            return 0;
        }
        int ret = cobj->userLoginStatus();
        //        vec2_to_luaval(tolua_S, ret);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "qm.UserManager:userLoginStatus",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'tolua_CUserManager_userLoginStatus'.",&tolua_err);
#endif
    
    return 0;

}

void lua_register_UserManager(lua_State* tolua_S)
{
    tolua_module(tolua_S,"qm",0);
    tolua_beginmodule(tolua_S,"qm");
    
    tolua_usertype(tolua_S,"qm.UserManager");
    tolua_cclass(tolua_S,"UserManager","qm.UserManager","cc.Ref",nullptr);
    
    tolua_beginmodule(tolua_S,"UserManager");
    tolua_function(tolua_S, "getInstance", tolua_CUserManager_getInstance);
    tolua_function(tolua_S,"userid", tolua_CUserManager_userid);
    tolua_function(tolua_S,"role", tolua_CUserManager_role);
    tolua_function(tolua_S,"name", tolua_CUserManager_name);
    tolua_function(tolua_S,"intro", tolua_CUserManager_intro);
    tolua_function(tolua_S,"zone", tolua_CUserManager_zone);
    tolua_function(tolua_S,"imglink", tolua_CUserManager_imglink);
    tolua_function(tolua_S,"thumblink", tolua_CUserManager_thumblink);
    tolua_function(tolua_S, "userLoginStatus", tolua_CUserManager_userLoginStatus);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CUserManager).name();
    g_luaType[typeName] = "qm.UserManager";
    g_typeCast["UserManager"] = "qm.UserManager";
    tolua_endmodule(tolua_S);
}

static int lua_getAppName(lua_State* L)
{
    std::string strName = getAppName();
    lua_pushstring(L, strName.c_str());
    return 1;
}

// 打开景点介绍
static int lua_openSightIntro(lua_State *L)
{
    if (NULL == L)
        return 0;
    
    //    lua_callback = luaL_ref(L, LUA_REGISTRYINDEX);
    
    lua_Number sightID =  tolua_tonumber(L, 1, 0);
    std::string sightName = tolua_tostring(L, 2, "");
    std::string sightDesc = tolua_tostring(L, 3, "");
    LUA_FUNCTION handler =  toluafix_ref_function(L, 4, 0);
    
    openSightIntro(sightID, sightName, sightDesc, [=](  ) {

        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
        
    });
    return 0;
}
// 打开景点/片区指数筛选
static int lua_openCategory(lua_State *L)
{
    lua_Number sightID =  tolua_tonumber(L, 1, 0);
    lua_Number categoryType = tolua_tonumber(L, 2, 0);
    std::string categoryID =  tolua_tostring(L, 3, "");
    LUA_FUNCTION handler =  toluafix_ref_function(L, 4, 0);
    
    openCategory(sightID, categoryType, categoryID, [=](  ) {
        
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
        
    });
    return 0;

}

static int lua_onMainPage(lua_State *L)
{
    LUA_FUNCTION handler =  toluafix_ref_function(L, 1, 0);
    onMainPage([=](  ) {
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
        
    });
    return 0;
}

static int lua_maskedSprite(lua_State *L)
{
    bool ok = true;
    cocos2d::Sprite* textureSprite;
    ok &= luaval_to_object<cocos2d::Sprite>(L, 1, "cc.Sprite",&textureSprite);
    
    Sprite * maskSprite = Sprite::create("ui/image/mapMark/mapmark_1.png");
    RenderTexture * renderTexture = RenderTexture::create(maskSprite->getContentSize().width, maskSprite->getContentSize().height);
    
    maskSprite->setPosition(maskSprite->getContentSize().width / 2, maskSprite->getContentSize().height / 2);
    textureSprite->setPosition(textureSprite->getContentSize().width / 2, textureSprite->getContentSize().height / 2);
    
    maskSprite->setBlendFunc((BlendFunc){GL_ONE, GL_ZERO});
    textureSprite->setBlendFunc((BlendFunc){GL_DST_ALPHA, GL_ZERO});
    
    renderTexture->begin();
    maskSprite->visit();
    textureSprite->visit();
    renderTexture->end();
    
    Sprite * retval = Sprite::createWithTexture(renderTexture->getSprite()->getTexture());
    retval->setFlippedY(true);
    
//    cocos2d::Sprite* ret = cocos2d::Sprite::createWithTexture(arg0, arg1);
    object_to_luaval<cocos2d::Sprite>(L, "cc.Sprite",(cocos2d::Sprite*)retval);
    return 1;

}

static int lua_sceneLoadOver(lua_State *L)
{
    std::string sceneName = tolua_tostring(L, 1, "");
    sceneLoadOver(sceneName);
    return 0;
}

static int lua_openHotBall(lua_State *L)
{
    long userID = lua_tointeger(L, 1);
    LUA_FUNCTION handler = toluafix_ref_function(L, 2, 0);
    openHotBall(userID, [=](){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 0;
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });

    return 0;
}

static int lua_refreshUserHome(lua_State *L)
{
    LUA_FUNCTION handler = toluafix_ref_function(L, 1, 0);
    refreshUserHome([=](long userid){
        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
        int argNums = 1;
        stack->pushLong(userid);
        stack->executeFunctionByHandler(handler, argNums);
        stack->clean();
    });
    return 0;
}

void toolFunction_register(lua_State *L)
{
    lua_register_UserManager(L);
    lua_register( L, "lua_getSSID", lua_getSSID);
    lua_register( L, "lua_getSSIDCheck", lua_getSSIDCheck);
    lua_register( L, "lua_getSSIDVerify", lua_getSSIDVerify);
    lua_register( L, "lua_ymOnEvent", lua_ymOnEvent);
    lua_register( L, "lua_getRequestHeader", lua_getRequestHeader);
    lua_register( L, "lua_getAppVersion", lua_getAppVersion);
    lua_register( L , "lua_showWebView", lua_showWebView);
    lua_register( L, "lua_getAppName", lua_getAppName);
    
    
    lua_register(L, "lua_goback", lua_goback);
    lua_register(L, "lua_sceneLoadOver", lua_sceneLoadOver);
    
    lua_register(L, "lua_openUserHome", lua_openUserHome);     //打开小岛个人中心
    lua_register(L, "lua_refreshUserHome", lua_refreshUserHome);   //刷新小岛个人中心
    
    lua_register(L, "lua_userLogin", lua_userLogin);
    lua_register(L, "lua_openAbout", lua_openAbout);
    lua_register(L, "lua_openTopic", lua_openTopic);
    lua_register(L, "lua_openBuddy", lua_openBuddy);
    lua_register(L, "lua_openMail", lua_openMail);
    lua_register(L, "lua_openSendMail", lua_openSendmail);
    lua_register(L, "lua_openUserCenter", lua_openUserCenter);
    lua_register(L, "lua_openDetail", lua_openDetail);
    lua_register(L, "lua_openCallout", lua_openCallout);
    lua_register(L, "lua_openCollect", lua_openCollect);
    lua_register(L, "lua_openFriendTrend", lua_openFriendTrend);
    lua_register(L, "lua_openMap", lua_openMap);
    lua_register(L, "lua_registBackToUserHome", lua_registBackToUserHome);
    lua_register(L, "lua_openSightIntro", lua_openSightIntro);
    lua_register(L, "lua_openCategory", lua_openCategory);
    lua_register(L, "lua_onMainPage", lua_onMainPage);
    lua_register(L, "lua_maskedSprite", lua_maskedSprite);
    lua_register(L, "lua_openHotBall", lua_openHotBall);
}



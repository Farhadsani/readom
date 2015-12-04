//
//  lua_qmap_manual.cpp
//  qmap lua binding
//
//  Created by Shenghua Su on 3/14/15.
//
//

#include "lua_qmap_manual.hpp"
#include "QMapActionInterval.h"
#include "GestureRecognizer.h"
#include "ImagePicker.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"
#include "CCLuaValue.h"
#include "CCLuaEngine.h"
#include "LuaScriptHandlerMgr.h"

USING_NS_CC;

static int tolua_qmap_QMapActionInterval_create(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    bool ok = true;
    
    bool hasLuaError = false;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    do {
        
#if COCOS2D_DEBUG >= 1
        if (!tolua_isusertable(tolua_S,1,"qm.QMapActionInterval",0,&tolua_err)) {
            hasLuaError = true;
            break;
        }
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 2 or argc == 3)
    {
        double t = 0.0;
        ok &= luaval_to_number(tolua_S, 2, &t, "qm.QMapActionInterval:create");
        if (!ok) {
            hasLuaError = true;
            break;
        }

#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S,3,"LUA_FUNCTION",0,&tolua_err)) {
            hasLuaError = true;
            break;
        }
#endif
        
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S,3,0);
        
        bool hasExtraData = false;
        int  ref  = 0;
        if (argc == 3)
        {
#if COCOS2D_DEBUG >= 1
            if(!tolua_istable(tolua_S, 4, 0, &tolua_err)) {
                hasLuaError = true;
                break;
            }
#endif
            lua_pushvalue(tolua_S, 4);
            ref = luaL_ref(tolua_S, LUA_REGISTRYINDEX);
            hasExtraData = true;
        }
        
        QMapActionInterval* tolua_ret = new (std::nothrow) QMapActionInterval();
        tolua_ret->initWithDuration(t, [=](float timeTick){
            
            int callbackHandler =  ScriptHandlerMgr::getInstance()->getObjectHandler((void*)tolua_ret, ScriptHandlerMgr::HandlerType::CALLFUNC);
            
            if (0 != callbackHandler)
            {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                int argNums = 1;
                stack->pushLuaValue(LuaValue::floatValue(timeTick));
                if (hasExtraData)
                {
                    lua_rawgeti(tolua_S, LUA_REGISTRYINDEX,ref);
                    if (lua_istable(tolua_S, -1))
                    {
                        argNums += 1;
                    }
                    else
                    {
                        lua_pop(tolua_S, 1);
                    }
                }
                stack->executeFunctionByHandler(callbackHandler, argNums);
                if (hasExtraData)
                {
                    luaL_unref(tolua_S, LUA_REGISTRYINDEX,ref);
                }
                stack->clean();
            }
        });
        tolua_ret->autorelease();
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)tolua_ret, handler, ScriptHandlerMgr::HandlerType::CALLFUNC);
        
        int nID = (tolua_ret) ? (int)tolua_ret->_ID : -1;
        int* pLuaID = (tolua_ret) ? &tolua_ret->_luaID : NULL;
        toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"qm.QMapActionInterval");
        return 1;
    }
    
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "qm.QMapActionInterval:create", argc, 1);
    return 0;
        
    } while (false);
    
#if COCOS2D_DEBUG >= 1
    if (hasLuaError) {
        tolua_error(tolua_S,"#ferror in function 'tolua_qmap_QMapActionInterval_create'.",&tolua_err);
        return 0;
    }
#endif
    return 0;
}

static int lua_qmap_QMapActionInterval_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (QMapActionInterval)");
    return 0;
}

int lua_register_qmap_QMapActionInterval(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"qm.QMapActionInterval");
    tolua_cclass(tolua_S,"QMapActionInterval","qm.QMapActionInterval","cc.ActionInterval",nullptr);
    
    tolua_beginmodule(tolua_S,"QMapActionInterval");
    tolua_function(tolua_S,"create", tolua_qmap_QMapActionInterval_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(QMapActionInterval).name();
    g_luaType[typeName] = "qm.QMapActionInterval";
    g_typeCast["QMapActionInterval"] = "qm.QMapActionInterval";
    return 1;
}


static int lua_qmap_GestureRecognizer_create(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertable(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 0)
    {
        GestureRecognizer* tolua_ret = GestureRecognizer::create();
        
        int nID = (tolua_ret) ? (int)tolua_ret->_ID : -1;
        int* pLuaID = (tolua_ret) ? &tolua_ret->_luaID : NULL;
        toluafix_pushusertype_ccobject(tolua_S, nID, pLuaID, (void*)tolua_ret,"qm.GestureRecognizer");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_create", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_create'.",&tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_applyToNode(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    cocos2d::Node* nodeObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 1)
    {
#if COCOS2D_DEBUG >= 1
        if (!tolua_isusertype(tolua_S, 2, "cc.Node", 0, &tolua_err))
            goto tolua_lerror;
#endif
        nodeObj = (cocos2d::Node*)tolua_tousertype(tolua_S, 2, 0);
        
#if COCOS2D_DEBUG >= 1
        if (!nodeObj) {
            tolua_error(tolua_S, "invalid node type in function 'lua_qmap_GestureRecognizer_applyToNode'", NULL);
            return 0;
        }
#endif
        recognizerObj->applyToNode(nodeObj);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_applyToNode", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_applyToNode'.",&tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_removeFromNode(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 0)
    {
        recognizerObj->removeFromNode();
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_removeFromNode", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_removeFromNode'.",&tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addGestureBeganCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addGestureBeganCallback([=] {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(0);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                stack->executeFunctionByHandler(callbackHandler, 0);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addGestureBeganCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addGestureBeganCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addSingleTapCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addSingleTapCallback([=](const Vec2& point) {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(1);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                int argNums = 2;
                stack->pushLuaValue(LuaValue::floatValue(point.x));
                stack->pushLuaValue(LuaValue::floatValue(point.y));
                stack->executeFunctionByHandler(callbackHandler, argNums);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addSingleTapCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addSingleTapCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addDoubleTapCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addDoubleTapCallback([=](const Vec2& point) {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(2);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                int argNums = 2;
                stack->pushLuaValue(LuaValue::floatValue(point.x));
                stack->pushLuaValue(LuaValue::floatValue(point.y));
                stack->executeFunctionByHandler(callbackHandler, argNums);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addDoubleTapCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addDoubleTapCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addPanCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addPanCallback([=](const Vec2& point) {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(3);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                int argNums = 2;
                stack->pushLuaValue(LuaValue::floatValue(point.x));
                stack->pushLuaValue(LuaValue::floatValue(point.y));
                stack->executeFunctionByHandler(callbackHandler, argNums);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addPanCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addPanCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addDoubleFingersTapCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addDoubleFingersTapCallback([=](const Vec2& point) {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(4);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                int argNums = 2;
                stack->pushLuaValue(LuaValue::floatValue(point.x));
                stack->pushLuaValue(LuaValue::floatValue(point.y));
                stack->executeFunctionByHandler(callbackHandler, argNums);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addDoubleFingersTapCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addDoubleFingersTapCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addPinchCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addPinchCallback([=](const Vec2& point, float distanceRatio) {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(5);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                int argNums = 3;
                stack->pushLuaValue(LuaValue::floatValue(point.x));
                stack->pushLuaValue(LuaValue::floatValue(point.y));
                stack->pushLuaValue(LuaValue::floatValue(distanceRatio));
                stack->executeFunctionByHandler(callbackHandler, argNums);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addPinchCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addPinchCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addPanEndedCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addPanEndedCallback([=](const Vec2& velocity) {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(6);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                int argNums = 2;
                stack->pushLuaValue(LuaValue::floatValue(velocity.x));
                stack->pushLuaValue(LuaValue::floatValue(velocity.y));
                stack->executeFunctionByHandler(callbackHandler, argNums);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addPanEndedCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addPanEndedCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_addPinchEndedCallback(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err))
        goto tolua_lerror;
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
#if COCOS2D_DEBUG >= 1
        if(!toluafix_isfunction(tolua_S, 2, "LUA_FUNCTION", 0, &tolua_err))
            goto tolua_lerror;
#endif
        LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 2, 0);
        
        recognizerObj->addPinchEndedCallback([=] {
            
            int callbackHandler =  recognizerObj->getRefAtIndex(7);
            
            if (0 != callbackHandler) {
                LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                stack->executeFunctionByHandler(callbackHandler, 0);
                stack->clean();
            }
        }, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addPinchEndedCallback", argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addPinchEndedCallback'.", &tolua_err);
    return 0;
#endif
}

static int lua_qmap_GestureRecognizer_setEnabled(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    GestureRecognizer* recognizerObj = NULL;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    bool hasLuaError = false;
    do {
    
#if COCOS2D_DEBUG >= 1
        if (!tolua_isusertype(tolua_S, 1, "qm.GestureRecognizer", 0, &tolua_err)) {
            hasLuaError = true;
            break;
        }
#endif
    
    recognizerObj = (GestureRecognizer*)tolua_tousertype(tolua_S, 1, 0);
    argc = lua_gettop(tolua_S) - 1;
    if (argc == 1) {
        bool enabled;
        if (!luaval_to_boolean(tolua_S, 2, &enabled, "qm.GestureRecognizer:setEnabled")) {
            hasLuaError = true;
            break;
        }
        recognizerObj->setEnabled(enabled);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n", "lua_qmap_GestureRecognizer_addPinchCallback", argc, 1);
    return 0;
    } while (false);
    
#if COCOS2D_DEBUG >= 1
    if (hasLuaError) {
        tolua_error(tolua_S,"#ferror in function 'lua_qmap_GestureRecognizer_addPinchCallback'.", &tolua_err);
        return 0;
    }
#endif
    return 0;
}

int lua_register_qmap_GestureRecognizer(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"qm.GestureRecognizer");
    tolua_cclass(tolua_S,"GestureRecognizer","qm.GestureRecognizer","cc.Node",nullptr);
    
    tolua_beginmodule(tolua_S,"GestureRecognizer");
    tolua_function(tolua_S,"create", lua_qmap_GestureRecognizer_create);
    tolua_function(tolua_S,"applyToNode", lua_qmap_GestureRecognizer_applyToNode);
    tolua_function(tolua_S,"removeFromNode", lua_qmap_GestureRecognizer_removeFromNode);
    tolua_function(tolua_S,"setEnabled", lua_qmap_GestureRecognizer_setEnabled);
    tolua_function(tolua_S,"addGestureBeganCallback", lua_qmap_GestureRecognizer_addGestureBeganCallback);
    tolua_function(tolua_S,"addSingleTapCallback", lua_qmap_GestureRecognizer_addSingleTapCallback);
    tolua_function(tolua_S,"addDoubleTapCallback", lua_qmap_GestureRecognizer_addDoubleTapCallback);
    tolua_function(tolua_S,"addPanCallback", lua_qmap_GestureRecognizer_addPanCallback);
    tolua_function(tolua_S,"addDoubleFingersTapCallback", lua_qmap_GestureRecognizer_addDoubleFingersTapCallback);
    tolua_function(tolua_S,"addPinchCallback", lua_qmap_GestureRecognizer_addPinchCallback);
    tolua_function(tolua_S,"addPanEndedCallback", lua_qmap_GestureRecognizer_addPanEndedCallback);
    tolua_function(tolua_S,"addPinchEndedCallback", lua_qmap_GestureRecognizer_addPinchEndedCallback);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(GestureRecognizer).name();
    g_luaType[typeName] = "qm.GestureRecognizer";
    g_typeCast["GestureRecognizer"] = "qm.GestureRecognizer";
    return 1;
}

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
static int lua_qmap_ImagePicker_pickImage(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    bool hasLuaError = false;
    do {
        argc = lua_gettop(tolua_S);
        if (argc == 3 || argc == 4 || argc == 6 || argc == 9) {
            // 1. pick source
            ImagePicker::PickSource source;
            unsigned short int sourceValue;
            if (!luaval_to_ushort(tolua_S, 1, &sourceValue)) {
                hasLuaError = true;
                break;
            }
            source = ImagePicker::PickSource(sourceValue);
            
            // 2. image save path
            std::string imageSavePath;
            if (!luaval_to_std_string(tolua_S, 2, &imageSavePath)) {
                hasLuaError = true;
                break;
            }
        
            // 3. pick image done callback
            std::function<void(bool)> callback = nullptr;
            #if COCOS2D_DEBUG >= 1
                if(!toluafix_isfunction(tolua_S, 3, "LUA_FUNCTION", 0, &tolua_err)) {
                    hasLuaError = true;
                    break;
                }
            #endif
            LUA_FUNCTION handler =  toluafix_ref_function(tolua_S, 3, 0);
            if (handler != 0) {
                callback = [=](bool hasImageSaved) {
                    int callbackHandler =  ImagePicker::getLuaHandler();
                    if (0 != callbackHandler) {
                        LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
                        stack->pushLuaValue(LuaValue::booleanValue(hasImageSaved));
                        stack->executeFunctionByHandler(callbackHandler, 1);
                        stack->clean();
                    }
                };
            }
            
            // 4. jpg quality
            double jpgQuality = 0.8;
            if (argc >= 4) { // extract arg 4
                if (!luaval_to_number(tolua_S, 4, &jpgQuality)) {
                    hasLuaError = true;
                    break;
                }
            }
            
            // 5. user customized image fit size
            bool useCustomizedImageFitSize = false;

            // 6. image fit size
            Size imageFitSize = Size(0, 0);
            
            if (argc >= 6) { // extract arg 5, 6
                if (!luaval_to_boolean(tolua_S, 5, &useCustomizedImageFitSize)) {
                    hasLuaError = true;
                    break;
                }
                if (useCustomizedImageFitSize) {
                    if (!luaval_to_size(tolua_S, 6, &imageFitSize)) {
                        hasLuaError = true;
                        break;
                    }
                }
            }
            
            // 7. create thumbnail
            bool createThumbnail = false;
            
            // 8. thumbnail save path
            std::string thumbnailSavePath = "";
            
            // 9. thumbnail fill size
            Size thumbnailFillSize = Size(0, 0);
            
            if (argc == 9) { // extract arg 7, 8, 9
                if (!luaval_to_boolean(tolua_S, 7, &createThumbnail)) {
                    hasLuaError = true;
                    break;
                }
                if (!luaval_to_std_string(tolua_S, 8, &thumbnailSavePath)) {
                    hasLuaError = true;
                    break;
                }
                if (!luaval_to_size(tolua_S, 9, &thumbnailFillSize)) {
                    hasLuaError = true;
                    break;
                }
            }
            
            // error
            ImagePicker::Error error;
            
            // call 
            ImagePicker::pickImage(source,
                                   jpgQuality,
                                   useCustomizedImageFitSize,
                                   imageFitSize,
                                   imageSavePath.c_str(),
                                   createThumbnail,
                                   thumbnailFillSize,
                                   thumbnailSavePath.c_str(),
                                   callback,
                                   handler,
                                   &error);

            const char* tolua_ret = nullptr;
            switch (error) {
                case ImagePicker::NoError:
                    tolua_ret = "NoError";
                    break;
                case ImagePicker::PickSourceNotDefined:
                    tolua_ret = "PickSourceNotDefined";
                    break;
                case ImagePicker::PickSourceNotAvailable:
                    tolua_ret = "PickSourceNotAvailable";
                    break;
                default:
                    break;
            }
            tolua_pushstring(tolua_S, tolua_ret);
            return 1;
        }
        
        luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting 3, 4, 6 or 9\n", "lua_qmap_ImagePicker_pickImage", argc);
        return 0;
        
    } while (false);
    
#if COCOS2D_DEBUG >= 1
    if (hasLuaError) {
        tolua_error(tolua_S,"#ferror in function 'lua_qmap_ImagePicker_pickImage'.", &tolua_err);
        return 0;
    }
#endif
    return 0;
}

int lua_register_qmap_ImagePicker(lua_State* tolua_S)
{
//    tolua_usertype(tolua_S, "ImagePicker");
//    tolua_cclass(tolua_S, "ImagePicker", "qm.ImagePicker", "", nullptr);
    
    tolua_module(tolua_S, "ImagePicker", 0);
    tolua_beginmodule(tolua_S, "ImagePicker");
    tolua_function(tolua_S, "pickImage", lua_qmap_ImagePicker_pickImage);
    tolua_endmodule(tolua_S);
//    std::string typeName = typeid(ImagePicker).name();
//    g_luaType[typeName] = "qm.ImagePicker";
//    g_typeCast["ImagePicker"] = "qm.ImagePicker";
    
    return 0;
}
#endif

TOLUA_API int register_all_qmap_manual(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    tolua_open(tolua_S);
    
    tolua_module(tolua_S,"qm",0);
    tolua_beginmodule(tolua_S,"qm");
    
    lua_register_qmap_QMapActionInterval(tolua_S);
    lua_register_qmap_GestureRecognizer(tolua_S);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    lua_register_qmap_ImagePicker(tolua_S);
#endif
    
    tolua_endmodule(tolua_S);
    
    return 1;
}

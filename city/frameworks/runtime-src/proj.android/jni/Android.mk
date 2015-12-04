LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
#LOCAL_ARM_MODE := arm

LOCAL_MODULE := cocos2dlua_shared
#COCOS2DX_ROOT := $(LOCAL_PATH)/../../../cocos2d-x

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := hellolua/main.cpp \
../../Classes/VisibleRect.cpp \
../../Classes/AppDelegate.cpp \
../../Classes/ConfigParser.cpp

ifeq ($(NDK_DEBUG),1)
LOCAL_SRC_FILES += \
hellolua/Runtime_android.cpp \
../../Classes/runtime/ConnectWaitLayer.cpp \
../../Classes/runtime/ConsoleCommand.cpp \
../../Classes/runtime/FileServer.cpp \
../../Classes/runtime/Landscape_png.cpp \
../../Classes/runtime/lua_debugger.c \
../../Classes/runtime/PlayDisable_png.cpp \
../../Classes/runtime/PlayEnable_png.cpp \
../../Classes/runtime/Portrait_png.cpp \
../../Classes/runtime/Protos.pb.cc \
../../Classes/runtime/Runtime.cpp \
../../Classes/runtime/Shine_png.cpp \
../../ThirdParty/GestureRecognizer.cpp \
../../Classes/qmap/lua_qmap_manual.cpp \
../../Classes/SqliteManager.cpp \
../../Classes/qmap/ToolFunction.cpp \
../../Classes/qmap/QMapActionInterval.cpp 
endif
  
#anysdk
LOCAL_SRC_FILES += \
../../Classes/anysdkbindings.cpp \
../../Classes/anysdk_manual_bindings.cpp

LOCAL_C_INCLUDES := \
$(LOCAL_PATH)/../../Classes/runtime \
$(LOCAL_PATH)/../../Classes \
$(COCOS2DX_ROOT)/external \
$(COCOS2DX_ROOT)/external/protobuf-lite/src \
$(LOCAL_PATH)/../../Classes/quick-src \
$(LOCAL_PATH)/../../Classes/quick-src/extra \
$(LOCAL_PATH)/../../ThirdParty \
$(LOCAL_PATH)/../../qmap

#anysdk
LOCAL_C_INCLUDES +=	\
$(LOCAL_PATH)/../protocols/android \
$(LOCAL_PATH)/../protocols/include

#anysdk
LOCAL_WHOLE_STATIC_LIBRARIES += PluginProtocolStatic

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += lua_extensions_static
LOCAL_STATIC_LIBRARIES += extra_static
ifeq ($(NDK_DEBUG),1)
LOCAL_STATIC_LIBRARIES += cocos_protobuf-lite_static
endif

#$(warning   "COCOS2DX_ROOT")
#$(warning   $(COCOS2DX_ROOT))
#$(warning   "--------------------")
#$(warning   $(LOCAL_PATH))
#$(warning   "--------------------")
#$(warning   $(NDK_MODULE_PATH))
#$(warning "------------------------")


include $(BUILD_SHARED_LIBRARY)

$(call import-module, scripting/lua-bindings/proj.android)

$(call import-add-path, /web/shitouren-qmap-client/frameworks/runtime-src/Classes)
$(call import-add-path, /web/shitouren-qmap-client/frameworks/runtime-src/proj.android)
#$(call import-add-path, /web/shitouren-qmap-client/frameworks/cocos2d-x/external/lua/luajit/include)

$(call import-module, quick-src/lua_extensions)
$(call import-module, quick-src/extra)
$(call import-module, protobuf-lite)

#anysdk
$(call import-module,protocols/android)

    
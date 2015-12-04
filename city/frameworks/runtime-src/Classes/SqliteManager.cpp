//
//  SqliteManager.cpp
//  qmap
//
//  Created by 石头人6号机 on 15/3/13.
//
//

#include "SqliteManager.h"
USING_NS_CC;

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

static int lua_sqlite3_open(lua_State *L)
{
    CCLOG("c lua_sqlite3_open......");
    return 1;
}

static int lua_sqlite3_exec(lua_State *L)
{
    CCLOG("c lua_sqlite3_exec......");
    
//    sqlite3 *pdb = nullptr;
//    std::string path= FileUtils::getInstance()->getWritablePath()+"QMap.db";//数据库路径
//    int result = sqlite3_open(path.c_str(), &pdb);
//    if ( result != SQLITE_OK ){
//        CCLOG("open database failed,  number%d",result);
//    }
    
    std::string sql = luaL_checkstring(L , 1);
    CCLOG("%s", sql.c_str());
    
    SqliteManager::getInstance()->exec(sql.c_str());
    
//    result = sqlite3_exec(pdb, sql.c_str(), NULL, NULL, NULL);
//    if (result != SQLITE_OK){
//        CCLOG("exec sql failed");
//    }
//    
//    sqlite3_close(pdb);
    
//    L->lua_pushstring(<#lua_State *L#>, <#const char *s#>)
    
    return 1;
}

static int lua_sqlite3_commit(lua_State *L)
{
    CCLOG("c lua_sqlite3_commit");
    SqliteManager::getInstance()->commitTransaction(L);
    return 1;
}

static int lua_sqlite3_get_table(lua_State *L)
{
    CCLOG("c lua_sqlite3_get_table......");
//    sqlite3 *pdb = nullptr;
//    std::string path= FileUtils::getInstance()->getWritablePath()+"QMap.db";//数据库路径
////    std::string path= FileUtils::getInstance()->getWritablePath()+"res/Data/QMap.sqlite";//数据库路径
//    CCLOG("%s", path.c_str());
//    int result = sqlite3_open(path.c_str(), &pdb);
//    if ( result != SQLITE_OK ){
//        CCLOG("open database failed,  number%d",result);
//    }
    
    std::string sql = luaL_checkstring(L , 1);
    CCLOG("%s", sql.c_str());
    
    SqliteManager::getInstance()->find(sql.c_str(), L);

//    char **re;//查询结果
//    int r,c;//行、列
//    result = sqlite3_get_table(pdb,sql.c_str(),&re,&r,&c,NULL);//1
//    if ( result != SQLITE_OK ){
//        CCLOG("get table failed, error number is %d",result);
//    }
//    log("row is %d,column is %d",r,c);
//    for(int i=1;i<=r;i++)//2
//    {
//        for(int j=0;j<c;j++)
//        {
//            log("%s",re[i*c+j]);
//        }
//    }
//    sqlite3_free_table(re);
//    
//    sqlite3_close(pdb);
    
//    lua_newtable(L);
//    lua_pushstring(L,"mydata"); //压入key
//    lua_pushnumber(L,66);        //压入value
//    lua_settable(L,-3);

    return 1;
}

static int lua_sqlite3_close(lua_State *L)
{
    CCLOG("c lua_sqlite3_close......");
    return 1;
}

void sqlite_register(lua_State *L)
{
    lua_register(L, "lua_sqlite3_open", lua_sqlite3_open);
    lua_register(L, "lua_sqlite3_exec", lua_sqlite3_exec);
    lua_register(L, "lua_sqlite3_commit", lua_sqlite3_commit);
    lua_register(L, "lua_sqlite3_get_table", lua_sqlite3_get_table);
    lua_register(L, "lua_sqlite3_close", lua_sqlite3_close);
    
//    lua_register( L, "lua_getSSID", lua_getSSID);
//    lua_register( L, "lua_ymOnEvent", lua_ymOnEvent);
//    lua_register( L, "lua_getRequestHeader", lua_getRequestHeader);
//    lua_register( L, "lua_getAppVersion", lua_getAppVersion);
//    lua_register(L , "lua_showWebView", lua_showWebView);
}

SqliteManager::SqliteManager(){
    pdb = nullptr;
    std::string path= FileUtils::getInstance()->getWritablePath()+"QMapData.db";//数据库路径
    int result = sqlite3_open(path.c_str(), &pdb);
    if ( result != SQLITE_OK ){
        CCLOG("open database failed,  number%d",result);
    }
    
    
    
    std::string sql="CREATE TABLE \"CityTable\" (\"ID\" INTEGER PRIMARY KEY  NOT NULL  UNIQUE , \"name\" VARCHAR NOT NULL  UNIQUE , \"CName\" TEXT NOT NULL , \"Desc\" TEXT, \"scenicSpot\" VARCHAR NOT NULL  UNIQUE )";//创建表语句
    
//    this->exec(sql);
    
//    sql = "insert into CityTable  values(1,'guilin','桂林', '广西', 'guilinTable')";
//    this->exec(sql);
//    sql = "insert into CityTable  values(2,'qingdao','青岛', '山东', 'qingdaoTable')";
//    this->exec(sql);

}

SqliteManager* SqliteManager::s_SqliteManager = nullptr;

SqliteManager* SqliteManager::getInstance(){
    if(s_SqliteManager == nullptr){
        s_SqliteManager = new SqliteManager();
    }
    return s_SqliteManager;
}

SqliteManager::~SqliteManager(){
    if (pdb != nullptr){
        sqlite3_close(pdb);
    }
}

int SqliteManager::exec(std::string sql){
    
    CCLOG("%s", sql.c_str());
    
    int result = sqlite3_exec(pdb, sql.c_str(), NULL, NULL, NULL);
    if (result != SQLITE_OK){
        CCLOG("exec sql failed, error number is %d",result);
    }
    return 0;
}

bool SqliteManager::isExistTable(std::string tableName)
{
    char **re;//查询结果
    int r,c;//行、列
    
    std::string sql = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='";
    sql = sql + tableName + "'";
    int result = sqlite3_get_table(pdb,sql.c_str(),&re,&r,&c,NULL);//1
    if ( result != SQLITE_OK ){
        CCLOG("judge table isExist failed, error number is %d",result);
        sqlite3_free_table(re);
        
        return false;
    }
    log("row is %d,column is %d",r,c);
    
    bool returnValue = re[1*c] > 0;
    
    sqlite3_free_table(re);

    return returnValue;
}

void SqliteManager::find(std::string sql, lua_State *L)
{
    char **re;//查询结果
    int r,c;//行、列
    int result = sqlite3_get_table(pdb,sql.c_str(),&re,&r,&c,NULL);//1
    if ( result != SQLITE_OK ){
        CCLOG("get table failed, error number is %d",result);
    }
    log("row is %d,column is %d",r,c);

    lua_newtable(L);
    for(int i=1;i<=r;i++)//2
    {
        lua_pushnumber(L,  i);
        lua_newtable(L);
        for(int j=0;j<c;j++)
        {
//            log("%s",re[i*c+j]);
            lua_pushstring(L,re[j]);
            lua_pushstring(L,re[i*c+j]);
            lua_settable(L , -3);
//            lua_pushvalue(<#lua_State *L#>, <#int idx#>)
        }
        lua_settable(L , -3);
    }
    
    sqlite3_free_table(re);

}

int SqliteManager::createTable(std::string tableName)
{
    std::string sql = "create table ";
    sql = sql + tableName + " (ID integer primary key autoincrement,name text,sex text)";
    
    return 0;
}

int SqliteManager::insertValue(std::string tableName, std::string sql)
{
    return 0;
}

int SqliteManager::getValue(std::string tableName, std::string sql)
{
    char **re;//查询结果
    int r,c;//行、列
    sqlite3_get_table(pdb,"select * from student",&re,&r,&c,NULL);//1
    log("row is %d,column is %d",r,c);
    
    for(int i=1;i<=r;i++)//2
    {
        for(int j=0;j<c;j++)
        {
//            log("%s",re[i*c+j]);
        }
    }
    sqlite3_free_table(re);
    return 0;
}

void SqliteManager::commitTransaction(lua_State* L)
{
    int ret = 0;
    char *errmsg = 0;
    ret = sqlite3_exec(pdb, "BEGIN EXCLUSIVE", NULL, NULL, &errmsg);
    if (ret != SQLITE_OK)
    {
        printf("ret = %d, BEGIN EXCLUSIVE: %s", ret, errmsg);
    }
    
    int it = lua_gettop(L );
    lua_pushnil(L );
    while (lua_next(L , it)) {
        std::string sql = lua_tostring(L , -1);
//        log("the string is %s", sql.c_str());
        
        ret = sqlite3_exec(pdb , sql.c_str(), NULL , NULL, &errmsg);
        
        lua_pop(L , 1);
        if (ret != SQLITE_OK )
        {
            break;
        }

    }
    lua_pop(L , 1);
    if(ret == SQLITE_OK)
    {
        ret = sqlite3_exec(pdb,"COMMIT", NULL,NULL, &errmsg);
        if(ret != SQLITE_OK)
        {
            printf("ret = %d, COMMIT: %s\n", ret, errmsg);
        }
    }else
    {
        ret = sqlite3_exec(pdb,"ROLLBACK", NULL,NULL, &errmsg);
        if(ret != SQLITE_OK)
        {
            printf("ret = %d, ROLLBACK: %s\n", ret, errmsg);
        }
    }
}


//SELECT count(*) FROM sqlite_master WHERE type='table' AND name='tableName'

// 读写数据库。。。。。
//sqlite3 *pdb=NULL;
//
//
//std::string sql;
//int result;
//result=sqlite3_open(path.c_str(),&pdb);//打开或创建数据库
//if(result!=SQLITE_OK)
//{
//    log("open database failed,  number%d",result);
//}
//
//sql="create table student(ID integer primary key autoincrement,name text,sex text)";//创建表语句
//
//result=sqlite3_exec(pdb,sql.c_str(),NULL,NULL,NULL);//创建表
//if(result!=SQLITE_OK)
//log("create table failed");
//
//sql="insert into student  values(1,'student1','male')";
//result=sqlite3_exec(pdb,sql.c_str(),NULL,NULL,NULL);
//if(result!=SQLITE_OK)
//log("insert data failed!");
//
//sql="insert into student  values(2,'student2','female')";
//result=sqlite3_exec(pdb,sql.c_str(),NULL,NULL,NULL);
//if(result!=SQLITE_OK)
//log("insert data failed!");
//
//sql="insert into student  values(3,'student3','male')";
//result=sqlite3_exec(pdb,sql.c_str(),NULL,NULL,NULL);
//if(result!=SQLITE_OK)
//log("insert data failed!");

//char **re;//查询结果
//int r,c;//行、列
//sqlite3_get_table(pdb,"select * from student",&re,&r,&c,NULL);//1
//log("row is %d,column is %d",r,c);
//
//for(int i=1;i<=r;i++)//2
//{
//    for(int j=0;j<c;j++)
//    {
//        log("%s",re[i*c+j]);
//    }
//}
//sqlite3_free_table(re);
//
////删除数据
//sql="delete from student where ID=1";
//result=sqlite3_exec(pdb,sql.c_str(), NULL,NULL,NULL);//1
//if(result!=SQLITE_OK)
//log("delete data failed!");
//
//sqlite3_close(pdb); //关闭数据库
//-------------------------------------------
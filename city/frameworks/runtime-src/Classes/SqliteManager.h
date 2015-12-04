//
//  SqliteManager.h
//  qmap
//
//  Created by 石头人6号机 on 15/3/13.
//
//

#ifndef __qmap__SqliteManager__
#define __qmap__SqliteManager__

#include <stdio.h>
#include <sqlite3.h>
#include "cocos2d.h"

void sqlite_register(lua_State *L);

class SqliteManager  : public cocos2d::Ref{
    sqlite3 *pdb;
    
    static SqliteManager* s_SqliteManager;
    SqliteManager();
public:
    static SqliteManager* getInstance();
//    int createOrOpenDB();
    int exec(std::string sql);  // 执行sql语句
    void find(std::string sql, lua_State *L); // 查询语句
    int createTable(std::string tableName);
    int insertValue(std::string tableName, std::string sql);
    int getValue(std::string tableName, std::string sql);
    void commitTransaction( lua_State *L );
    bool isExistTable(std::string tableName);
    ~SqliteManager();
    
};

#endif /* defined(__qmap__SqliteManager__) */



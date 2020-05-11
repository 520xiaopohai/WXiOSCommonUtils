//
//  RSDataBaseManage.h
//  RSIosMobile
//
//  Created by yangdajun on 6/17/13.
//  Copyright (c) 2013 RaySharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

#define COLUMN_NAME @"columnName"
#define COLUMN_TYPE @"columnType"
#define COLUMN_VALUE @"columnValue"

#define INTERGER @"INTERGER"
#define TEXT @"TEXT"
#define BLOB @"BLOB"
#define REAL @"REAL"

@interface WXDataBaseManager: NSObject
{
    sqlite3 *database;
    NSString *dbFilePath;
}

#pragma mark - 初始化数据库

- (id)initDataBaseWithPath:(NSString *)dbPath;
- (void)closeDataBase;

#pragma mark -- 创建数据表

- (bool)createTableWithName:(NSString*)tbName columns:(NSArray*)colArray;

#pragma mark -- 数据列增删改

- (bool)insertTableColumn:(NSString*)tbName colName:(NSString*)colName cloType:(NSString*)colType;
- (bool)deleteTableColumn:(NSString*)tbName colName:(NSString*)colName;
- (bool)alterColumnType:(NSString*)tbName colName:(NSString*)colName colType:(NSString*)newType;

#pragma mark -- 获取一行数据

- (NSArray *)queryOneRowWithTableName:(NSString *)tbName key:(NSString *)key keyValue:(NSString *)keyValue;

#pragma mark -- 获取表的所有数据

- (NSArray*)loadAllDataWithTableName:(NSString*)tbName;

#pragma mark -- 清除表的所有数据

- (bool)clearTable:(NSString*)tbName;

#pragma mark -- 添加一行数据

- (bool)addDataToTable:(NSString*)tbName data:(NSArray*)dataArray;

#pragma mark -- 更新某一条数据

- (BOOL)updateRowWithTableName:(NSString *)tbName key:(NSString *)key keyValue:(NSString *)keyValue data:(NSArray *)dataArray;

#pragma mark -- 删除一行数据

- (bool)deleteDataFromTable:(NSString*)tbName key:(NSString *)key keyValue:(NSString*)keyValue;

#pragma mark -- 获取表的所有列数

-(int)tableCloumnCount:(NSString*)strTableName;

#pragma mark -- 获取表的数据条数

-(int)tableRowCount:(NSString*)strTableName;

@end

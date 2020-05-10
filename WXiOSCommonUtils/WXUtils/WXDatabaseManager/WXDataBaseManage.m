//
//  RSDataBaseManage.m
//  RSIosMobile
//
//  Created by yangdajun on 6/17/13.
//  Copyright (c) 2013 RaySharp. All rights reserved.
//

#import "WXDataBaseManage.h"

@implementation WXDataBaseManager

- (id)initDataBaseWithPath:(NSString *)dbPath
{
    self = [super init];
    
    if (self){
        
        if([self openDataBaseWithPath:dbPath]){
            return self ;
        }
        
    }
    
    return nil;
}

- (void)dealloc
{
    if(database){
        sqlite3_close(database);
        database = nil ;
    }
}

#pragma mark - 初始化数据库

- (bool)openDataBaseWithPath:(NSString *)dbPath
{
    @synchronized(self) {
        if(database){
            return true ;
        }
        
        if(dbPath == nil || [dbPath isEqualToString:@""]){
            return false ;
        }
        
        dbFilePath = dbPath ;
        
        if (sqlite3_open([dbFilePath UTF8String] , &database) != SQLITE_OK){
            
            sqlite3_close(database);
            database = nil ;
            
            NSLog(@"Open database error！");
            
            return false;
            
        }
        
        return true ;
    }
}

- (void)closeDataBase
{
    if(database){
        sqlite3_close(database);
        database = nil ;
    }
}

#pragma mark -- 创建数据表

/*
 参数:
 -tbName 表名
 -colArray 列数组，元素为字典，存储列名和列类型
 */

- (bool)createTableWithName:(NSString*)tbName columns:(NSArray*)colArray
{
    
    @synchronized(self) {
        if(!database){
            return false;
        }
        
        if(!tbName || [tbName isEqualToString:@""] || !colArray || !colArray.count){
            return false ;
        }
        
        //创建数据库表
        NSInteger count = colArray.count ;
        
        NSMutableString *strColumn = [[NSMutableString alloc]init];
        
        for(int i = 0 ; i < count ; i++){
            
            NSDictionary *dic = [colArray objectAtIndex:i];
            
            NSString *colName = [dic objectForKey:COLUMN_NAME];
            NSString *colType = [dic objectForKey:COLUMN_TYPE];
            
            if(colName && colType){
                if( i < count -1 ){
                    [strColumn appendString:[NSString stringWithFormat:@"%@ %@,",colName,colType]];
                }else{
                    [strColumn appendString:[NSString stringWithFormat:@"%@ %@",colName,colType]];
                }
            }
            
        }
        
        char *errorMsg = NULL ;
        
        NSString *createTable =[ NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);",tbName,strColumn];
        
        if (sqlite3_exec(database, [createTable UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK){
            
            NSLog(@"Create database table error: %s", errorMsg);
            
            return false;
        }
        
        return true ;
    }
}

#pragma mark -- 数据列增删改

- (bool)insertTableColumn:(NSString*)tbName colName:(NSString*)colName cloType:(NSString*)colType
{
    @synchronized(self) {
        if(!database){
            return false ;
        }
        
        if(!tbName || [tbName isEqualToString:@""] ||
           !colName || [colName isEqualToString:@""] ||
           !colType || [colType isEqualToString:@""]){
            return false ;
        }
        
        NSString *sqlStr = [NSString stringWithFormat:@"alter table %@ add %@ %@", tbName,colName,colType];
        
        sqlite3_stmt *stmt = nil;
        
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                
                return true;
            }
            
        }
        
        sqlite3_finalize(stmt);
        
        return false;
    }
}

- (bool)deleteTableColumn:(NSString*)tbName colName:(NSString*)colName
{
    @synchronized(self) {
        
        if(!database){
            return false ;
        }
        
        if(!tbName || [tbName isEqualToString:@""] ||
           !colName || [colName isEqualToString:@""]){
            return false ;
        }
        
        NSString *sqlStr = [NSString stringWithFormat:@"alter table %@ drop column %@", tbName,colName];
        
        sqlite3_stmt *stmt = nil;
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return true;
            }
        }
        sqlite3_finalize(stmt);
        
        return false;
    }
}

- (bool)alterColumnType:(NSString*)tbName colName:(NSString*)colName colType:(NSString*)newType
{
    @synchronized(self) {
        if(!database){
            return false ;
        }
        
        if(!tbName || [tbName isEqualToString:@""] ||
           !colName || [colName isEqualToString:@""] ||
           !newType || [newType isEqualToString:@""]){
            return false ;
        }
        
        NSString *sqlStr = [NSString stringWithFormat:@"alter table %@ alter column %@ %@", tbName,colName,newType];
        
        sqlite3_stmt *stmt = nil;
        if (sqlite3_prepare_v2(database, [sqlStr UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                sqlite3_finalize(stmt);
                return true;
            }
        }
        sqlite3_finalize(stmt);
        
        return false;
    }
}

#pragma mark -- 获取一行数据

- (NSArray *)queryOneRowWithTableName:(NSString *)tbName key:(NSString *)key keyValue:(NSString *)keyValue
{
    @synchronized(self) {
        if(!database){
            return nil;
        }
        
        if(!tbName || [tbName isEqualToString:@""]){
            return nil ;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        NSInteger colCount = [self tableCloumnCount:tbName];
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@ ;", tbName , key , keyValue];
        
        sqlite3_stmt *statement = nil ;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
            
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                
                for(int i = 0 ; i < colCount ; i++){
                    
                    NSString *colName = [NSString stringWithUTF8String:(char*)sqlite3_column_name(statement,i)];
                    NSInteger colType = sqlite3_column_type(statement,i) ;
                    
                    if(SQLITE_INTEGER ==  colType){
                        
                        NSInteger value = sqlite3_column_int(statement, i);
                        [dic setObject:[NSNumber numberWithInteger:value] forKey:colName];
                        
                        continue ;
                        
                    }
                    
                    if(SQLITE_FLOAT ==  colType){
                        
                        double value = sqlite3_column_double(statement, i);
                        [dic setObject:[NSNumber numberWithInteger:value] forKey:colName];
                        
                        continue ;
                        
                    }
                    
                    if(SQLITE_TEXT ==  colType){
                        
                        NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                        [dic setObject:value forKey:colName];
                        
                        continue ;
                        
                    }
                    
                    if(SQLITE_BLOB ==  colType){
                        
                        NSInteger length = sqlite3_column_bytes(statement, i);
                        const void *blobData = sqlite3_column_blob(statement, i);
                        NSData *data = [NSData dataWithBytes:blobData length:length];
                        [dic setObject:data forKey:colName];
                        
                        continue ;
                        
                    }
                }
                
                [array addObject:dic];
            }
        }
        
        sqlite3_finalize(statement);
        
        return array ;
    }
}

#pragma mark -- 获取表的所有数据

- (NSArray*)loadAllDataWithTableName:(NSString*)tbName
{
    @synchronized(self) {
        if(!database){
            return nil;
        }
        
        if(!tbName || [tbName isEqualToString:@""]){
            return nil ;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        NSInteger colCount = [self tableCloumnCount:tbName];
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@;", tbName];
        
        sqlite3_stmt *statement = nil ;
        
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
            
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                
                for(int i = 0 ; i < colCount ; i++){
                    
                    NSString *colName = [NSString stringWithUTF8String:(char*)sqlite3_column_name(statement,i)];
                    NSInteger colType = sqlite3_column_type(statement,i) ;
                    
                    if(SQLITE_INTEGER ==  colType){
                        
                        NSInteger value = sqlite3_column_int(statement, i);
                        [dic setObject:[NSNumber numberWithInteger:value] forKey:colName];
                        
                        continue ;
                        
                    }
                    
                    if(SQLITE_FLOAT ==  colType){
                        
                        double value = sqlite3_column_double(statement, i);
                        [dic setObject:[NSNumber numberWithInteger:value] forKey:colName];
                        
                        continue ;
                        
                    }
                    
                    if(SQLITE_TEXT ==  colType){
                        
                        NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                        [dic setObject:value forKey:colName];
                        
                        continue ;
                        
                    }
                    
                    if(SQLITE_BLOB ==  colType){
                        
                        NSInteger length = sqlite3_column_bytes(statement, i);
                        const void *blobData = sqlite3_column_blob(statement, i);
                        NSData *data = [NSData dataWithBytes:blobData length:length];
                        [dic setObject:data forKey:colName];
                        
                        continue ;
                        
                    }
                }
                
                [array addObject:dic];
            }
        }
        
        sqlite3_finalize(statement);
        
        return array ;
    }
    
  
}

#pragma mark -- 添加一列数据

/**
 Description

 @param tbName    表名
 @param dataArray 存储NSDictionary元素，包含列名，列类型，列值三种信息

 @return
 */
- (bool)addDataToTable:(NSString*)tbName data:(NSArray*)dataArray
{
    @synchronized(self) {
        if(!database){
            return false;
        }
        
        if(!tbName || [tbName isEqualToString:@""]){
            return false ;
        }
        
        if(!dataArray || !dataArray.count){
            return false ;
        }
        
        NSInteger colCount = dataArray.count ;
        
        NSString *strAdd = @"";
        NSMutableString *strCol = [[NSMutableString alloc]init];
        NSMutableString *strValue = [[NSMutableString alloc]init];
        
        //拼接sql语句
        for(int i = 0 ; i < colCount ; i++){
            
            NSDictionary *dic = [dataArray objectAtIndex:i];
            
            if( i < colCount - 1){
                [strCol appendString:[NSString stringWithFormat:@"%@,",[dic objectForKey:COLUMN_NAME]]];
                [strValue appendString:[NSString stringWithFormat:@"%@,",@"?"]];
            }else{
                [strCol appendString:[NSString stringWithFormat:@"%@",[dic objectForKey:COLUMN_NAME]]];
                [strValue appendString:@"?"];
            }
            
        }
        strAdd = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES(%@);",tbName,strCol,strValue];
        
        sqlite3_stmt *stmt = nil ;
        
        if (sqlite3_prepare_v2(database, [strAdd UTF8String], -1, &stmt, nil) == SQLITE_OK){
            
            //绑定列值并入库
            for(int i = 1 ; i < colCount + 1; i++){
                
                NSDictionary *dic = [dataArray objectAtIndex:i-1];
                NSInteger colType = [[dic objectForKey:COLUMN_TYPE]integerValue];
                
                if(SQLITE_INTEGER ==  colType){
                    int value = [[dic objectForKey:COLUMN_VALUE]intValue];
                    sqlite3_bind_int(stmt, i, value);
                    continue ;
                }
                
                if(SQLITE_FLOAT ==  colType){
                    double value = [[dic objectForKey:COLUMN_VALUE]doubleValue];
                    sqlite3_bind_int(stmt, i, value);
                    continue ;
                }
                
                if(SQLITE_TEXT ==  colType){
                    NSString *value = [dic objectForKey:COLUMN_VALUE];
                    sqlite3_bind_text(stmt, i, [value UTF8String], -1, NULL);
                    continue ;
                }
                
                if(SQLITE_BLOB ==  colType){
                    NSData *value = [dic objectForKey:COLUMN_VALUE];
                    sqlite3_bind_blob(stmt, i, [value bytes],(int)[value length], NULL);
                    continue ;
                }
                
            }
            
            if (sqlite3_step(stmt) != SQLITE_DONE){
                sqlite3_finalize(stmt);
                return false;
            }
        }
        
        sqlite3_finalize(stmt);
        
        return true;
    }
}

#pragma mark -- 更新某一条数据

//    UPDATE table_name
//    SET column1=value1,column2=value2,...
//    WHERE some_column=some_value;

- (BOOL)updateRowWithTableName:(NSString *)tbName key:(NSString *)key keyValue:(NSString *)keyValue data:(NSArray *)dataArray
{
    @synchronized(self) {
        
        if(!database){
            return false;
        }
        
        if(!tbName || [tbName isEqualToString:@""]){
            return false ;
        }
        
        if(!dataArray || !dataArray.count){
            return false ;
        }
        
        NSInteger colCount = dataArray.count ;
        
        NSString *strUpdate = @"";
        NSMutableString *strCol = [[NSMutableString alloc]init];
        
        //拼接sql语句
        for(int i = 0 ; i < colCount ; i++){
            
            NSDictionary *dic = [dataArray objectAtIndex:i];
            
            if( i < colCount - 1){
                [strCol appendString:[NSString stringWithFormat:@"%@=?,",[dic objectForKey:COLUMN_NAME]]];
            }else{
                [strCol appendString:[NSString stringWithFormat:@"%@=?",[dic objectForKey:COLUMN_NAME]]];
            }
            
        }
        strUpdate = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?;",tbName,strCol,key];
        
        sqlite3_stmt *stmt = nil ;
        
        if (sqlite3_prepare_v2(database, [strUpdate UTF8String], -1, &stmt, nil) == SQLITE_OK){
            
            //绑定列值并入库
            for(int i = 1 ; i < colCount + 1; i++){
                
                NSDictionary *dic = [dataArray objectAtIndex:i-1];
                NSInteger colType = [[dic objectForKey:COLUMN_TYPE]integerValue];
                
                if(SQLITE_INTEGER ==  colType){
                    int value = [[dic objectForKey:COLUMN_VALUE]intValue];
                    sqlite3_bind_int(stmt, i, value);
                    continue ;
                }
                
                if(SQLITE_FLOAT ==  colType){
                    double value = [[dic objectForKey:COLUMN_VALUE]doubleValue];
                    sqlite3_bind_int(stmt, i, value);
                    continue ;
                }
                
                if(SQLITE_TEXT ==  colType){
                    NSString *value = [dic objectForKey:COLUMN_VALUE];
                    sqlite3_bind_text(stmt, i, [value UTF8String], -1, NULL);
                    continue ;
                }
                
                if(SQLITE_BLOB ==  colType){
                    NSData *value = [dic objectForKey:COLUMN_VALUE];
                    sqlite3_bind_blob(stmt, i, [value bytes],(int)[value length], NULL);
                    continue ;
                }
                
            }
            
            //绑定条件
            sqlite3_bind_text(stmt, colCount + 1, [keyValue UTF8String], -1, NULL);
            
            if (sqlite3_step(stmt) != SQLITE_DONE){
                sqlite3_finalize(stmt);
                return false;
            }
        }
        
        sqlite3_finalize(stmt);
        
        return true;
        
    }
}

#pragma mark -- 删除一行数据

- (bool)deleteDataFromTable:(NSString*)tbName key:(NSString *)key keyValue:(NSString*)keyValue
{
    @synchronized(self) {
        
        if(!database){
            return false;
        }
        
        if(!tbName || [tbName isEqualToString:@""]){
            return false ;
        }
        
        NSString *strDel = [NSString stringWithFormat:@"DELETE FROM %@ where %@ = ?;",tbName,key];
        
        sqlite3_stmt *stmt = nil ;
        if (sqlite3_prepare_v2(database, [strDel UTF8String], -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_text(stmt, 1, [keyValue UTF8String], -1, NULL);
            if (sqlite3_step(stmt) != SQLITE_DONE){
                sqlite3_finalize(stmt);
                return false;
            }
        }
        sqlite3_finalize(stmt);
        
        return  true;
    }
}

#pragma mark -- 清空数据

- (bool)clearTable:(NSString*)tbName
{
    @synchronized(self) {
        if(!database){
            return false;
        }
        
        if(!tbName || [tbName isEqualToString:@""]){
            return false ;
        }
        
        NSString *strDel = [NSString stringWithFormat:@"DELETE FROM %@ ;",tbName];
        
        sqlite3_stmt *stmt = nil ;
        if (sqlite3_prepare_v2(database, [strDel UTF8String], -1, &stmt, nil) == SQLITE_OK){
            if (sqlite3_step(stmt) != SQLITE_DONE){
                sqlite3_finalize(stmt);
                return false;
            }
        }
        sqlite3_finalize(stmt);
        
        return  true;
    }
}

#pragma mark -- 获取表的所有列数

-(int)tableCloumnCount:(NSString*)strTableName
{
    @synchronized(self) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ;", strTableName];
        
        sqlite3_stmt *stmt = nil;
        
        if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) != SQLITE_OK){
            
            if(stmt){
                sqlite3_finalize(stmt);
            }
            
            return -1;
            
        }
        
        int col_count = sqlite3_column_count(stmt);
        if(stmt){
            sqlite3_finalize(stmt);
        }
        
        return col_count;
    }
}

#pragma mark -- 获取表的行数

- (int)tableRowCount:(NSString*)strTableName
{
    @synchronized(self) {
        if(!database){
            return false;
        }
        
        if(!strTableName || [strTableName isEqualToString:@""]){
            return false ;
        }
        
        int result;
        char * errmsg = NULL;
        char **dbResult;
        int nRow, nColumn;
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ;", strTableName];
        
        
        @try {
            result = sqlite3_get_table( database, [query UTF8String], &dbResult, &nRow, &nColumn, &errmsg );
        } @catch (NSException *exception) {
            
        }
        
        
        if( SQLITE_OK == result ){
            sqlite3_free_table( dbResult );
            return nRow ;
        }
        
        sqlite3_free_table( dbResult );
        
        return 0;
        
    }
    
    
}

@end

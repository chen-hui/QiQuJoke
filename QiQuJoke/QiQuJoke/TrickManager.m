//
//  TrickManager.m
//  QiQuJoke
//
//  Created by 少杰范 on 15/8/31.
//  Copyright (c) 2015年 少杰范. All rights reserved.
//

#import "TrickManager.h"


@implementation TrickManager
/**
 *  脑筋急转弯默认加载项－全部  以及获取了分类
 *
 *  @param complete 获取数据完成回调函数
 */
-(void)initTricksOfCateAllWithComplete:(void (^)(NSArray *))complete{
    
    NSString *urlStr = [NSString stringWithFormat:kCommonUrl,kTrickQuery,kTrickAppId,kTrickAppId,kPageDefaultCount,@"",(long)0];
    
    //对数据进行本地化处理
    //**************************************
    NSString *filePath = [self filePathFromUrl:urlStr];
    BOOL isExists = [self isFileExists:filePath];
    if (isExists) {
        NSData *backData = [NSData  dataWithContentsOfFile:filePath];
        NSArray *resultData = [self afterGetAllSuccessWithData:backData];
        if (resultData && complete) {
            complete(resultData);
        }
        else if (complete)
        {
            complete(nil);
        }
    }
    else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^void(AFHTTPRequestOperation * optation, id responseObject) {
            NSData *backData = optation.responseData;
            BOOL isOK = [backData writeToFile:filePath atomically:YES];
            NSArray *resultData = [self afterGetAllSuccessWithData:backData];
            if (resultData && complete) {
                complete(resultData);
            }
            else if (complete) {
                complete(nil);
            }
            
        } failure:^void(AFHTTPRequestOperation *requestOperation, NSError *error) {
            if (complete) {
                complete(nil);
            }
        }];
    }
    
    //*************************************
}


/**
 *  初始化脑筋急转弯指定分类下首页的数据
 *
 *  @param cate      分类（比如:益智，校园等）
 *  @param pIndex    指定页数，从0开始中,只缓存第一页数据
 *  @param _complete 获取数据完成之后回调函数
 */
-(void)initTrickOfCate:(NSString *)cate reloadFromServer:(BOOL)needReload complete:(void (^)(TrickCateModel *))_complete{
    NSString *urlStr = [NSString stringWithFormat:kCommonUrl,kTrickQuery,kTrickAppId,kTrickAppId,kPageDefaultCount,cate,(long)0];
    
    //对数据进行本地化处理
    //**************************************
    NSString *filePath = [self filePathFromUrl:urlStr];
    BOOL isExists = [self  isFileExists:filePath];
    if ((!needReload)&&isExists) {
        NSData *backData = [NSData  dataWithContentsOfFile:filePath];
        TrickCateModel *backCateModel = [self afterGetTricksAtCateWithData:backData cateName:cate];
        if (backCateModel && _complete) {
            _complete(backCateModel);
        }
        else if (_complete)
        {
            _complete(nil);
        }
    }
    else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^void(AFHTTPRequestOperation * optation, id responseObject) {
            NSData *backData = optation.responseData;
            [backData writeToFile:filePath atomically:YES];
            TrickCateModel *backCateModel = [self afterGetTricksAtCateWithData:backData cateName:cate];
            if (backCateModel && _complete) {
                _complete(backCateModel);
            }
            else if (_complete) {
                _complete(nil);
            }
            
        } failure:^void(AFHTTPRequestOperation *requestOperation, NSError *error) {
            if (_complete) {
                _complete(nil);
            }
        }];
    }
    
    //*************************************
}


/**
 *  获取脑筋急转弯指定分类指定页面下的数据(此方法不做缓存处理)
 *
 *  @param cate      分类
 *  @param pIndex    页码
 *  @param _complete 获取数据回调函数
 */
-(void)requestTrickOfCate:(NSString *)cate pageIndex:(NSInteger)pIndex complete:(void (^)(TrickCateModel *))_complete{
    NSString *urlStr = [NSString stringWithFormat:kCommonUrl,kTrickQuery,kTrickAppId,kTrickAppId,kPageDefaultCount,cate,pIndex*kPageDefaultCount];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^void(AFHTTPRequestOperation * optation, id responseObject) {
        NSData *backData = optation.responseData;
        TrickCateModel *backCateModel = [self afterGetTricksAtCateWithData:backData cateName:cate];
        if (backCateModel && _complete) {
            _complete(backCateModel);
        }
        else if (_complete) {
            _complete(nil);
        }
        
    } failure:^void(AFHTTPRequestOperation *requestOperation, NSError *error) {
        if (_complete) {
            _complete(nil);
        }
    }];
}


/**
 *  解析脑筋急转弯指定分类下数据
 *
 *  @param data      缓存或者服务器数据
 *  @param _cateName 分类名称
 *
 *  @return 数据所对应对象实体
 */
-(TrickCateModel*)afterGetTricksAtCateWithData:(NSData*)data cateName:(NSString*)_cateName{
    NSError *error = nil;
    NSDictionary *backDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    }
    NSArray *rootResultNodeArr =[backDic objectForKey:@"data"];
    NSDictionary *resultNodeDic = rootResultNodeArr.firstObject;
    NSArray *dispDataNodeArr = [resultNodeDic objectForKey:@"disp_data"];
    TrickCateModel *cateModel = [[TrickCateModel alloc]init];
    cateModel.cateName = _cateName;
    for (NSDictionary *tmpDic in dispDataNodeArr) {
        NSString *content = [tmpDic objectForKey:@"content"];
        NSString *answer = [tmpDic objectForKey:@"answer"];
        TrickModel *tm = [[TrickModel alloc]init];
        tm.content = content;
        tm.answer = answer;
        if (!cateModel.trickArray) {
            cateModel.trickArray = [[NSMutableArray alloc]init];
        }
        [cateModel.trickArray addObject:tm];
    }
    return cateModel;
}



/**
 *  解析脑筋急转弯－全部分类下数据以及所有分类
 *
 *  @param data 缓存数据或服务器数据
 *
 *  @return trickcatemodel集合
 */
-(NSArray*)afterGetAllSuccessWithData:(NSData*)data{
    NSError *error = nil;
    NSDictionary *backDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    }
    NSArray *rootResultNodeArr =[backDic objectForKey:@"data"];
    NSDictionary *resultNodeDic = rootResultNodeArr.firstObject;
    NSArray *dispDataNodeArr = [resultNodeDic objectForKey:@"disp_data"];
    
    NSArray *displayTagsNodeArr = [resultNodeDic objectForKey:@"display_tags"];
    NSDictionary *displayTagsNodeDic = displayTagsNodeArr.firstObject;
    NSArray *cateNodeArr = [displayTagsNodeDic objectForKey:@"tag_values"];
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    TrickCateModel *cateOfAll = [[TrickCateModel alloc]init];
    cateOfAll.cateName = NSLocalizedString(@"all", nil);
    [resultArr addObject:cateOfAll];
    for (NSString *tmpStr in cateNodeArr) {
        TrickCateModel *tcm = [[TrickCateModel alloc]init];
        tcm.cateName  = tmpStr;
        [resultArr addObject:tcm];
    }
    
    for (NSDictionary *tmpDic in dispDataNodeArr) {
        NSString *content = [tmpDic objectForKey:@"content"];
        NSString *answer = [tmpDic objectForKey:@"answer"];
        TrickModel *tm = [[TrickModel alloc]init];
        tm.content = content;
        tm.answer = answer;
        if (!cateOfAll.trickArray) {
            cateOfAll.trickArray = [[NSMutableArray alloc]init];
        }
        [cateOfAll.trickArray addObject:tm];
    }
    return resultArr;
}


/**
 *  获取url所对应的本地缓存路径
 *
 *  @param url 请求url
 *
 *  @return 本地路径
 */
-(NSString*)filePathFromUrl:(NSString*)url{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return  [path stringByAppendingPathComponent:url.md5];
}


/**
 *  判断文件文件是否存在
 *
 *  @param filePath 本地文件路径
 *
 *  @return 返回文件是否存在
 */
-(BOOL)isFileExists:(NSString*)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists  =   [fileManager fileExistsAtPath:filePath];
    if (isExists) {
        return YES;
    }
    return NO;
}



@end

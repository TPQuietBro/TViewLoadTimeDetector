//
//  Defines.h
//  TViewLoadTimeDetectDemo
//
//  Created by 唐鹏 on 2018/12/11.
//  Copyright © 2018 唐鹏. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

typedef NS_ENUM(NSInteger,YYViewLoadTimeReportType){
    YYViewLoadTimeReportTypeInit = -1,
    YYViewLoadTimeReportTypeListView,//TabelView // CollectionView
    YYViewLoadTimeReportTypeOtherView,
    YYViewLoadTimeReportTypeWebView
};

#define SAFE_BLOCK(block,...) (block ? block(__VA_ARGS__) : nil)

#endif /* Defines_h */

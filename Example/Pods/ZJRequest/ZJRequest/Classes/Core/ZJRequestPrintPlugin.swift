//
//  ZJRequestPrintPlugin.swift
//  ZJRequest
//
//  Created by Jercan on 2022/10/17.
//

import Moya

public struct ZJRequestPrintPlugin: PluginType {
    
    public init(){}
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        
        print("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")
        print("请求地址：" + "\(target.baseURL)" + "\(target.path)")
        
        //参数
        var parameter = ""
        switch target.task {
        case let .requestParameters(parameters,_):
            parameter = "\(parameters)"
            break
        default:
            break
        }
        
        //请求方法
        switch target.method {
        case .post:
            print("请求类型：POST")
            break
        case .get:
            print("请求类型：GET")
            break
        default:
            break
        }
        
        print("请求参数：" + "\(parameter.count>0 ? parameter : "nil")")
        
        if case let .success(response) = result {
            if response.statusCode == 200 {
                let json = try? JSONSerialization.jsonObject(with: response.data as Data, options: .mutableContainers) as AnyObject
                print("请求成功：")
                print(json ?? "==================数据解析失败======================" )
            }else{
                print("请求失败：错误码：" + "\(response.statusCode)" + "   \(response.data)");
            }
        }
    }
    
}

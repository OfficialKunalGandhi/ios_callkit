//
//  FlutterPluginChannelType.swift
//  ios_callkit
//
//  Created by 須藤将史 on 2020/07/02.
//
import Foundation

enum FlutterPluginChannelType {
    case method
    case event

    var name: String {
        switch self {
        case .method:
            return "ios_callkit"
        case .event:
            return "ios_callkit/event"
        }
    }
}

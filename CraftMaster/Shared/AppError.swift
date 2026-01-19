//
//  AppError.swift
//  CraftMaster
//
//  Created by leo on 18/1/2026.
//

import Foundation

enum AppError: Error, Equatable {
    // 用户可理解/可修复
    case userFacing(UserFacing)

    // 系统错误（磁盘/解码/未知）
    case system(System)

    // 理论不该发生
    case fatal(String)

    enum UserFacing: Equatable {
        case validation(String)        // 输入不合法
        case operationNotAllowed(String)
        case notFound(String)
    }

    enum System: Equatable {
        case io
        case decoding
        case encoding
        case unknown
    }
}

// MARK: - Convenience constructors (keeps call sites/tests concise)
extension AppError {
    static func invalidInput(_ message: String) -> AppError {
        .userFacing(.validation(message))
    }

    static func operationNotAllowed(_ message: String) -> AppError {
        .userFacing(.operationNotAllowed(message))
    }

    static func notFound(_ message: String) -> AppError {
        .userFacing(.notFound(message))
    }

    static var unknown: AppError { .system(.unknown) }
}

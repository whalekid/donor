//
//  AuthViewController.swift
//  Donor
//
//  Created by кит on 20/03/2021.
//  Copyright © 2021 kitaev. All rights reserved.
//
import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case unknownError
    case serverError
    case photoNotExist
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Некорректно введен почтовый адрес", comment: "")
        case .unknownError:
            /// we will use server_error key to display user internal error
            return NSLocalizedString("unknowned error", comment: "")
        case .serverError:
            return NSLocalizedString("server_error", comment: "")
            case .photoNotExist:
            return NSLocalizedString("Пользователь не выбрал фотографию", comment: "")
        }
    }
}

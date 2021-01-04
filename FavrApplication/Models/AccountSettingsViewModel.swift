//
//  AccountSettingsViewModel.swift
//  Favr
//
//  Created by Aniket Gupta on 19/08/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import Foundation

enum AccountSettingsViewModelType {
    case info, logout
}

struct AccountSettingsViewModel {
    let viewModelType: AccountSettingsViewModelType
    let title: String
    let handler: (() -> Void)?
}

//
//  ProfileViewModel.swift
//  Favr
//
//  Created by Aniket Gupta on 27/07/2020.
//  Copyright © 2020 aniketgupta. All rights reserved.
//

import Foundation

enum ProfileViewModelType {
    case info, account, none, tellafriend, contactus, appearance, about, deedsandchats
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}

//
//  RequestType.swift
//  yobro
//
//  Created by atul on 15/01/15.
//  Copyright (c) 2014 Atul Manwar. All rights reserved.
//

import Foundation

enum RequestType: String {
    //User
    case REGISTER = "/user/create"
    case LOGIN = "/user/generateAndSendVerificationCode"
    case ADD_ADDRESS = "/user/addUserAddress"
    case USER_DETAILS = "/user/getUserDetails"

    //General
    case HOME = ""
}

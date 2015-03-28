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
    case VERIFY_SIGNUP = "/user/verifySignup"
    case VERIFY_LOGIN = "/user/verifyLogin"
    case LOGIN = "/user/generateAndSendVerificationCode"
    case ADD_ADDRESS = "/user/addUserAddress"
    case USER_DETAILS = "/user/getUserDetails"
    case GET_ADDRESS = "/user/getUserAddresses"

    //General
    case HOME = "merchant/search"
    case GEOCODE = "http://maps.googleapis.com/maps/api/geocode/json"
    
    //Merchant
//    case MERCHANT = "/merchant/getMerchantByTag"
    case CATALOG = "/merchant/getMerchantCatalog"
    
    //Cart
//    case ADD_TO_CART = "/cart/addItem"
//    case DELETE_FROM_CART = "/cart/subtractItem"
    case CREATE_CART = "/cart/createCart"
    case GET_CART = "/cart/getCart"
    case CLEAR_CART = "/cart/clearCart"
    
    //Order
    case CREATE_ORDER = "/order/createOrder"
    case CANCEL_ORDER = "/order/cancelOrder"
    case GET_ORDER = "/order/getOrderDetails"
    
    func jsonFileName() -> String {
        switch(self) {
        //User
        case .REGISTER: return "register"
        case .VERIFY_SIGNUP: return "verify"
        case .VERIFY_LOGIN: return "verify"
        case .LOGIN: return "login"
        case .ADD_ADDRESS: return "add_address"
        case .USER_DETAILS: return "user_details"
        case .GET_ADDRESS: return "get_address"
            
        //General
        case .HOME: return "search"
        case .GEOCODE: return "geocode"
            
        //Merchant
//        case .MERCHANT: return "merchant"
        case .CATALOG: return "catalog"
            
        //Cart
        case .CREATE_CART: return "create_cart"
        case .GET_CART: return "get_cart"
        case .CLEAR_CART: return "clear_cart"
            
        //Order
        case .CREATE_ORDER: return "create_order"
        
        default: return ""
        }
    }
}

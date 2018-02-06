//
//  Constants.swift
//  Fashion180
//  Copyright © 2016 MobiwareInc. All rights reserved.
//

import Foundation
import UIKit

struct Urls {
    
    
    //static let WardroberInitializerUrl = "http://65.19.149.190/Wardrobes/ServerApi/WardroberestApi.svc/ClientAppLogin"
    
    static let WardroberInitializerUrl = "http://65.19.149.190/Wardrobeportal/ServerApi/WardroberestApi.svc/ClientAppLoginV2"
    
    static let stanleyKorshakUrl = "http://65.19.149.190/Dev.stanleykorshakv1/WardrobePaymentAPI/WardrobeClientPaymentApi.svc"
   
    static let GetModelInfoByAssetSize = "GetModelInfoByAssetSize"
    static let GetProductCategorysInfo = "GetProductCategorysInfo"

    
    static let AccessToken = "Access_Token"
    static let AccessTokenValue = "FZBHMEoKFA1xNS6EkJ"
    
    static let mainUrl = "http://65.19.149.190/FasHumanFaceonly/Fasrestapi.svc"
    ////static let mainUrl = "http://65.19.149.190/FasFullHuman/Fasrestapi.svc"
    ////static let mainUrl = "http://65.19.149.190/FasApi/Fasrestapi.svc"
    ////static let mainUrl = "http://65.19.149.190/FasApiStaging/Fasrestapi.svc"
    static let UserRegistration = "/UserRegistration"
    static let CustomerLoginVerify = "/CustomerLoginVerify"
    static let UserForgotPassword = "/UserForgotPassword"
    static let UserResetPassword = "/UserResetPassword"
    static let GetItemSizesByProductID = "/GetItemSizesByProductID"

    static let GetProductCatalog = "GetProductCatalog"
    static let GetProductCatalogV2 = "GetProductCatalogueInfo"
    
    
    static let GetEarByProductTopId = "GetEarByProductTopId"
    static let GetJacketByProductTopId = "GetJacketByProductTopId"
    static let GetBottomsByProductTopId = "GetBottomsByProductTopId"
    static let GetShooeByProductTopId = "GetShooeByProductTopId"

    static let GetTopsByProductId = "GetTopsbyProductItem"
    
    
    static let GetWardobDetails = "GetWardobDetails"
    static let AddWardrobeinfo = "AddWardrobeinfo"
    
    static let GetWardobTopsDetails = "GetWardobTopsDetails"
    static let GetWardobEarRingsDetails = "GetWardobEarRingsDetails"
    static let GetWardobJacketsDetails = "GetWardobJacketsDetails"
    static let GetWardobBottomsDetails = "GetWardobBottomsDetails"
    static let GetWardobShoesDetails = "GetWardobShoesDetails"
}

struct Constants{
    
    static func getDoneToolbar(dismissBtn: UIBarButtonItem) -> UIToolbar
    {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = dismissBtn
        doneToolbar.setItems([spaceButton, doneButton], animated: false)
        doneToolbar.isUserInteractionEnabled = true
        return doneToolbar
    }
    
    static let kSlideMenuAppearedNotification = "SlideMenuAppearedNotification"
    static let kSlideMenuDisappearedNotification = "SlideMenuDisappearedNotification"

    static let kCheckOutBtnTappedNotif = "CheckOutTappedNotif"
    static let kItemsPresentInCartNotification = "CartItemAddedNotification"
    
    static let kUserSuccessfullySignedIn = "userSignInSuccessfull"
    static let kSignedInUserID = "signedInUserID"
    static let kFirstLaunch = "firstLaunch"
    
    static let kUserIdentifier = "WardroberUserIdentifier"
    static let kUserNotSignedIn = "UserNotSignedIn"
    static let kUserNotSignedInFromItemDetailVC = "UserNotSignedInFromItemDetailVC"

    
    static let kAddedToWardrobeNotification = "addedToWardrobe"
    static let kRemovedFromWardrobeNotification = "removedFromWardrobe"

    static let kWardrobeModificationSuccessNotification = "wardrobeModifiedSuccessNotification"
    static let kWardrobeModificationFailedNotification = "wardrobeModifiedFailedNotification"

    
    static let kUserSuccessfullySignedInNotif = "UserSuccessfullySignedInNotif"
    static let kUserSuccessfullySignedOutNotif = "UserSuccessfullySignedOutNotif"

    
    static let kWardroberInitialisedNotification = "WardroberInitialisedNotification"
    static let kWardroberInitialisedFailNotification = "WardroberInitialisedFailedNotification"
    static let kCategoriesFetchedNotification = "CategoriesFetchedNotification"
    
    //static let kAddressSelected = "UserAddressSelectedNotification"

    static let kAddressSelectedSuccessNotification = "AddressSelectedSuccessNotification"

    
    static let dotUnselectedColor = UIColor(red: CGFloat(150)/CGFloat(255), green: CGFloat(150)/CGFloat(255), blue: CGFloat(150)/CGFloat(255), alpha: 1)
    
    static let dotSelectedColor = UIColor(red: CGFloat(89)/CGFloat(255), green: CGFloat(150)/CGFloat(255), blue: CGFloat(220)/CGFloat(255), alpha: 1)
    
    static let GeneralSelectedColor = UIColor(red: CGFloat(89)/CGFloat(255), green: CGFloat(150)/CGFloat(255), blue: CGFloat(220)/CGFloat(255), alpha: 1)
    
    static let GeneralUnselectedColor = UIColor.black
    
    static let productBlackColor = UIColor.black
    static let productWhiteColor = UIColor.white
    static let productNoAvailableColor = UIColor.lightGray
    
    
    static let wardrobeButtonSelectedColor = UIColor(red: CGFloat(29)/255, green: CGFloat(29)/255, blue: CGFloat(29)/255, alpha: 1)
    
    
    static let shareMessageWardrober = "Check out this outfit from my Wardrobers app!"
    
    static let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
}



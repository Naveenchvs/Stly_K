//
//  SignInDelegate.swift
//  Fashion180
//
//  Created by Yogi on 24/10/16.
//  Copyright © 2016 Mobiware. All rights reserved.
//


protocol SignInDelegate
{
    //func signInControllerDidLogin(_ signInVC : SignInController)
    
    func signInControllerDidLogin(_ signInVC : SignInController)
    
    func signUpControllerDidRegisterSuccessfully(_ signUpVC : SignUpController)
    
    func signInControllerDidCancelLogin(_ signInVC : SignInController)
}

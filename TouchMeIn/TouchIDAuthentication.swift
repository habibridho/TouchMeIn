//
//  TouchIDAuthentication.swift
//  TouchMeIn
//
//  Created by Habib Ridho on 9/18/17.
//  Copyright © 2017 iT Guy Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchIDAuth {
  let context = LAContext()
  
  func canEvaluatePolice() -> Bool {
    return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
  }
  
  func authenticateUser(completion: @escaping (String?) -> Void) {
    guard canEvaluatePolice() else {
      completion("Touch ID is not avalaible on this device")
      return
    }
    
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch ID") {
      (success, evaluateError) in
      if success {
        DispatchQueue.main.async {
          completion(nil)
        }
      } else {
        let message: String
        switch evaluateError {
        case LAError.authenticationFailed?:
          message = "There was a problem verifying your indentity"
        case LAError.userCancel?:
          message = "Touch ID canceled"
        case LAError.userFallback?:
          message = "Password Pressed"
        default:
          message = "Touch ID may not be configured"
        }
        DispatchQueue.main.async {
          completion(message)
        }
      }
    }
  }
}

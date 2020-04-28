/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Login view controller.
*/

import UIKit
import LocalAuthentication

class FaceDetection: NSObject, RCTBridgeModule {

  static func moduleName() -> String! {
    return "FaceDetection"
  }

  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  /// An authentication context stored at class scope so it's available for use during UI updates.
  var context = LAContext()

  /// The available states of being logged in or not.
  enum AuthenticationState {
    case loggedin, loggedout
  }

  // /// The current authentication state.
  var state = AuthenticationState.loggedout

  override func viewDidLoad() {
    super.viewDidLoad()

    // The biometryType, which affects this app's UI when state changes, is only meaningful
    //  after running canEvaluatePolicy. But make sure not to run this test from inside a
    //  policy evaluation callback (for example, don't put next line in the state's didSet
    //  method, which is triggered as a result of the state change made in the callback),
    //  because that might result in deadlock.
    context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)

    // Set the initial app state. This impacts the initial state of the UI as well.
    state = .loggedout
  }

  @objc(checkPermissions:)
  func checkPermissions() {
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
      if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
        return "success"
      } else {
        return "unsupported"
      }
    } else {
      return "permission_denied"
    }
  }

  @objc(isLogged:)
  func isLogged() {
    return state == .loggedin
  }

  /// Logs out or attempts to log in when the user taps the button.
  @objc(login:)
  func login() {
    context = LAContext()

    context.localizedCancelTitle = "Enter Username/Password"

    // First check if we have the needed hardware support.
    var error: NSError?
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
      let reason = "Log in to your account"
      context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
        if success {
          // Move to the main thread because a state update triggers UI changes.
          DispatchQueue.main.async { [unowned self] in
            self.state = .loggedin
          }
          return "success"
        } else {
          return "authentication_failed"
        }
      }
    } else {
      return "unsupported"
    }
  }
}

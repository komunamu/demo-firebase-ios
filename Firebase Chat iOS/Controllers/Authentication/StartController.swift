//
//  StartController.swift
//  Firebase Chat iOS
//
//  Created by Eugen Pivovarov on 6/19/18.
//  Copyright © 2018 Virgil Security. All rights reserved.
//

import UIKit
import PKHUD
import Firebase

class StartViewController: ViewController {
    static let name = "Start"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()

        if let user = Auth.auth().currentUser,
            let id = user.email?.replacingOccurrences(of: "@virgilfirebase.com", with: "") {

                user.getIDToken { token, error in
                    guard error == nil, let token = token else {
                        Log.error("Get ID Token with error: \(error?.localizedDescription ?? "unknown error")")
                        self.alert(error?.localizedDescription ?? "Something went wrong")
                        return
                    }
                    VirgilHelper.sharedInstance.signIn(with: id, token: token) { error in
                        guard error == nil else {
                            Log.error("Virgil sign up failed with error: \(error!.localizedDescription)")
                            self.alert(error!.localizedDescription)
                            return
                        }
                        self.goToChatList()
                    }
                }
        } else {
            self.goToLogin()
        }
    }

    private func goToChatList() {
        DispatchQueue.main.async {
            PKHUD.sharedHUD.hide(true) { _ in
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! UINavigationController

                self.switchNavigationStack(to: vc)
            }
        }
    }

    private func goToLogin() {
        DispatchQueue.main.async {
            PKHUD.sharedHUD.hide(true) { _ in
                let vc = UIStoryboard(name: "Authentication", bundle: Bundle.main).instantiateInitialViewController() as! UINavigationController

                self.switchNavigationStack(to: vc)
            }
        }
    }
}

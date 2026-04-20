//
//  Extenstion+Application.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import Foundation
import UIKit

extension UIApplication {
    func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
        .first) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

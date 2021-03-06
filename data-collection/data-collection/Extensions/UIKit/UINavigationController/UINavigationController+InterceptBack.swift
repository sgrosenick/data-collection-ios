//// Copyright 2018 Esri
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import UIKit

/// Objects that adhere to this protocol offer the ability to intercept the `UINavigationBarDelegate`
/// method `public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool`
/// and thus can conditionally stop the UINavigationController from popping, should certain
/// requirements not yet be met.
///
/// - SeeAlso: `UINavigationBarDelegate`, `UINavigationController`

public protocol BackButtonDelegate {
    func interceptNavigationBackActionShouldPopViewController() -> Bool
}

extension UINavigationController: UINavigationBarDelegate  {
    
    // This method should never be called directly.

    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        
        var shouldPop = true
        
        if let vc = self.topViewController as? BackButtonDelegate {
            shouldPop = vc.interceptNavigationBackActionShouldPopViewController()
        }
        
        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        }
        else {
            UIView.animate(withDuration: 0.25, animations: {
                for subView in navigationBar.subviews {
                    if(0 < subView.alpha && subView.alpha < 1) {
                        subView.alpha = 1
                    }
                }
            })
        }
        
        return false
    }
}



import UIKit

extension UITextField {
    func setPlaceholderText (placeholder: String, color: UIColor? = UIColor.black, size: CGFloat? = 10.0) {
        let attributes: [String : Any] = [
            NSForegroundColorAttributeName: color ?? .black,
            NSFontAttributeName: UIFont(name: "Avenir", size: size ?? 10.0)!]
        self.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:attributes)
    }
}



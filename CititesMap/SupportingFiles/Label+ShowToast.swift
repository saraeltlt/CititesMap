import UIKit

extension UILabel {
    func showToast(message: String, duration: TimeInterval = 3.0, multiline: Bool = false, image: UIImage? = nil) {
        self.text = message
        self.alpha = 1.0
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.textAlignment = .center
        self.textColor = .white
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.numberOfLines = multiline ? 0 : 1
        self.font = Constants.Dimentions.font
        
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 10, y: 10, width: 48, height: 48)
            self.addSubview(imageView)
        }
        
        if let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) {
            window.addSubview(self)
            
            let windowWidth = window.frame.size.width
            let windowHeight = window.frame.size.height
            
            let labelWidth = windowWidth - 16
            let labelHeight = self.intrinsicContentSize.height + 20
            
            self.frame = CGRect(x: 8, y: windowHeight - labelHeight - 50, width: labelWidth, height: labelHeight)
            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}


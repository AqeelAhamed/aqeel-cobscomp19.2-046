import Foundation
import UIKit
import AlamofireImage

extension UIViewController {
    func resetWindow(with vc: UIViewController?) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("could not get scene delegate ")
        }
        sceneDelegate.window?.rootViewController = vc
    }
    
    func showViewController(with id: String) {
        let vc = storyboard?.instantiateViewController(identifier: id)
        resetWindow(with: vc)
    }
    
}

public extension String {
    
    func trimLeadingTralingNewlineWhiteSpaces() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension UIImage
{
    func scaleAndCrop(withAspect: Bool, to: Int) -> UIImage?
    {
        // Scale down the image to avoid wasting unnnecesary storage and network capacity
        let size = CGSize(width: to, height: to)
        let scale = max(size.width/self.size.width, size.height/self.size.height)
        let width = self.size.width * scale
        let height = self.size.height * scale
        let x = (size.width - width) / CGFloat(2)
        let y = (size.height - height) / CGFloat(2)
        let scaledRect = CGRect(x: x, y: y, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: scaledRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

extension Date {
    
    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
        }
    }
    
}

extension UIImageView {
    func loadImageUrl(_ urlString: String, placeholderImage: UIImage = UIImage()) {
        if let url = URL(string: urlString) {
            self.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
    }
}

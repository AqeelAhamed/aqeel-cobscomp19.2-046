import Foundation
import UIKit

typealias ActionHandler = (_ status: Bool, _ message: String) -> ()
typealias CompletionHandler = (_ status: Bool, _ code: Int, _ message: String) -> ()
typealias CompletionHandlerWithData = (_ status: Bool, _ code: Int, _ message: String, _ data: Any?) -> ()
typealias FileDownloadHandler = (_ status: Bool, _ message: String, _ url: String?) -> ()
typealias FileViewerHandler = (_ path: URL?, _ thumbnail: UIImage?) -> ()

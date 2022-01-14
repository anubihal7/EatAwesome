//
//  ActionSheetContentViewController.swift
//  Fleet Management


import UIKit

extension UIAlertAction{
    var mode : ActionSheetContentViewController.Mode?{
        set{
            let vc = ActionSheetContentViewController.viewController(with: newValue)
            self.setValue(vc, forKey: "contentViewController")
        }
        get{
            if let vc = value(forKey: "contentViewController") as? ActionSheetContentViewController{
                return vc.mode
            }

            return nil
        }
    }
}

class ActionSheetContentViewController: UIViewController
{
    
    enum Mode{
        case gallery
        case camera
        case documents

        var image : UIImage{
            get{
                switch self {
                case .gallery: return #imageLiteral(resourceName: "camera")
                case .camera: return #imageLiteral(resourceName: "camera")
                case .documents: return #imageLiteral(resourceName: "camera")
                }
            }
        }

        var title : String{
            get{
                switch self {
                case .gallery: return NSLocalizedString("Photo Library", comment: "Photo Library")
                case .camera: return NSLocalizedString("Camera", comment: "Camera")
                case .documents:
                     return NSLocalizedString("Document", comment: "Document")
                }
            }
        }
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imaegView: UIImageView!

    var mode : Mode?

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = mode?.title
//        let origImage = UIImage(named: "camera")
//        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
//        btn.setImage(tintedImage, for: .normal)
//        btn.tintColor = .red
        imaegView.image = mode?.image
        imaegView.tintColor = .blue
    }

    class func viewController(with mode : Mode?) -> UIViewController{

        let storyboard = UIStoryboard(name: "Chat", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActionSheetContentViewController") as! ActionSheetContentViewController

        vc.mode = mode

        return vc

    }
}

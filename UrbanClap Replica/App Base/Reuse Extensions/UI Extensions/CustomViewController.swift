//
//  CustomViewController.swift
//  GoodsDelivery
//
//  Created by Rakesh Kumar on 12/6/19.
//  Copyright © 2019 UnionGoods. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation
import Photos
import MobileCoreServices
import NVActivityIndicatorView
import CoreLocation
import GoogleMaps
import GooglePlaces

//MARK:- UI Picker Delegate

protocol UIPickerDelegate{
    func didSelectPicker(index : Int)
    func GetTitleForRow(index:Int) -> String
    func SelectedRow(index:Int)
}

//MARK:- UIImage Picker Delegate
protocol UIImagePickerDelegate
{
    func SelectedMedia(image:UIImage?,imageURL:URL?,videoURL:URL? )
    func selectedImageUrl(url: URL)
    func cancelSelectionOfImg()
}


extension CustomController:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

class CustomController: UIViewController,UINavigationControllerDelegate
{
    private var pickerView = UIPickerView()
    var txtFldForPicker:UITextField?
    var delegate:UIPickerDelegate?
    private var pickerCount:Int?
    var imageURL:URL?
    
    private var imagePicker = UIImagePickerController()
    private var imagePickerDelegate:UIImagePickerDelegate?
    
    override func viewDidLoad()
    {
        addShadowNavColor()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    
    //MARK:-Tap gesture for swrevealcontroller
    func setTapGestureOnSWRevealontroller(view: UIView,controller: UIViewController)
    {
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: self.view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)
        let revealController: SWRevealViewController? = revealViewController()
        let tap: UITapGestureRecognizer? = revealController?.tapGestureRecognizer()
        tap?.delegate = controller as? UIGestureRecognizerDelegate
        self.revealViewController().panGestureRecognizer().isEnabled = false
        self.revealViewController().tapGestureRecognizer().isEnabled = true
        view.addGestureRecognizer(tap!)
        
    }
    
    func BackButton() {
            let myBackButton:UIButton = UIButton()
                    myBackButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
           myBackButton.setImage(UIImage(named:"btn_back_black"), for: UIControl.State())
           myBackButton.addTarget(self, action:  #selector(self.Pop_ToRootViewController), for: UIControl.Event.touchUpInside)
                    let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
                    self.navigationItem.leftBarButtonItem = leftBackBarButton
       }

    @objc func Pop_ToRootViewController()
      {
       DispatchQueue.main.async {
        self.navigationController?.dismiss(animated: true, completion: nil)
       }
      
      }
       
    
    func addShadowNavColor()
    {
        
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
//        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
//        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
//        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 0.0
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
//        self.navigationController?.navigationBar.layer.masksToBounds = true
       // UINavigationBar.appearance().isTranslucent = true
        
    }
    
    func addShadowToTextField(textField:UITextField) {

               textField.layer.borderColor = UIColor.black.cgColor
               textField.borderStyle = UITextField.BorderStyle.none
               textField.layer.masksToBounds = false
               textField.layer.cornerRadius = 7.0;
               textField.layer.backgroundColor = UIColor.white.cgColor
              textField.layer.borderColor = UIColor.clear.cgColor
               textField.layer.shadowColor = UIColor.black.cgColor
               textField.layer.shadowOffset = CGSize(width: 0, height: 0)
               textField.layer.shadowOpacity = 0.15
               textField.layer.shadowRadius = 4.0

        
    }
    
    func txtfieldPadding(textField : UITextField){
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 45))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
    }
    
    func  CornerRadius(radius:Int,view:UIView )
    {
        view.layer.cornerRadius = CGFloat(radius)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
    }
    
    func UIPickerDataSurce(txtFld: UITextField, delegate : UIPickerDelegate,count:Int)
    {
        self.delegate = delegate
        txtFldForPicker = txtFld
        pickerCount = count
        AddPicker()
    }
    
    
    //MARK:-OpenGallery and Camera
    func OpenGalleryCamera(camera:Bool,imagePickerDelegate:UIImagePickerDelegate,isVideoAlso:Bool)
    {
        self.imagePickerDelegate = imagePickerDelegate
        let alert = UIAlertController(title: KChooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: KCamera, style: .default, handler: { _ in
            self.OpenCamera(imagePickerDelegate: imagePickerDelegate, isVideoAlso: isVideoAlso)
        }
        ))
        alert.addAction(UIAlertAction(title: KGallery, style: .default, handler: { _ in
            self.OpenGallary(imagePickerDelegate: imagePickerDelegate, isVideoAlso: isVideoAlso)
        }))
        alert.addAction(UIAlertAction.init(title: KCancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func OpenCamera(imagePickerDelegate:UIImagePickerDelegate, isVideoAlso:Bool)
    {
        self.imagePickerDelegate = imagePickerDelegate
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //  Open Camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
               
                if(isVideoAlso)
                {
                    //self.imagePicker.mediaTypes = [kUTTypeMovie as String,kUTTypeImage as String ]
                    self.imagePicker.mediaTypes = [kUTTypeImage as String ]
                }
                else
                {
                    self.imagePicker.mediaTypes = [kUTTypeImage as String ]
                }
                // self.imagePicker.mediaTypes = [kUTTypeImage as String]
                self.imagePicker.navigationController?.navigationBar.tintColor = kpurpleTheme
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                self.showAlertMessage(titleStr: kAppName, messageStr: KYoudonthavecamera)
            }
            
        } else
        {
            // Open setting alert for camera
            let alert = UIAlertController(title: KOpenSettingForCamera , message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: KCancel, style: .default))
            alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            self.present(alert, animated: true)
            ////////
        }
    }
    func OpenGallary(imagePickerDelegate:UIImagePickerDelegate, isVideoAlso:Bool)
    {
        self.imagePickerDelegate = imagePickerDelegate
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Open Gallary
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                if(isVideoAlso)
                {
                    // self.imagePicker.mediaTypes = [kUTTypeMovie as String,kUTTypeImage as String ]
                    self.imagePicker.mediaTypes = [kUTTypeImage as String ]
                    
                }
                else
                {
                    self.imagePicker.mediaTypes = [kUTTypeImage as String ]
                }
                self.imagePicker.allowsEditing = true
                self.imagePicker.navigationController?.navigationBar.tintColor = kpurpleTheme
                self.present(self.imagePicker, animated: true, completion: nil)
                /////////
            }
        case .denied, .restricted:
            // Open setting Alert for galllary
            // Open setting alert for camera
            let alert = UIAlertController(title: KOpenSettingForPhotos , message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: KCancel, style: .default))
            alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            self.present(alert, animated: true)
        //////////
        case .notDetermined:
            break
        @unknown default:
            break
        }
        
    }
    
    func OpenGallaryCameraForVideo(imagePickerDelegate:UIImagePickerDelegate)
    {
        self.imagePickerDelegate = imagePickerDelegate
        let alert = UIAlertController(title: KChooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: KCamera, style: .default, handler: { _ in
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //  Open Camera
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    // pickerController.allowsEditing = true
                    self.imagePicker.videoMaximumDuration = 30
                    self.imagePicker.videoQuality = UIImagePickerController.QualityType.typeMedium
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                    //   UIImagePickerController.availableMediaTypes(for:.camera)!;
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage(titleStr: kAppName, messageStr: KYoudonthavecamera)
                }
                //////////
            } else
            {
                // Open setting alert for camera
                let alert = UIAlertController(title: KOpenSettingForCamera , message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: KCancel, style: .default))
                alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                self.present(alert, animated: true)
                ////////
            }
        }))
        alert.addAction(UIAlertAction(title: KGallery, style: .default, handler: { _ in
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                // Open Gallary
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.imagePicker.allowsEditing = true
                    self.imagePicker.videoMaximumDuration = 30
                    self.imagePicker.videoQuality = UIImagePickerController.QualityType.typeMedium
                    //pickerController.allowsEditing = true
                    self.imagePicker.mediaTypes = [kUTTypeMovie as String]
                    //   UIImagePickerController.availableMediaTypes(for:.camera)!;
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            case .denied, .restricted:
                // Open setting Alert for galllary
                // Open setting alert for camera
                let alert = UIAlertController(title: KOpenSettingForPhotos , message: "", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: KCancel, style: .default))
                alert.addAction(UIAlertAction(title: KSettings, style: .cancel) { (alert) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                self.present(alert, animated: true)
            //////////
            case .notDetermined:
                break
            @unknown default: break
               
            }
        }))
        alert.addAction(UIAlertAction.init(title: KCancel, style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func DonePicker()
    {
        let row = pickerView.selectedRow(inComponent: 0)
        delegate?.didSelectPicker(index: row)
        
        txtFldForPicker?.resignFirstResponder()
    }
    @objc func CancelPicker()
    {
        txtFldForPicker?.resignFirstResponder()
    }
    
    
    func getAddressFrom_LatLong(lat:String,long:String, completion: @escaping (_ result: NSString) -> Void)
    {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(lat)") ?? 0.0
            //21.228124
            let lon: Double = Double("\(long)") ?? 0.0
            //72.833770
            center.latitude = lat
            center.longitude = lon
            
            let geoCoder = GMSGeocoder()
            geoCoder.reverseGeocodeCoordinate(center) { (response, error) in
                if error != nil
                {
                    print(error!.localizedDescription)
                    completion("Mohali, Punjab")
                    return
                }
                
                if let address = response?.firstResult()
                {
                    var string = ""
                    let array: [String?] = [address.thoroughfare, address.locality, address.subLocality, address.administrativeArea, address.postalCode, address.country]
                    let haveValue: [Int] = [(address.thoroughfare != "" && address.thoroughfare != nil) ? 0 : -1, (address.locality != "" && address.locality != nil) ? 1 : -1, (address.subLocality != "" && address.subLocality != nil) ? 2 : -1, (address.administrativeArea != "" && address.administrativeArea != nil) ? 3 : -1, (address.postalCode != "" && address.postalCode != nil) ? 4 : -1, (address.country != "" && address.country != nil) ? 5 : -1]
                    var isFirstValue = true
                    for value in haveValue
                    {
                        if value >= 0
                        {
                            if isFirstValue
                            {
                                string += array[value]!
                                isFirstValue = false
                            }
                            else
                            {
                                string += ", " + array[value]!
                            }
                        }
                    }
                    
                    completion(string as NSString)
                }
                
            }
    }
}

//MARK: UIPickerViewDataSource,UIPickerViewDelegate
extension CustomController:UIPickerViewDataSource,UIPickerViewDelegate
{
    func AddPicker()
    {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        txtFldForPicker!.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 3/255, green: 95/255, blue: 253/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: KDone, style: UIBarButtonItem.Style.plain, target: self, action: #selector(DonePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: KCancel, style: UIBarButtonItem.Style.plain, target: self, action: #selector(CancelPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtFldForPicker!.inputAccessoryView = toolBar
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerCount ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.delegate?.GetTitleForRow(index: row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        self.delegate?.SelectedRow(index: row)
    }
}
extension CustomController:UIImagePickerControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.imagePickerDelegate?.cancelSelectionOfImg()
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        var isImage:Bool = false
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {return}
        print(mediaType)
        switch mediaType{
        case "public.image":
            isImage = true;
            break;
        case "public.video":
            isImage = false;
            break;
        default:
            break;
        }
        if(isImage == true){
            
            var pickedImage : UIImage!

               if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
               {
                   pickedImage = img

               }
               else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
               {
                   pickedImage = img
               }

                if #available(iOS 11.0, *) {
                    if pickedImage != nil {
                        
                        //   pickedImage =  pickedImage.fixedOrientation()!
                        
                        var urlImage:URL?
                        guard let chosenImagee = pickedImage else {
                            fatalError("\(info)")
                        }
                        let chosenImage =  chosenImagee.fixedOrientation()!
                        
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // choose a name for your image
                        let fileName = "\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                        // create the destination file url to save your image
                        let fileURL = documentsDirectory.appendingPathComponent(fileName)
                        
                        if let data = chosenImage.jpegData(compressionQuality: 1.0),
                            !FileManager.default.fileExists(atPath: fileURL.path) {
                            do {
                                // writes the image data to disk
                                try data.write(to: fileURL)
                                
                                let url = fileURL
                                urlImage = url
                                
                            } catch {
                                
                            }
                        }
                        if let url = urlImage{
                            imageURL = url
                            imagePickerDelegate?.selectedImageUrl(url: url)
                        }
                    }
                    dismiss(animated: true, completion: nil)
                    
                } else {
                    //                  Fallback on earlier versions
                    var urlImage:URL?
                    guard let chosenImage = pickedImage else {
                        fatalError("\(info)")
                    }
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    // choose a name for your image
                    let fileName = "\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                    // create the destination file url to save your image
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    
                    if let data = chosenImage.jpegData(compressionQuality: 1.0),
                        !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            // writes the image data to disk
                            try data.write(to: fileURL)
                            let url = fileURL
                            urlImage = url
                        } catch {
                            //       CommonFunctions.sharedmanagerCommon.println(object: "Exception while writing the url image")
                        }
                    }
                    if let url = urlImage{
                        imageURL = url
                        imagePickerDelegate?.selectedImageUrl(url: url)
                    }
                }
                print(imageURL!)
                imagePickerDelegate?.SelectedMedia(image: pickedImage, imageURL: imageURL, videoURL: nil)
            
            dismiss(animated: true, completion: nil)
        }
        else{
            guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {return}
            
            do {
                let asset = AVURLAsset(url: videoURL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                imagePickerDelegate?.SelectedMedia(image: thumbnail,imageURL:nil,videoURL:videoURL )
            } catch  {
                //     CommonFunctions.sharedmanagerCommon.println(object: "*** Error generating thumbnail: \(error.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // When showing the ImagePicker update the status bar and nav bar properties.
        //UIApplication.shared.setStatusBarHidden(false, with: .none)
        //164 13 28
        navigationController.topViewController?.title = "Select photo iSMS"
        navigationController.navigationBar.isTranslucent = false
        
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController.navigationBar.barStyle = .default
        navigationController.setNavigationBarHidden(false, animated: animated)
    }
}




extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        @unknown default: break
            
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default: break
            
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}

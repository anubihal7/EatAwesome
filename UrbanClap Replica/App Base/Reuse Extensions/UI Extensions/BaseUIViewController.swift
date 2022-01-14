//
//  BaseUIViewController.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: Global Interface
protocol ViewDelegate:class
{

}
//MARK:- UIPicker Delegate
@objc protocol SharedUIPickerDelegate:class{
    func DoneBtnClicked()
    func GetTitleForRow(index:Int) -> String
    func SelectedRow(index:Int)
    @objc optional func cancelButtonClicked()
}

//MARK:- UIDate Picker Delegate
@objc protocol SharedUIDatePickerDelegate:class{
    func doneButtonClicked(datePicker: UIDatePicker)
    @objc optional func cancelButtonClicked()
}
//MARK:- Navigation SerachBar Delegates
protocol NavigationSearchBarDelegate:class {
    func textDidChange(searchBar: UISearchBar,searchText: String)
    func cancelButtonPress(uiSearchBar:UISearchBar)
}


extension BaseUIViewController:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

//MARK: BaseUIViewController
class BaseUIViewController: UIViewController,UINavigationControllerDelegate
{
    //MARK:- Variables
    private var pickerDelegate:SharedUIPickerDelegate?
    private var datePickerDelegate:SharedUIDatePickerDelegate?
    private var imagePickerDelegate:UIImagePickerDelegate?
    private var navigationSearchBarDelegate:NavigationSearchBarDelegate?
    private var navigationTitle:String?
    private var datePickerView:UIDatePicker!
    private var searchBar = UISearchBar()
    private var viewDatePickerView:UIView!
    private var pickerView:UIPickerView!
    private var pickerCount:Int?
    private var view_pickerView:UIView!
    private var imagePicker = UIImagePickerController()
    var imageURL:URL?
    
    var pickerType : UIDatePicker.Mode?
    var visualBlurView = UIVisualEffectView()
       override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func viewEndEditing(view: UIView){
        self.view.endEditing(true)
    }
    
    //For Set the status bar content white
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        //MARK:- SetPickerView
    func SetpickerView(_ view : UIView) {
        //UIView
        self.view_pickerView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: UIScreen.main.bounds.width, height: 244))
        // UIPickerView
        self.pickerView = UIPickerView()
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 44, width: view_pickerView.frame.size.width, height: 244))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        
        // ToolBar
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnClick(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnClick(sender:)))
    
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        self.view_pickerView.addSubview(toolBar)
        self.view_pickerView.addSubview(pickerView)
        view.addSubview(self.view_pickerView)
        self.view_pickerView.isHidden = true
    }

    //PickerButton Action
    @objc func doneBtnClick(sender: Any){
        
        self.pickerDelegate?.DoneBtnClicked()
        self.view_pickerView.isHidden = true
        self.removeBlurEffect()
    }
    
    @objc func cancelBtnClick(sender: Any){
         self.view_pickerView.isHidden = true
         self.removeBlurEffect()
         pickerDelegate?.cancelButtonClicked?()
    }
    
    //updatePicker
    func UpdatePickerModel(count:Int,sharedPickerDelegate:SharedUIPickerDelegate, View: UIView){
        view.endEditing(true)
         createBlurEffectView()
        if viewDatePickerView != nil {
        self.viewDatePickerView.isHidden = true
        }
        self.view_pickerView.isHidden = false
        //gurleen
        //Commented below line
        self.pickerView.selectRow(0, inComponent:0, animated:true)
        self.pickerDelegate = sharedPickerDelegate
        self.pickerCount = count
        self.pickerView?.reloadAllComponents()
//        self.pickerView
       
        View.insertSubview(view_pickerView, aboveSubview: visualBlurView)
     //View.bringSubviewToFront(pickerView)

    }
    func UpdatePickerModel2(count:Int,sharedPickerDelegate:SharedUIPickerDelegate, View: UIView){
        view.endEditing(true)
        createBlurEffectView()
        if viewDatePickerView != nil {
            self.viewDatePickerView.isHidden = true
        }
        self.view_pickerView.isHidden = false
        //gurleen
        //Commented below line
       // self.pickerView.selectRow(0, inComponent:0, animated:true)
        
        self.pickerDelegate = sharedPickerDelegate
        self.pickerCount = count
        self.pickerView?.reloadAllComponents()
        View.insertSubview(view_pickerView, aboveSubview: visualBlurView)
        
        //View.bringSubviewToFront(pickerView)
    }
    
    func showPickerView(selectedComponent: Int) {
       createBlurEffectView()
        if viewDatePickerView != nil {
            self.viewDatePickerView.isHidden = true
        }
        self.view_pickerView.isHidden = false
        self.pickerView.selectRow(selectedComponent, inComponent:0, animated:true)
    }
    //MARK:- Set UIDatePicker
    func setDatePickerView(_ view: UIView,type: UIDatePicker.Mode){
        view.endEditing(true)
        //UIView for date picker view
        self.viewDatePickerView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 244, width: view.frame.size.width, height: 244))
        // UIDatePickerView
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 44, width: viewDatePickerView.frame.size.width, height: 200))
        self.datePickerView.backgroundColor = UIColor.white
        pickerType = type
        if (type == .time){
            self.datePickerView.datePickerMode = .time
        }else{
            self.datePickerView.datePickerMode = .date
            self.datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        }
        // ToolBar for done and cancel
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: datePickerView.frame.width, height: 44))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.clickOnDoneBtn(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.clickOnCancelButton(sender:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        self.viewDatePickerView.addSubview(toolBar)
        self.viewDatePickerView.addSubview(datePickerView)
        view.addSubview(self.viewDatePickerView)
        self.viewDatePickerView.isHidden = true
       
    }
    
    //Show Date Picker for DOB
 
    func showDatePicker(datePickerDelegate: SharedUIDatePickerDelegate){
        view.endEditing(true)

        createBlurEffectView()

        self.datePickerDelegate = datePickerDelegate
        if(pickerType == .date){
            self.datePickerView.setDate(Date(), animated: true)
        }else{
            self.datePickerView.setDate(Date(), animated: true)
        }
        self.viewDatePickerView.isHidden = false
        self.view.insertSubview(viewDatePickerView, aboveSubview: visualBlurView)
    }
    //Click on done button for uidatepicker
    @objc func clickOnDoneBtn(sender: Any){
        self.viewDatePickerView.isHidden = true
        datePickerDelegate?.doneButtonClicked(datePicker: datePickerView)
        removeBlurEffect()
    }
 
    //Click on cancel button for uidatepicker
    @objc func clickOnCancelButton(sender: Any){
        self.viewDatePickerView.isHidden = true
        removeBlurEffect()
    }
    
   
    //Connect text Fields
    func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    
    //Blur Effect View
    func createBlurEffectView(_ view: UIView){
        
    }
    
    
    
    
    //MARK:- Hide Back Button In Navigation Controller
    func hideNavigationBackButton(){
        navigationController?.navigationItem.setHidesBackButton(true, animated:true)
        navigationItem.hidesBackButton = true
    }
    
    //Mark:- Create Search Bar in Navigation
    func setSearchBarInNavigationController(placeholderText: String,navigationTitle: String,navigationController: UINavigationController?,navigationSearchBarDelegates: NavigationSearchBarDelegate){
        self.searchBar.sizeToFit()
        self.searchBar.layoutIfNeeded()
        self.searchBar.returnKeyType = .done
        self.searchBar.delegate = self
        self.searchBar.isHidden = true
        self.searchBar.showsCancelButton.toggle()
        self.navigationTitle = navigationTitle
        self.navigationSearchBarDelegate = navigationSearchBarDelegates
        self.searchBar.placeholder = placeholderText
        self.searchBar.returnKeyType = .done
        createRightNavSearchBarButton()
    }
    
    //MARK:- Create right search button in navigation contorller
    func createRightNavSearchBarButton(){
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "search"), style: .done, target: self, action: #selector(self.unHideSearchBar(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    //Unhide SearchBar
    @objc func unHideSearchBar(_ sender:UIBarButtonItem){
        if view_pickerView != nil{
            self.view_pickerView.isHidden = true
        }
        self.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
        self.searchBar.isHidden = false
        self.navigationItem.rightBarButtonItem = nil
    }
    
    //MARK:-OpenGallery and Camera
    func OpenGalleryCamera(camera:Bool,imagePickerDelegate:UIImagePickerDelegate)
    {
        if(camera == true){
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.imagePickerDelegate = imagePickerDelegate
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
                let alert  = UIAlertController(title: "", message: "Alerts.kDontHaveCamera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
             self.imagePickerDelegate = imagePickerDelegate
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK:- Set Navigation Bar Height after appearing search bar
    func setNavigationBarHeight(){
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
    
    func createBlurEffectView(){
        let blurEffect = UIBlurEffect(style: .dark)
        visualBlurView.effect = blurEffect
        visualBlurView.alpha = 0.3
        visualBlurView.frame = view.bounds
//        visualBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //blurview.isHidden = true
        view.addSubview(visualBlurView)
        
    }
    
    func removeBlurEffect() {
        visualBlurView.removeFromSuperview()
    }
  
}

//MARK: UIPickerViewDataSource,UIPickerViewDelegate
extension BaseUIViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerCount ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       // CommonFunctions.sharedmanagerCommon.println(object: "Title Row:- \(row)")
        return self.pickerDelegate?.GetTitleForRow(index: row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
       // CommonFunctions.sharedmanagerCommon.println(object: "Selected Row:- \(row)")
        self.pickerDelegate?.SelectedRow(index: row)
    }
}
extension BaseUIViewController:UIImagePickerControllerDelegate{
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
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                if #available(iOS 11.0, *) {
                    
                    if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
                        
                        var urlImage:URL?
                        guard let chosenImagee = info[.originalImage] as? UIImage else {
                            fatalError("\(info)")
                        }
                        
                        let chosenImage =  chosenImagee.fixedOrientation()!

                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // choose a name for your image
                        let fileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
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
                    guard let chosenImage = info[.originalImage] as? UIImage else {
                        fatalError("\(info)")
                    }
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    // choose a name for your image
                    let fileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
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
                
                imagePickerDelegate?.SelectedMedia(image: pickedImage, imageURL: imageURL,videoURL: nil)
            }
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
                imagePickerDelegate?.SelectedMedia(image: thumbnail, imageURL: nil,videoURL:videoURL )
            } catch
            {
          //     CommonFunctions.sharedmanagerCommon.println(object: "*** Error generating thumbnail: \(error.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            // When showing the ImagePicker update the status bar and nav bar properties.
            //UIApplication.shared.setStatusBarHidden(false, with: .none)
            //164 13 28
            navigationController.topViewController?.title = "Select photo"
            navigationController.navigationBar.isTranslucent = false
        
            navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            navigationController.navigationBar.barStyle = .default
            navigationController.setNavigationBarHidden(false, animated: animated)
    }
}

//MARK:- Search bar delegates
extension BaseUIViewController : UISearchBarDelegate{
    //Search bar text change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.navigationSearchBarDelegate?.textDidChange(searchBar: searchBar, searchText: searchText)
    }
    //Search Bar cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.isHidden = true
        if let navigationBar = self.navigationController?.navigationBar {
            let firstFrame = CGRect(x: 0, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            let titleLabel = UILabel(frame: firstFrame)
            titleLabel.text = self.navigationTitle
          //  titleLabel.font = UIFont(name: KAPPContentRelatedConstants.kAppGlobalFontName, size: 17)
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            navigationItem.titleView = titleLabel
            navigationItem.titleView?.center = titleLabel.center
            navigationItem.titleView?.setNeedsLayout()
        }
        createRightNavSearchBarButton()
        self.navigationSearchBarDelegate?.cancelButtonPress(uiSearchBar: searchBar)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

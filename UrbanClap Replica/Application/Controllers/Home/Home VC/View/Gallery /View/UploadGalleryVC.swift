

import UIKit
import Lottie
import SkyFloatingLabelTextField
import KMPlaceholderTextView

class UploadGalleryVC: CustomController
{

    enum ImagePickers
    {
        case gallery
        init()
        {
            self = .gallery
        }
    }
    
    @IBOutlet var btnSubmit: ButtonWithShadowAndRadious!
    @IBOutlet var viewLottie: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var collGallery: UICollectionView!
    
    var arrayGallery = NSMutableArray()
    var selectedPicker: ImagePickers?
    var compnyID = ""
    
    let animationView = AnimationView(name: "camera")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let dic = NSMutableDictionary()
        dic.setValue(UIImage(), forKey: "data")
        dic.setValue(imageURL, forKey: "url")
        dic.setValue(1, forKey: "dummy")
        
        self.arrayGallery.add(dic)
        self.collGallery.reloadData()
        
        self.btnSubmit.updateLayerProperties()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.moveBACK(controller: self)
    }
    
    
    @IBAction func btnSubmit(_ sender: Any)
    {
        var parm = [String:Any]()
        parm["companyId"] = self.compnyID
        parm["mediaType"] = "photo"
        
      //  parm["title"] = self.tfTitle.text
     //   parm["description"] = self.txtDesc.text

        var mediaObjs = [[String:Any]]()


        if(self.arrayGallery.count > 1)
        {
            for i in 0...self.arrayGallery.count-1
            {
                if(i != 0)
                {
                    let obj = self.arrayGallery.object(at: i) as! NSDictionary

                    var mediaObj = [String:Any]()
                    mediaObj["fileType"] = "Image"
                    mediaObj["url"] = obj.value(forKey: "url")as! URL
                    let img : UIImage = obj.value(forKey: "data")as! UIImage
                    mediaObj["imageData"] = img
                    mediaObjs.append(mediaObj)
                }
            }
        }


        parm["media"] = mediaObjs
        print(parm as Any)
        self.submitGallery(obj: parm)
    }
    
    @IBAction func acnDeleteImage(_ sender: UIButton)
    {
        let arr = self.arrayGallery.mutableCopy() as! NSMutableArray
        arr.removeObject(at: sender.tag)
        self.arrayGallery = arr
        self.collGallery.reloadData()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        //animationView.center = self.viewLottie.center
         animationView.frame = viewLottie.bounds
         animationView.contentMode = .scaleAspectFit
         animationView.loopMode = .playOnce
         viewLottie.addSubview(animationView)
         animationView.play()
    }


    func submitGallery(obj: [String:Any])
    {
        WebService.Shared.uploadData_Multiple_image(mediaType:.Image, url: APIAddress.ADD_COMPANY_GALLERY, postdatadictionary: obj, Target: self, completionResponse: { response in
            
            Commands.println(object: response as Any)
            
            self.showToastSwift(alrtType: .success, msg: "Your gallery submitted successfully.", title: "")
            self.moveBACK(controller: self)
            
        }, completionnilResponse: { (errorMsg) in
            self.showToastSwift(alrtType: .error, msg: errorMsg, title: kFailed)
        }, completionError: { (error) in
            self.showToastSwift(alrtType: .error, msg: error as? String ?? "", title: kFailed)
        })
    }
    
}

extension UploadGalleryVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrayGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellClassGallery", for: indexPath) as! cellClassGallery
        
        let dic = self.arrayGallery.object(at: indexPath.row) as! NSDictionary
        
        let dummy = dic.value(forKey: "dummy")as! Int
        if (dummy == 1)
        {
            cell.collGallery.backgroundColor = kpinkTheme
            cell.lblAdd.isHidden = false
            cell.btnDelete.isHidden = true
            cell.collGallery.image = nil
        }
        else
        {
            cell.collGallery.backgroundColor = UIColor.clear
            cell.collGallery.image = dic.value(forKey: "data")as? UIImage
            cell.lblAdd.isHidden = true
            cell.btnDelete.isHidden = false
        }
        
        cell.collGallery.CornerRadius(radius: 15)
        cell.collGallery.layer.borderColor = kpurpleTheme.cgColor
        cell.collGallery.layer.borderWidth = 0.5
        cell.btnDelete.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dic = self.arrayGallery.object(at: indexPath.row) as! NSDictionary
        
        let dummy = dic.value(forKey: "dummy")as! Int
        if (dummy == 1)
        {
            if (self.arrayGallery.count > 4)
            {
                self.showToastSwift(alrtType: .statusOrange, msg: "You can not add more than 4 images", title: "")
            }
            else
            {
                selectedPicker = ImagePickers.gallery
                OpenGalleryCamera(camera: true, imagePickerDelegate: self, isVideoAlso: false)
            }
        }
        else
        {
            
        }
    }
    
}

extension UploadGalleryVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
}



//MARK:- UIImagePickerDelegate
extension UploadGalleryVC: UIImagePickerDelegate
{
    func SelectedMedia(image: UIImage?, imageURL: URL?, videoURL: URL?)
    {
        switch selectedPicker
        {
        case .gallery:
            
            let dic = NSMutableDictionary()
            dic.setValue(image, forKey: "data")
            dic.setValue(imageURL, forKey: "url")
            dic.setValue(0, forKey: "dummy")
            
            self.arrayGallery.add(dic)
            self.collGallery.reloadData()
            
        default: break
            
        }
    }
    
    func selectedImageUrl(url: URL)
    {
        
    }
    
    func cancelSelectionOfImg()
    {
        
    }
}

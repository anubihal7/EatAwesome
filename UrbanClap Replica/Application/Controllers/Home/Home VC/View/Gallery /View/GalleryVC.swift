
//

import UIKit
import SDWebImage

class GalleryVC: CustomController
{
    
    @IBOutlet var collGallery: UICollectionView!
    
    @IBOutlet var pager: UIPageControl!
    
    var compnyID = ""
    var arrGallry:[BodyGllry]?
    var index = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.GetGallery()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func moveBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acnAddNewImage(_ sender: Any)
    {
        let controller = Navigation.GetInstance(of: .UploadGalleryVC) as! UploadGalleryVC
        controller.compnyID = self.compnyID
        self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    func GetGallery()
    {
        let obj : [String:Any] = ["companyId":self.compnyID,"mediaType":"photo","page":"","limit":""]
        
        
        WebService.Shared.PostApi(url: APIAddress.GET_COMPANY_GALLERY, parameter: obj , Target: self, completionResponse: { response in
            Commands.println(object: response)
            
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let model = try JSONDecoder().decode(GalleryResult.self, from: jsonData)
                self.arrGallry = model.body
                self.collGallery.reloadData()
                self.pager.numberOfPages = self.arrGallry?.count ?? 0
                self.scrollCollection()
            }
            catch
            {
                self.showToastSwift(alrtType: .error, msg: kResponseNotCorrect, title: kOops)
            }
        }, completionnilResponse: {(error) in
            self.showToastSwift(alrtType: .error, msg: error, title: kFailed)
        })
        
    }
    
    func scrollCollection()
    {
        let path = IndexPath(item: index, section: 0)
        self.collGallery.scrollToItem(at: path, at: .left, animated: true)
    }
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
//    {
////        for cell in yourCollectionView.visibleCells
////        {
////            let indexPath = yourCollectionView.indexPath(for: cell)
////            print(indexPath)
////        }
//        
//        var visibleRect = CGRect()
//        visibleRect.origin = collGallery.contentOffset
//        visibleRect.size = collGallery.bounds.size
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        guard let indexPath = collGallery.indexPathForItem(at: visiblePoint) else { return }
//        print(indexPath)
//        self.pager.currentPage = indexPath.row+1
//    }
}

extension GalleryVC:UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrGallry?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellClassGallry", for: indexPath) as! cellClassGallry
        
        if let data = arrGallry?[indexPath.row]
        {
            let img = data.mediaHttpUrl ?? ""
          //  cell.ivGallery.sd_setImage(with: URL(string: img), completed: nil)
            
            cell.ivGallery.setImage(with: img, placeholder: kplaceholderImage)
            cell.ivGallery.CornerRadius(radius: 10.0)
            
//            cell.ivGallery.sd_setImage(with: URL(string: img))
//            { (img, err, cache, url) in
//               // cell.indicator.isHidden = true
//            }
            
            cell.ivGallery.CornerRadius(radius: 15)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        self.pager.currentPage = indexPath.row
    }
}

extension GalleryVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            let frm = self.collGallery.frame
            return CGSize(width: frm.size.width, height: frm.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0.0
    }
}

class cellClassGallry:UICollectionViewCell
{
   // @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var ivGallery: UIImageView!
}

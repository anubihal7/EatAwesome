
//

import Foundation

extension SeeAllRestaurantsVC : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.bannersDATA?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        
        let cellnew = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_Banners, for: indexPath)as! BannersCollectionCell
        
        if let data = self.bannersDATA?[indexPath.row]
        {
            cellnew.hideAnimation()
            let imgPath = data.icon ?? ""
            cellnew.ivBanners.setImage(with: imgPath, placeholder: kplaceholderFood)
            cellnew.ivBanners.CornerRadius(radius: 10)
        }
        else
        {
            cellnew.showAnimation()
        }
        
        cell = cellnew
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //  let controller = Navigation.GetInstance(of: .SubCatsVC)as! SubCatsVC
        //  self.push_To_Controller(from_controller: self, to_Controller: controller)
    }
    
    
    
    
}

extension SeeAllRestaurantsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let w = collectionView.frame.size.width
        return CGSize(width: w-10, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10.0
    }
}

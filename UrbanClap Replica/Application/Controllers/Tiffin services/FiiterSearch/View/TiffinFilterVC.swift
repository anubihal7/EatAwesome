
//

import UIKit

class TiffinFilterVC: UIViewController {

    //MARK:-outlet and Variables
    
    
    //MARK:- life cycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- other functions
    
    //MARK:- Actions

}

//MARK:- Collecion Delegate

extension TiffinFilterVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1//selectedFilterArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionCell", for: indexPath)as! FilterCollectionCell
        //cell.lblTitle.text = selectedFilterArray[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->
        CGSize {return CGSize(width: 20.00, height: 20.00)}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
}

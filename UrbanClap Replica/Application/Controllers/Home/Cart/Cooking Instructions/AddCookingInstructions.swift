
//

import UIKit
import BottomPopup
import KMPlaceholderTextView
import Lottie
import AVFoundation


protocol UpdateViewAfterInstruction_Delegate
{
    func refreshController(text:String,audioPath:URL)
}

class AddCookingInstructions: BottomPopupViewController
{
    @IBOutlet var viewSlide: UIView!
    @IBOutlet var txtView: KMPlaceholderTextView!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var btnAdd: CustomButton!
    
    var oldText = ""
    
  //  @IBOutlet var AudioView: RoundShadowView!
  //  @IBOutlet var btnListen: UIButton!
  //  @IBOutlet var ivAudioBG: UIImageView!
  //  @IBOutlet var lblAudioTitile: UILabel!
    
    
    var audioFile = URL(string:"www.google.com")
    var player: AVAudioPlayer?
    
    
    var delegateInstructions: UpdateViewAfterInstruction_Delegate?
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(600) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.6 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.6 }
    override var popupDimmingViewAlpha: CGFloat { return 0.6 }
    
    let animationView = AnimationView(name: "cooking")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if(oldText != "Add instructions")
        {
            self.txtView.text = oldText
        }
        
        
        
        self.txtView.layer.borderColor = UIColor.darkGray.cgColor
        self.txtView.layer.borderWidth = 0.6
        self.txtView.layer.cornerRadius = 10
        self.txtView.layer.masksToBounds = true
        self.btnAdd.backgroundColor = Appcolor.get_category_theme()
    //    self.lblAudioTitile.textColor = Appcolor.get_category_theme()
     //   self.ivAudioBG.layer.cornerRadius = 10
     //   self.ivAudioBG.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        // animationView.center = self.viewLottie.center
        animationView.frame = viewBG.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        viewBG.addSubview(animationView)
        animationView.play()
    }
    
    
    @IBAction func acnRecordAudio(_ sender: Any)
    {
        self.view.endEditing(true)
        
        let vc = Navigation.GetInstance(of: .RecordAudioViewController)as! RecordAudioViewController
        vc.delegateAudioRecorder = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ListenAudio(_ sender: Any)
    {
//        if(btnListen.tag == 0)
//        {
//            btnListen.tag = 1
//            self.btnListen.setBackgroundImage(UIImage(named: "recordpause"), for: .normal)
//            self.playSound()
//        }
//        else if(btnListen.tag == 1)
//        {
//            btnListen.tag = 0
//            self.btnListen.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
//            self.player?.pause()
//        }
    }
    @IBAction func hideAudioView(_ sender: Any)
    {
      //  self.audioFile = URL(string: "www.google.com")!
      //  self.AudioView.isHidden = true
    }
    
    
    @IBAction func actionSubmit(_ sender: UIButton)
    {
//        if(self.AudioView == nil && self.txtView.text.count == 0)
//        {
//            sender.shake()
//            self.showToastSwift(alrtType: .error, msg: "Please enter or record some cooking instructions", title: kOops)
//        }
//        else
//        {
            
            self.delegateInstructions?.refreshController(text: self.txtView.text,audioPath: URL(string: "www.google.com")!)
            dismiss(animated: true, completion: nil)
      //  }
    }
    
    func playSound()
    {
       // guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: self.audioFile ?? URL(string: "")!, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        }
        catch let error
        {
//            self.btnListen.tag = 0
//            self.btnListen.setBackgroundImage(UIImage(named: "recordplay"), for: .normal)
            print(error.localizedDescription)
        }
    }
}

extension AddCookingInstructions : getAudioProtocol
{
    func getFilePathAudio(fileURL: URL)
    {
        
        self.audioFile = fileURL
      //  self.AudioView.isHidden = false
       
    }
    
    
}

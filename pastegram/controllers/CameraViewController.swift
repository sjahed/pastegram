//
//  CameraViewController.swift
//  pastegram
//
//  Created by Sayed Jahed Hussini on 10/10/21.
//

import UIKit
import AlamofireImage
import Parse
import MBProgressHUD

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        
        let post = PFObject(className: "Posts")
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = pictureView.image!.pngData()
        let file = PFFileObject(name:"image.png", data: imageData! )
        post["image"] = file
        MBProgressHUD.showAdded(to: self.view, animated: true)//load the animation
        post.saveInBackground { (success,error) in
            if success {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.dismiss(animated: true, completion: nil )
            }else{
                print("eroro" )
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera         }else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        pictureView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

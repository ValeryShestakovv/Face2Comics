//
//  ViewController.swift
//  GAN_for_IOS
//
//  Created by Valery Shestakov on 22.03.2022.
//
import CoreML
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    private var logoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var inputImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "default_image")!.roundImage(radius: 10)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let outputImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    private let buttonOpenLibrary: UIButton = {
        let button = UIButton()
        button.setTitle("Choose Photo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "button"), for: .normal)
        button.setImage(UIImage(systemName: "folder.circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    private let buttonSaveImage: UIButton = {
        let button = UIButton()
        button.setTitle("Save Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "button"), for: .normal)
        button.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    private let buttonGenerate: UIButton = {
        let button = UIButton()
        button.setTitle("Ganerate Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "button"), for: .normal)
        button.setImage(UIImage(systemName: "gearshape.circle"), for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        createIU()
        
        buttonOpenLibrary.addTarget(self, action: #selector(buttonOnClick), for: .touchUpInside)
        buttonSaveImage.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        buttonGenerate.addTarget(self, action: #selector(imageGanerate), for: .touchUpInside)
        
        //UIImageWriteToSavedPhotosAlbum(UIImage(named: "test")!, self, #selector(alertSaveImageToAlbum(_ :didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage() {
        UIImageWriteToSavedPhotosAlbum(outputImageView.image!, self, #selector(alertSaveImageToAlbum(_ :didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func alertSaveImageToAlbum(_ image:UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func createIU() {
        view.addSubview(logoImageView)
        view.addSubview(inputImageView)
        view.addSubview(outputImageView)
        view.addSubview(buttonGenerate)
        view.addSubview(buttonOpenLibrary)
        view.addSubview(buttonSaveImage)
        outputImageView.isHidden = true
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        inputImageView.translatesAutoresizingMaskIntoConstraints = false
        outputImageView.translatesAutoresizingMaskIntoConstraints = false
        buttonGenerate.translatesAutoresizingMaskIntoConstraints = false
        buttonOpenLibrary.translatesAutoresizingMaskIntoConstraints = false
        buttonSaveImage.translatesAutoresizingMaskIntoConstraints = false

        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 90).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -90).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 5).isActive = true
        
        inputImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0).isActive = true
        inputImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        inputImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        inputImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        
        outputImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0).isActive = true
        outputImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        outputImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        outputImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        
        buttonGenerate.topAnchor.constraint(equalTo: inputImageView.bottomAnchor, constant: -10).isActive = true
        buttonGenerate.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        buttonGenerate.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        buttonGenerate.heightAnchor.constraint(equalToConstant: view.frame.height / 15).isActive = true
        
        buttonOpenLibrary.topAnchor.constraint(equalTo: buttonGenerate.bottomAnchor, constant: 5).isActive = true
        buttonOpenLibrary.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        buttonOpenLibrary.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        buttonOpenLibrary.heightAnchor.constraint(equalToConstant: view.frame.height / 15).isActive = true
        
        buttonSaveImage.topAnchor.constraint(equalTo: buttonOpenLibrary.bottomAnchor, constant: 5).isActive = true
        buttonSaveImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        buttonSaveImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        buttonSaveImage.heightAnchor.constraint(equalToConstant: view.frame.height / 15).isActive = true
        
    }
    
    @objc func buttonOnClick(_ sender: UIButton){
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.openCameraButton()}))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in self.openPhotoLibraryButton()}))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @objc func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        inputImageView.image = image.resize(size: CGSize(width: 256, height: 256))!.roundImage(radius: 10)
        inputImageView.isHidden = false
        outputImageView.isHidden = true
        buttonGenerate.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageGanerate() {
        inputImageView.isHidden = true
        outputImageView.isHidden = false
        buttonSaveImage.isEnabled = true
        buttonGenerate.isEnabled = false
        analyzeImage(image: inputImageView.image)
    }
    

    private func analyzeImage(image: UIImage?) {
        guard let buffer = image?.getCVPixelBuffer() else {
                    return
                }
        
        do {
            let config = MLModelConfiguration()
            let model = try model_coreml(configuration: config)
            let input = model_coremlInput(input_1: buffer)
            
            let output = try model.prediction(input: input)
            
            let ciImage = CIImage(cvPixelBuffer: output.var_385)
            let resultImage = UIImage(ciImage: ciImage).roundImage(radius: 10)
            outputImageView.image = resultImage
        } catch {
            print(error.localizedDescription)
        }
    }
}







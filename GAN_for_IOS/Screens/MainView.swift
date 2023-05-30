import Foundation
import UIKit

final class MainView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private lazy var logoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "logo"
        return imageView
    }()
    private lazy var inputImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "default_image")
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = "default_image"
        return imageView
    }()
    private lazy var outputImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    private lazy var buttonOpenLibrary: UIButton = {
        let button = UIButton()
        button.setTitle("Choose Photo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "button"), for: .normal)
        button.setImage(UIImage(systemName: "folder.circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    private lazy var buttonSaveImage: UIButton = {
        let button = UIButton()
        button.setTitle("Save Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "button"), for: .normal)
        button.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    private lazy var buttonGenerate: UIButton = {
        let button = UIButton()
        button.setTitle("Ganerate Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "button"), for: .normal)
        button.setImage(UIImage(systemName: "gearshape.circle"), for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    let viewModel: MainViewModel
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        createIU()
        buttonOpenLibrary.addTarget(self, action: #selector(buttonOnClick), for: .touchUpInside)
        buttonSaveImage.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        buttonGenerate.addTarget(self, action: #selector(imageGanerate), for: .touchUpInside)
    }
    private func createIU() {
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

        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 90).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -90).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 5).isActive = true

        inputImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 25).isActive = true
        inputImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputImageView.widthAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        inputImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true

        outputImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        outputImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outputImageView.widthAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        outputImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true

        buttonGenerate.topAnchor.constraint(equalTo: inputImageView.bottomAnchor, constant: 20).isActive = true
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
    @objc private func saveImage() {
        guard let image = outputImageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(alertSaveImageToAlbum(_ :didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc private func alertSaveImageToAlbum(_ image:UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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
    @objc private func buttonOnClick(_ sender: UIButton){
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.openCameraButton()}))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in self.openPhotoLibraryButton()}))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @objc private func openCameraButton() {
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
        inputImageView.image = image.resize(size: CGSize(width: 256, height: 256))
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
        guard let image = analyzeImage(image: inputImageView.image) else {
            return
        }
        outputImageView.image = image.roundImage(radius: 10)
    }
    func analyzeImage(image: UIImage?) -> UIImage? {
        guard let buffer = image?.getCVPixelBuffer(),
              let predictImage = viewModel.analyzeImage(imageBuffer: buffer) else {
            return nil
        }
        let resultImage = UIImage(ciImage: predictImage)
        return resultImage
    }
}

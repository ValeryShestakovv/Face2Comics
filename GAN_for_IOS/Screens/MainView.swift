import Foundation
import UIKit
import Lottie

final class MainView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private lazy var logoImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "logo"
        return imageView
    }()
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: "default_image")
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = "default_image"
        return imageView
    }()
    private let loadingView = LottieAnimationView(name: "loading")
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
        view.addSubview(imageView)
        view.addSubview(loadingView)
        view.addSubview(buttonGenerate)
        view.addSubview(buttonOpenLibrary)
        view.addSubview(buttonSaveImage)
//        loadingView.isHidden = true

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        buttonGenerate.translatesAutoresizingMaskIntoConstraints = false
        buttonOpenLibrary.translatesAutoresizingMaskIntoConstraints = false
        buttonSaveImage.translatesAutoresizingMaskIntoConstraints = false

        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 90).isActive = true
        logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -90).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 5).isActive = true

        imageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 25).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true

        loadingView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true

        buttonGenerate.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
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
        guard let image = imageView.image else {
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
        imageView.image = image.resize(size: CGSize(width: 256, height: 256))
        buttonGenerate.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    @objc func imageGanerate() {
        loadingView.play()
        UIView.animate(withDuration: 0.5) {
            self.buttonSaveImage.isEnabled = true
            self.buttonGenerate.isEnabled = false
            self.imageView.alpha = 0
        }
        analyzeImage(image: imageView.image)
    }
    func analyzeImage(image: UIImage?) {
        guard let buffer = image?.getCVPixelBuffer() else {
            return
        }
        viewModel.analyzeImage(imageBuffer: buffer) { [weak self] predictImage in
            guard
                let self = self,
                let image = predictImage else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(ciImage: image).roundImage(radius: 10)
                UIView.animate(withDuration: 0.5) {
                    self.imageView.alpha = 1
                    self.loadingView.stop()
                }
            }
        }
    }
}

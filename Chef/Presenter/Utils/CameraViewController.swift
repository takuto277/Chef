//
//  CameraViewController.swift
//  Chef
//
//  Created by 小野拓人 on 2025/02/22.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    
    // カメラを起動するボタン
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("カメラを起動", for: .normal)
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 撮影した画像を表示するImageView
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // UIの設定
        view.backgroundColor = .white
        
        // ボタンの配置
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // ImageViewの配置
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: cameraButton.topAnchor, constant: -20)
        ])
    }
    
    @objc private func cameraButtonTapped() {
        // カメラの利用可能確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true)
        } else {
            showAlert(message: "カメラを利用できません")
        }
    }
    
    // アラート表示
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // 撮影完了時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        delegate?.imagePickerController?(picker, didFinishPickingMediaWithInfo: info)
        picker.dismiss(animated: true)
    }
    
    // キャンセル時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

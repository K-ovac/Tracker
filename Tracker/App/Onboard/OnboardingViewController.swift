//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Максим Лозебной on 22.02.2026.
//
import UIKit

final class OnboardingViewController: UIViewController {
    //MARK: Properties
    private let def = DefaultsService()
    private let model: OnboardingModel
    
    //MARK: UI
    private lazy var backgrImage = UIImageView()
    private lazy var descriptionLabel = UILabel()
    private lazy var startButton = makeBottomButton(
        title: "Вот это технологии!",
        titleColor: Colors.textButton,
        backgrColor: Colors.backgroundButton
    )
    
    //MARK: Inits
    init(model: OnboardingModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        configureUI()
        setupActions()
    }
    
    //MARK: Setup View
    private func setupView() {
        view.clipsToBounds = true
        view.addSubview(backgrImage)
        view.addSubview(descriptionLabel)
        view.addSubview(startButton)
    }
    
    //MARK: Setup Layout
    private func setupLayout() {
        [backgrImage, descriptionLabel, startButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgrImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgrImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgrImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgrImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.l),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metrics.t),
        ])
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: Metrics.heightButton),
            startButton.widthAnchor.constraint(equalToConstant: 335),
        ])
    }
    
    //MARK: Configure UI
    private func configureUI() {
        backgrImage.image = model.image
        
        backgrImage.contentMode = .scaleAspectFill
        backgrImage.clipsToBounds = true
        
        descriptionLabel.text = model.description
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 32, weight: .bold)
        descriptionLabel.textColor = Colors.textPrimary
    }
    
    //MARK: Configure Button
    private func makeBottomButton(
        title: String,
        titleColor: UIColor,
        backgrColor: UIColor
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        button.backgroundColor = backgrColor
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Metrics.defCornerRadius
        
        return button
    }
    
    //MARK: Setup Actions
    private func setupActions() {
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    //MARK: Actions
    @objc private func didTapStartButton() {
        print("Нажата кнопка 'Вот это технологии!'")
        def.sawOnboard = true
        
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        else { return }
        
        window.rootViewController = TabBarController()
        UIView.transition(with: window,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
}

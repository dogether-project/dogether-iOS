//
//  CustomSheetViewController.swift
//  dogether
//
//  Created by yujaehong on 4/28/25.
//

import UIKit

class CustomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    var onDismiss: (() -> Void)?
    var selectedOption: SortOption?
    var didSelectOption: ((SortOption) -> Void)?
    
    private let titleText: String
    private var filterOptions: [SortOption]
    private weak var overlayView: UIView?
    
    // UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey600
        view.layer.cornerRadius = 3
        view.frame.size = CGSize(width: 40, height: 6)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .grey0
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.grey0, for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let bottomSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Initializer
    
    init(titleText: String, filterOptions: [SortOption], selectedOption: SortOption) {
        self.titleText = titleText
        self.filterOptions = filterOptions
        self.selectedOption = selectedOption
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addOverlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeOverlay()
    }
    
    // MARK: - Setup Methods
    
    override func configureView() {
        view.backgroundColor = .clear
        titleLabel.text = titleText
        tableView.register(CustomSheetCell.self, forCellReuseIdentifier: "CustomSheetCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func configureAction() {
        confirmButton.addAction(
            UIAction { [weak self] _ in
                guard let self = self else { return }
                self.didTapConfirmButton()
            },
            for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(handleView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(confirmButton)
        containerView.addSubview(tableView)
        containerView.addSubview(bottomSpacerView)
    }
    
    override func configureConstraints() {
        let tableViewHeight = CGFloat(filterOptions.count * 49)
        let containerHeight = tableViewHeight + 28 + 25 + 48
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(containerHeight)
        }
        
        handleView.snp.makeConstraints {
            $0.top.equalTo(containerView).inset(8)
            $0.centerX.equalTo(containerView)
            $0.width.equalTo(40)
            $0.height.equalTo(6)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).inset(24)
            $0.leading.equalTo(containerView).inset(24)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(containerView).inset(23)
            $0.trailing.equalTo(containerView).inset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel).inset(30)
            $0.leading.trailing.equalTo(containerView)
            $0.height.equalTo(tableViewHeight)
        }
        
        bottomSpacerView.snp.makeConstraints {
            $0.leading.trailing.equalTo(containerView)
            $0.height.equalTo(48)
            $0.bottom.equalTo(containerView)
        }
    }
}

// MARK: - Actions

extension CustomSheetViewController {
    
    private func didTapConfirmButton() {
        if let selectedOption = selectedOption {
            didSelectOption?(selectedOption)
        }
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // 터치한 위치가 containerView 외부일 경우 dismiss
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
}

extension CustomSheetViewController {
    
    private func addOverlay() {
        guard let presentingView = presentingViewController?.view else { return }
        
        let overlay = UIView(frame: presentingView.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0.0
        presentingView.addSubview(overlay)
        presentingView.bringSubviewToFront(overlay)
        
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1.0
        }
        
        self.overlayView = overlay
    }
    
    private func removeOverlay() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView?.alpha = 0.0
        }, completion: { _ in
            self.overlayView?.removeFromSuperview()
        })
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CustomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSheetCell", for: indexPath) as! CustomSheetCell
        let option = filterOptions[indexPath.row]
        let isSelected = option == selectedOption
        cell.configure(option: option.rawValue, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = filterOptions[indexPath.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
}

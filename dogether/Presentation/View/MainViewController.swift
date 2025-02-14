//
//  MainViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import Foundation
import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    private var viewModel = MainViewModel()
    private let initialSheetOffset: CGFloat = 281   // TODO: 추후 개선
    private var dogetherPanGesture: UIPanGestureRecognizer!
    private var dogetherSheetTopConstraint: Constraint?
    
    private let dogetherHeader = DogetherHeader()
    private let groupNameLabel = {
        let label = UILabel()
        label.textColor = .blue300
        label.font = Fonts.emphasis2B
        return label
    }()
    private var joinCodeDescriptionLabel = UILabel()
    private var endDateDescriptionLabel = UILabel()
    private var joinCodeInfoLabel = UILabel()
    private var endDateInfoLabel = UILabel()
    private var joinCodeStackView = UIStackView()
    private var endDateStackView = UIStackView()
    private func mainInfoStackView(stackViews: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: stackViews)
        stackView.axis = .horizontal
        stackView.spacing = 28
        return stackView
    }
    private var mainInfoStackView = UIStackView()
    private let rankingButton = {
        let button = UIButton()
        button.backgroundColor = .grey700
        button.layer.cornerRadius = 8
        return button
    }()
    private let rankingImageView = {
        let imageView = UIImageView()
        imageView.image = .chart
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    private let rankingLabel = {
        let label = UILabel()
        label.text = "순위 보러가기 !"
        label.textColor = .grey100
        label.font = Fonts.body1S
        label.isUserInteractionEnabled = false
        return label
    }()
    private let rankingChevronImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .grey100
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    private let dogetherSheet = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    private let dogetherSheetHeaderLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private let dogetherScrollView = UIScrollView()
    private let dogetherScrollContentView = UIView()
    private let todoImageView = {
        let imageView = UIImageView()
        imageView.image = .todo
        return imageView
    }()
    private let todoTitleLabel = {
        let label = UILabel()
        label.text = "오늘의 투두를 작성해보세요"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    private let todoSubTitleLabel = {
        let label = UILabel()
        label.text = "매일 자정부터 새로운 투두를 입력해요"
        label.textColor = .grey300
        label.font = Fonts.body2R
        return label
    }()
    private let todoButton = DogetherButton(action: {
        // TODO: 추후 투두 작성하기로 이동하도록 구현
    }, title: "투두 작성하기", status: .abled)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        groupNameLabel.text = viewModel.groupName
        
        joinCodeDescriptionLabel.attributedText = NSAttributedString(
            string: "초대코드",
            attributes: Fonts.getAttributes(for: Fonts.body2S, textAlignment: .left)
        )
        joinCodeDescriptionLabel.textColor = .grey300
        endDateDescriptionLabel.attributedText = NSAttributedString(
            string: "종료일",
            attributes: Fonts.getAttributes(for: Fonts.body2S, textAlignment: .left)
        )
        endDateDescriptionLabel.textColor = .grey300
        joinCodeInfoLabel.attributedText = NSAttributedString(
            string: viewModel.joinCode,
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        joinCodeInfoLabel.textColor = .grey0
        endDateInfoLabel.attributedText = NSAttributedString(
            string: "\(DateFormatterManager.formattedDate(viewModel.restDay))(D-\(viewModel.restDay))",
            attributes: Fonts.getAttributes(for: Fonts.body1S, textAlignment: .left)
        )
        endDateInfoLabel.textColor = .grey0
        joinCodeStackView = UIStackView(arrangedSubviews: [joinCodeDescriptionLabel, joinCodeInfoLabel])
        joinCodeStackView.axis = .vertical
        endDateStackView = UIStackView(arrangedSubviews: [endDateDescriptionLabel, endDateInfoLabel])
        endDateStackView.axis = .vertical
        mainInfoStackView = mainInfoStackView(stackViews: [joinCodeStackView, endDateStackView])
        
        rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
        
        dogetherPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dogetherPanGesture.delegate = self
        dogetherSheet.addGestureRecognizer(dogetherPanGesture)
        
        dogetherSheetHeaderLabel.text = DateFormatterManager.formattedDate()
        
        dogetherScrollView.delegate = self
        dogetherScrollView.bounces = false
        dogetherScrollView.showsVerticalScrollIndicator = false
    }
    
    override func configureHierarchy() {
        [
            dogetherHeader, groupNameLabel, mainInfoStackView,
            rankingButton, rankingImageView, rankingLabel, rankingChevronImageView,
            dogetherSheet
        ].forEach { view.addSubview($0) }
        
        [dogetherSheetHeaderLabel, dogetherScrollView].forEach { dogetherSheet.addSubview($0) }
        [dogetherScrollContentView].forEach { dogetherScrollView.addSubview($0) }
        [todoImageView, todoTitleLabel, todoSubTitleLabel, todoButton].forEach { dogetherScrollContentView.addSubview($0) }
    }
    
    override func configureConstraints() {
        dogetherHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        groupNameLabel.snp.makeConstraints {
            $0.top.equalTo(dogetherHeader.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        mainInfoStackView.snp.makeConstraints {
            $0.top.equalTo(groupNameLabel.snp.bottom).offset(16)
            $0.left.equalTo(groupNameLabel)
        }
        
        rankingButton.snp.makeConstraints {
            $0.top.equalTo(mainInfoStackView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        rankingImageView.snp.makeConstraints {
            $0.centerY.equalTo(rankingButton)
            $0.left.equalTo(rankingButton).offset(16)
            $0.width.height.equalTo(24)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.centerY.equalTo(rankingButton)
            $0.left.equalTo(rankingImageView.snp.right).offset(8)
            $0.height.equalTo(25)
        }
        
        rankingChevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(rankingButton)
            $0.right.equalTo(rankingButton).offset(-16)
            $0.width.height.equalTo(22)
        }
        
        dogetherSheet.snp.makeConstraints {
            dogetherSheetTopConstraint = $0.top.equalTo(view.safeAreaLayoutGuide).offset(initialSheetOffset).constraint
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        dogetherSheetHeaderLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dogetherSheet).offset(24)
            $0.height.equalTo(28)
        }
        
        dogetherScrollView.snp.makeConstraints {
            $0.top.equalTo(dogetherSheetHeaderLabel.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
        
        dogetherScrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(dogetherScrollView)
            make.height.equalTo(UIScreen.main.bounds.height * 2)
        }
        
        todoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(202)
            $0.height.equalTo(131)
        }
        
        todoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(todoImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        todoSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(todoTitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        todoButton.snp.makeConstraints {
            $0.top.equalTo(todoSubTitleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if viewModel.isBlockPanGesture { return }
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            switch viewModel.sheetStatus {
            case .expand:
                if translation.y > 0 {
                    dogetherSheetTopConstraint?.update(offset: min(initialSheetOffset, translation.y))
                    view.layoutIfNeeded()
                }
            case .normal:
                if translation.y < 0 {
                    dogetherSheetTopConstraint?.update(offset: max(0, initialSheetOffset + translation.y))
                    view.layoutIfNeeded()
                }
            }
            
        case .ended:
            switch viewModel.sheetStatus {
            case .expand:
                if translation.y > 100 { updateSheetStatus(to: .normal) }
                else { updateSheetStatus(to: .expand) }
            case .normal:
                if translation.y < -100 { updateSheetStatus(to: .expand) }
                else { updateSheetStatus(to: .normal) }
            }
            
        default:
            break
        }
    }
    
    private func updateSheetStatus(to status: SheetStatus) {
        viewModel.setIsBlockPanGesture(true)
        UIView.animate(withDuration: 0.3) {
            self.dogetherSheetTopConstraint?.update(offset: status == .expand ? 16 : self.initialSheetOffset)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.viewModel.setIsBlockPanGesture(false)
            self.viewModel.setSheetStatus(status)
        }
    }
    
    @objc private func didTapRankingButton() {
        // TODO: 추후 팀 정보(팀 랭킹)화면으로 이동하도록 구현
    }
}

// MARK: - about pan gesture
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if viewModel.sheetStatus == .expand && dogetherScrollView.contentOffset.y > 0 { return false }
        return true
    }
}

// MARK: - about scroll
extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if viewModel.sheetStatus == .normal {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.panGestureRecognizer.isEnabled = true
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.sheetStatus == .normal || viewModel.isBlockPanGesture {
            scrollView.contentOffset.y = 0
            return
        }
    }
}

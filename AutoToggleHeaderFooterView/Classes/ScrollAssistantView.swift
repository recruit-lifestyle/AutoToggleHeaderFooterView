//
//  AutoToggleHeaderFooterView.swift
//  Pods
//
//  Created by Tomoya Hayakawa on 2017/03/10.
//  Copyright (c) 2017 RECRUIT LIFESTYLE CO., LTD. All rights reserved.
//

import UIKit

public class AutoToggleHeaderFooterView: UIView {

    public enum State {
        case collapsed, expanded, scrolling
    }

    // MARK: - Public Parameter

    public var isTimerEnabled = true
    public var isScrollHeaderFooterEnabled = true
    public var showAnimationDuration = TimeInterval(0.5)
    public var autoShowTimeInterval = TimeInterval(3.0)
    private(set) public var state = State.expanded

    fileprivate(set) public var scrollView: UIScrollView?
    fileprivate(set) public var header: UIView?
    fileprivate(set) public var footer: UIView?

    private(set) public var headerHeight = CGFloat(0)
    private(set) public var footerHeight = CGFloat(0)

    private(set) public var visibleHeaderHeight = CGFloat(0) {
        didSet {
            headerTopConstraint?.constant = -scrollViewContentInset.top + (headerHeight - visibleHeaderHeight)
            guard let scrollView = scrollView else { return }
            scrollView.contentInset.top = trim(scrollViewContentInset.top + visibleHeaderHeight,
                                               min: scrollViewContentInset.top,
                                               max: scrollViewContentInset.top + headerHeight)
        }
    }
    private(set) public var visibleFooterHeight = CGFloat(0) {
        didSet {
            footerBottomConstraint?.constant = -scrollViewContentInset.bottom + (footerHeight - visibleFooterHeight)
            guard let scrollView = scrollView else { return }
            scrollView.contentInset.bottom = trim(scrollViewContentInset.bottom + visibleFooterHeight,
                                                  min: scrollViewContentInset.bottom,
                                                  max: scrollViewContentInset.bottom + visibleFooterHeight)
        }
    }

    // MARK: - Private Parameter

    fileprivate var autoShowTimer: Timer?
    private var lastScrollViewOffsetY: CGFloat?

    private var scrollViewContentInset = UIEdgeInsets.zero {
        didSet {
            scrollViewContentInset.top -= headerHeight
            scrollViewContentInset.bottom -= footerHeight
            headerTopConstraint?.constant = -scrollViewContentInset.top + (headerHeight - visibleHeaderHeight)
            footerBottomConstraint?.constant = -scrollViewContentInset.bottom + (footerHeight - visibleFooterHeight)
        }
    }

    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        gesture.delegate = self
        gesture.maximumNumberOfTouches = 1

        return gesture
    }()

    // MARK: Constraint

    fileprivate var headerTopConstraint: NSLayoutConstraint?
    fileprivate var footerBottomConstraint: NSLayoutConstraint?
    fileprivate var headerHeightConstraint: NSLayoutConstraint?
    fileprivate var footerHeightConstraint: NSLayoutConstraint?

    // MARK: KVO Key

    private let scrollViewContentInsetKeyPath = "contentInset"
    private let scrollViewContentOffsetKeyPath = "contentOffset"

    // MARK: - Initializer

    public init(header: UIView?, footer: UIView?) {
        super.init(frame: .zero)

        clipsToBounds = true

        if let header = header {
            self.header = header
            headerHeight = header.frame.height
            visibleHeaderHeight = headerHeight
            addSubview(header)
        }
        if let footer = footer {
            self.footer = footer
            footerHeight = footer.frame.height
            visibleFooterHeight = footerHeight
            addSubview(footer)
        }

        // Default state is .expanded, but if header and footer are zero height, set state to .collapsed.
        if headerHeight.isZero && footerHeight.isZero {
            state = .collapsed
        }

        setupHeaderFooterConstraints()
        resetAutoShowTimer()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        unRegisterScrollView()
    }

    // MARK: - Override Method

    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)

        // Bring header and footer to top
        if let header = header {
            bringSubview(toFront: header)
        }
        if let footer = footer {
            bringSubview(toFront: footer)
        }
    }

    // MARK: - Public Method

    /// addSubview ScrollView to AutoToggleHeaderFooterView and add constraint, gesture and observer.
    /// ScrollView is given the same size constraint as AutoToggleHeaderFooterView.
    /// Also inset and offset of ScrollView are adjusted by the height of header and footer.
    public func addScrollView(_ scrollView: UIScrollView) {
        addSubview(scrollView)

        register(scrollView: scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(Constraint.make(scrollView, edgesEqualTo: self))
    }

    /// Inset and offset of ScrollView are adjusted by the height of header and footer, and add gesture and observer.
    public func register(scrollView: UIScrollView) {
        if self.scrollView != nil {
            unRegisterScrollView()
        }
        self.scrollView = scrollView

        scrollView.scrollIndicatorInsets.top += headerHeight
        scrollView.scrollIndicatorInsets.bottom += footerHeight
        scrollView.contentInset.top += headerHeight
        scrollView.contentInset.bottom += footerHeight
        scrollView.contentOffset.y -= headerHeight
        scrollViewContentInset = scrollView.contentInset

        scrollView.addGestureRecognizer(panGesture)
        scrollView.addObserver(self, forKeyPath: scrollViewContentOffsetKeyPath, options: .new, context: nil)
    }

    /// Remove gesture and observer from ScrollView, and restore inset and offset of ScrollView.
    public func unRegisterScrollView() {
        scrollView?.removeGestureRecognizer(panGesture)
        scrollView?.removeObserver(self, forKeyPath: scrollViewContentOffsetKeyPath)

        scrollViewContentInset = .zero
        scrollView?.contentOffset.y += headerHeight
        scrollView?.scrollIndicatorInsets.top -= headerHeight
        scrollView?.scrollIndicatorInsets.bottom -= footerHeight
        scrollView?.contentInset.top -= headerHeight
        scrollView?.contentInset.bottom -= footerHeight

        scrollView = nil
    }

    /// Show header and footer with animation.
    /// Default animation duration is `showAnimationDuration: TimeInterval`.
    /// If `state` is already expanded this function will not be executed.
    public func showHeaderFooter(withDuration duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        guard state != .expanded else { return }
        state = .expanded
        visibleHeaderHeight = headerHeight
        visibleFooterHeight = footerHeight
        updateLayout(withDuration: duration ?? showAnimationDuration, completion: completion)
    }

    /// Hide header and footer with animation.
    /// Default animation duration is `showAnimationDuration: TimeInterval`.
    /// If ScrollView is unregistered or `state` is already collapsed this function will not be executed.
    public func hideHeaderFooter(withDuration duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        guard let scrollView = scrollView,
            overContentTopDistance(of: scrollView) <= 0 && overContentBottomDistance(of: scrollView) <= 0,
            state != .collapsed
            else { return }
        state = .collapsed
        visibleHeaderHeight = 0
        visibleFooterHeight = 0
        updateLayout(withDuration: duration ?? showAnimationDuration, completion: completion)
    }

    /// Update header height with animation.
    /// After header height has been updated, header will be displayed.
    /// Default animation duration is `showAnimationDuration: TimeInterval`.
    public func updateHeaderHeight(to newHeight: CGFloat, duration: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard header != nil else { return }
        let diffHeight = newHeight - headerHeight
        headerHeight = newHeight
        headerHeightConstraint?.constant = newHeight
        visibleHeaderHeight = newHeight
        scrollView?.scrollIndicatorInsets.top += diffHeight
        scrollView?.contentInset.top += diffHeight
        state = .expanded
        updateLayout(withDuration: duration, completion: completion)
    }

    /// Update footer height with animation.
    /// After footer height has been updated, footer will be displayed.
    /// Default animation duration is `showAnimationDuration: TimeInterval`.
    public func updateFooterHeight(to newHeight: CGFloat, duration: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard footer != nil else { return }
        let diffHeight = newHeight - footerHeight
        footerHeight = newHeight
        footerHeightConstraint?.constant = newHeight
        visibleFooterHeight = newHeight
        scrollView?.scrollIndicatorInsets.bottom += diffHeight
        scrollView?.contentInset.bottom += diffHeight
        state = .expanded
        updateLayout(withDuration: duration, completion: completion)
    }

    // MARK: - Timer Handler

    func handleTimer() {
        if isTimerEnabled {
            showHeaderFooter()
        }
        resetAutoShowTimer()
    }

    // MARK: - UIGestureRecognizer Handler

    func handlePan(gesture: UIGestureRecognizer) {
        guard let scrollView = scrollView else { return }
        switch gesture.state {
        case .began:
            state = .scrolling
            lastScrollViewOffsetY = scrollView.contentOffset.y
            autoShowTimer?.invalidate()

        case .cancelled, .ended, .failed:
            if isScrollHeaderFooterEnabled {
                let isOverHalfHeaderHeightVisible = header != nil ? visibleHeaderHeight >= headerHeight / 2 : false
                let isOverHalfFooterHeightVisible = footer != nil ? visibleFooterHeight >= footerHeight / 2 : false
                if overContentTopDistance(of: scrollView) >= 0 || overContentBottomDistance(of: scrollView) >= 0 {
                    showHeaderFooter(withDuration: 0.3)
                } else if !isOverHalfHeaderHeightVisible && !isOverHalfFooterHeightVisible {
                    hideHeaderFooter()
                } else {
                    showHeaderFooter()
                }
            }
            lastScrollViewOffsetY = nil
            resetAutoShowTimer()

        default:
            break
        }
    }

    // MARK: KVO

    public override func observeValue(forKeyPath keyPath: String?, of _: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView, let keyPath = keyPath, isScrollHeaderFooterEnabled else { return }

        switch keyPath {
        case scrollViewContentOffsetKeyPath:
            switch state {
            case .scrolling:
                guard let lastScrollViewOffsetY = lastScrollViewOffsetY else { break }
                let diff = lastScrollViewOffsetY - scrollView.contentOffset.y
                self.lastScrollViewOffsetY = scrollView.contentOffset.y

                if overContentTopDistance(of: scrollView) >= visibleHeaderHeight {
                    visibleHeaderHeight = trim(overContentTopDistance(of: scrollView), min: visibleHeaderHeight, max: headerHeight)
                    visibleFooterHeight = trim(visibleFooterHeight + diff, min: visibleFooterHeight, max: footerHeight)
                } else if overContentBottomDistance(of: scrollView) >= 0 {
                    visibleHeaderHeight = trim(visibleHeaderHeight + diff, min: visibleHeaderHeight, max: headerHeight)
                    visibleFooterHeight = trim(overContentBottomDistance(of: scrollView), min: visibleFooterHeight, max: footerHeight)
                } else {
                    visibleHeaderHeight = trim(visibleHeaderHeight + diff, min: 0, max: headerHeight)
                    visibleFooterHeight = trim(visibleFooterHeight + diff, min: 0, max: footerHeight)
                }
                updateLayout(withDuration: 0)

            case .collapsed:
                if overContentTopDistance(of: scrollView) >= headerHeight {
                    showHeaderFooter(withDuration: 0.1)
                } else if overContentBottomDistance(of: scrollView) >= footerHeight {
                    showHeaderFooter()
                } else if overContentTopDistance(of: scrollView) >= visibleHeaderHeight {
                    visibleHeaderHeight = trim(overContentTopDistance(of: scrollView), min: visibleHeaderHeight, max: headerHeight)
                    visibleFooterHeight = trim(overContentTopDistance(of: scrollView), min: visibleFooterHeight, max: footerHeight)
//                    updateLayout(withDuration: 0)
                } else if overContentBottomDistance(of: scrollView) >= visibleFooterHeight {
                    visibleHeaderHeight = trim(overContentBottomDistance(of: scrollView), min: visibleHeaderHeight, max: headerHeight)
                    visibleFooterHeight = trim(overContentBottomDistance(of: scrollView), min: visibleFooterHeight, max: footerHeight)
//                    updateLayout(withDuration: 0)
                }

            default:
                break
            }

        default:
            break
        }
    }


}

// MARK: - Private Method

private extension AutoToggleHeaderFooterView {
    func overContentTopDistance(of scrollView: UIScrollView) -> CGFloat {
        return -(scrollView.contentOffset.y + scrollView.contentInset.top - headerHeight)
    }

    func overContentBottomDistance(of scrollView: UIScrollView) -> CGFloat {
        return scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentSize.height
    }

    func setupHeaderFooterConstraints() {
        if let header = header {
            header.translatesAutoresizingMaskIntoConstraints = false
            headerTopConstraint = Constraint.make(self, .top, .equal, to: header, .top)
            headerHeightConstraint = Constraint.make(header, height: .equal, to: headerHeight)

            addConstraints([
                headerTopConstraint!,
                headerHeightConstraint!,
                Constraint.make(header, .left, .equal, to: self, .left),
                Constraint.make(header, .right, .equal, to: self, .right),
                ])
        }

        if let footer = footer {
            footer.translatesAutoresizingMaskIntoConstraints = false
            footerBottomConstraint = Constraint.make(footer, .bottom, .equal, to: self, .bottom)
            footerHeightConstraint = Constraint.make(footer, height: .equal, to: footerHeight)

            addConstraints([
                footerBottomConstraint!,
                footerHeightConstraint!,
                Constraint.make(footer, .left, .equal, to: self, .left),
                Constraint.make(footer, .right, .equal, to: self, .right),
                ])
        }
    }

    func updateLayout(withDuration duration: TimeInterval, completion: (() -> Void)? = nil) {
        guard duration != 0 else {
            layoutIfNeeded()
            completion?()
            return
        }

        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }

    func resetAutoShowTimer() {
        autoShowTimer?.invalidate()
        autoShowTimer = Timer.scheduledTimer(timeInterval: autoShowTimeInterval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }

    func trim(_ distance: CGFloat, min _min: CGFloat, max _max: CGFloat) -> CGFloat {
        return max(min(distance, _max), _min)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension AutoToggleHeaderFooterView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}

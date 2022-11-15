//
//  TwoPageViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

protocol TwoPageControllerDelegate: AnyObject {
    func switchedToPage(index: Int)
}

protocol TwoPageProtocol {
    func set(delegate: TwoPageControllerDelegate)
    func set(viewControllers: [UIViewController])
    func switchToSecondTab()
    func switchToFirstTab()
}

class TwoPageViewController: UIPageViewController,
                             UIPageViewControllerDataSource,
                             UIPageViewControllerDelegate,
                             TwoPageProtocol {

    private var contentViewControllers: [UIViewController]?
    private weak var twoPageControllerDelegate: TwoPageControllerDelegate?

    private var nextIndex: Int = 0
    private var currentIndex: Int = 0

    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    func set(delegate: TwoPageControllerDelegate) {
        twoPageControllerDelegate = delegate
    }

    func set(viewControllers: [UIViewController]) {
        guard viewControllers.count == 2 else {
            fatalError("Must initialise TwoPageViewController with two pages only")
        }

        dataSource = self
        contentViewControllers = viewControllers
        setViewControllers([viewControllers.first!],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }

    func switchToSecondTab() {
        guard contentViewControllers != nil,
            contentViewControllers!.count > 1,
            let secondVC = contentViewControllers?[1] else {
                return
        }

        setViewControllers([secondVC],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        twoPageControllerDelegate?.switchedToPage(index: 1)
    }

    func switchToFirstTab() {
        guard contentViewControllers != nil,
            contentViewControllers!.count > 0,
            let firstVC = contentViewControllers?[0] else {
                return
        }

        setViewControllers([firstVC],
                            direction: .reverse,
                            animated: true,
                            completion: nil)
        twoPageControllerDelegate?.switchedToPage(index: 0)
    }

    // MARK: UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        let nextController = pendingViewControllers.first
        nextIndex = indexOfItem(item: nextController!)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed {
            currentIndex = nextIndex
            twoPageControllerDelegate?.switchedToPage(index: currentIndex)
        }
        nextIndex = 0
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.indexOfItem(item: viewController)
        return viewAtIndex(index: index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.indexOfItem(item: viewController)
        return viewAtIndex(index: index + 1)
    }

    // MARK: Auxiliary methods

    func viewAtIndex(index: Int) -> UIViewController? {
        if index < 0 {
            return nil
        }

        if index >= contentViewControllers!.count {
            return nil
        }
        return contentViewControllers![index]
    }

    func indexOfItem(item: UIViewController) -> Int {
        guard let index = self.contentViewControllers?.firstIndex(of: item) else {
            return NSNotFound
        }
        return index
    }
}

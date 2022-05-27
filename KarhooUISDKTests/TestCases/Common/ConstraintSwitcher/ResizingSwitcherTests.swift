//
//  ResizingSwitcherTests.swift
//  ConstraintSwitcher
//
//
//  Copyright © 2016 Bespoke Code AB. All rights reserved.
//

import XCTest
@testable import KarhooUISDK

private typealias LoadConstraintsArgumentTuple =
    (primaryConstraints: [NSLayoutConstraint],
     primaryTag: Int,
     secondaryConstraints: [NSLayoutConstraint],
     secondaryTag: Int)

private typealias ActivateConstraintWithTagArgumentTuple =
    (tag: Int, animated: Bool, completion: ConstraintSwitcherCompletedClosure?)

class ResizingSwitcherTests: KarhooTestCase {

    fileprivate var testTuple: (testObject: ResizingSwitcher, constraintSwitcher: TestConstraintSwitcher)?

    override func setUp() {
        super.setUp()
        let constraintSwitcher = TestConstraintSwitcher()

        let expandedConstraints = [NSLayoutConstraint()]
        let contractedConstraints = [NSLayoutConstraint()]

        let testObject = ResizingSwitcher(constraintSwitcher: constraintSwitcher)
        testObject.expandedConstraints = expandedConstraints
        testObject.contractedConstraints = contractedConstraints

        self.testTuple = (testObject: testObject, constraintSwitcher: constraintSwitcher)
    }

    override func tearDown() {
        self.testTuple = nil
    }

    // MARK: - Test expand

    /**
     * Given:   A basic ResizingSwitcher setup (i.e. with a constraint switcher)
     * When:    Expanding through IBAction
     * Then:    The constraint switcher is loaded and the correct constraints
     *          are activated with animation
     */
    func testExpandAction() {
        var loadConstraintsTestPassed = false
        var activateConstraintTestPassed = false

        self.testTuple?.constraintSwitcher.loadConstraintsClosure = {(argumentTuple: LoadConstraintsArgumentTuple) in
            loadConstraintsTestPassed = self.areCorrectConstraintsLoaded(argumentTuple)
        }

        self.testTuple?.constraintSwitcher.activateConstraintWithTagClosure = {(argumentTuple: ActivateConstraintWithTagArgumentTuple) in
            let isCorrectTag = ResizingSwitcher.ResizeTag.expanded.rawValue == argumentTuple.tag
            let isCorrectAnimationFlag = argumentTuple.animated == true

            activateConstraintTestPassed = isCorrectTag && isCorrectAnimationFlag
        }

        self.testTuple?.testObject.expand()

        XCTAssertTrue(loadConstraintsTestPassed)
        XCTAssertTrue(activateConstraintTestPassed)
    }

    /**
     * Given:   A basic ResizingSwitcher setup (i.e. with a constraint switcher)
     * When:    Expand called with no animation
     * Then:    The constraint switcher is loaded and the correct constraints
     *          are activated without animation
     */
    func testExpandNonAnimated() {
        var animationCorrect = false

        self.testTuple?.constraintSwitcher.activateConstraintWithTagClosure = {(argumentTuple: ActivateConstraintWithTagArgumentTuple) in
            animationCorrect = argumentTuple.animated == false
        }

        self.testTuple?.testObject.expand(animated: false)

        XCTAssertTrue(animationCorrect)
    }

    // MARK: - Test contract

    /**
     * Given:   A basic ResizingSwitcher setup (i.e. with a constraint switcher)
     * When:    Contracting through IBAction
     * Then:    The constraint switcher is loaded and the correct constraints
     *          are activated with animation
     */
    func testContractAction() {
        var loadConstraintsTestPassed = false
        var activateConstraintTestPassed = false

        self.testTuple?.constraintSwitcher.loadConstraintsClosure = {(argumentTuple: LoadConstraintsArgumentTuple) in
            loadConstraintsTestPassed = self.areCorrectConstraintsLoaded(argumentTuple)
        }

        self.testTuple?.constraintSwitcher.activateConstraintWithTagClosure = {(argumentTuple: ActivateConstraintWithTagArgumentTuple) in
            let isCorrectTag = ResizingSwitcher.ResizeTag.contracted.rawValue == argumentTuple.tag
            let isCorrectAnimationFlag = argumentTuple.animated == true

            activateConstraintTestPassed = isCorrectTag && isCorrectAnimationFlag
        }

        self.testTuple?.testObject.contract()

        XCTAssertTrue(loadConstraintsTestPassed)
        XCTAssertTrue(activateConstraintTestPassed)
    }

    /**
     * Given:   A basic ResizingSwitcher setup (i.e. with a constraint switcher)
     * When:    Contract called with no animation
     * Then:    The constraint switcher is loaded and the correct constraints
     *          are activated without animation
     */
    func testContractNonAnimated() {
        var animationCorrect = false

        self.testTuple?.constraintSwitcher.activateConstraintWithTagClosure = {(argumentTuple: ActivateConstraintWithTagArgumentTuple) in
            animationCorrect = argumentTuple.animated == false
        }

        self.testTuple?.testObject.contract(animated: false)

        XCTAssertTrue(animationCorrect)
    }

    // MARK: - Test check if expanded

    /**
     * Given:   That the expanded constraints are active
     * When:    Checking if expanded
     * Then:    Should be true
     */
    func testCheckIfActuallyExpanded() {

        let isExpanded = true
        self.testTuple?.constraintSwitcher.isConstraintActiveClosure = { _ in
            return isExpanded
        }

        let check = self.testTuple?.testObject.isExpanded()
        XCTAssertEqual(isExpanded, check)
    }

    /**
     * Given:   That the contracted constraints are active
     * When:    Checking if expanded
     * Then:    Should be false
     */
    func testCheckIfNotExpanded() {

        let isExpanded = false
        self.testTuple?.constraintSwitcher.isConstraintActiveClosure = { _ in
            return isExpanded
        }

        let check = self.testTuple?.testObject.isExpanded()
        XCTAssertEqual(isExpanded, check)
    }

    // MARK: - Test toggle

    /**
     * Given:   That the expanded constraints are active
     * When:    Toggling
     * Then:    The contracted constraints should become active
     */
    func testToggleWhenExpanded() {

        let isExpanded = true
        self.testTuple?.constraintSwitcher.isConstraintActiveClosure = { _ in
            return isExpanded
        }

        var correctTagSet = false
        self.testTuple?.constraintSwitcher.activateConstraintWithTagClosure = {(argumentTuple: ActivateConstraintWithTagArgumentTuple) in
            correctTagSet = argumentTuple.tag == ResizingSwitcher.ResizeTag.contracted.rawValue
        }

        self.testTuple?.testObject.toggle()
        XCTAssertTrue(correctTagSet)
    }

    /**
     * Given:   That the contracted constraints are active
     * When:    Toggling
     * Then:    The expanded constraints should become active
     */
    func testToggleWhenContracted() {

        let isExpanded = false
        self.testTuple?.constraintSwitcher.isConstraintActiveClosure = { _ in
            return isExpanded
        }

        var correctTagSet = false
        self.testTuple?.constraintSwitcher.activateConstraintWithTagClosure = {(argumentTuple: ActivateConstraintWithTagArgumentTuple) in
            correctTagSet = argumentTuple.tag == ResizingSwitcher.ResizeTag.expanded.rawValue
        }

        self.testTuple?.testObject.toggle()
        XCTAssertTrue(correctTagSet)
    }

    // MARK: - Private function

    fileprivate func areCorrectConstraintsLoaded(_ argumentTuple: LoadConstraintsArgumentTuple) -> Bool {
        guard let expandedConstraints = self.testTuple?.testObject.expandedConstraints else {
            return false
        }

        guard let contractedConstraints = self.testTuple?.testObject.contractedConstraints else {
            return false
        }

        let isCorrectExpandedConstraints = expandedConstraints == argumentTuple.primaryConstraints
        let isCorrectExpandedTag = ResizingSwitcher.ResizeTag.expanded.rawValue == argumentTuple.primaryTag

        let isCorrectContractedConstraints = contractedConstraints == argumentTuple.secondaryConstraints
        let isCorrectContractedTag = ResizingSwitcher.ResizeTag.contracted.rawValue == argumentTuple.secondaryTag

        return isCorrectExpandedConstraints &&
               isCorrectExpandedTag &&
               isCorrectContractedConstraints &&
               isCorrectContractedTag
    }

}

private final class TestConstraintSwitcher: ConstraintSwitcher {

    var animationTimeSet: Double?
    func set(animationTime: Double) {
        animationTimeSet = animationTime
    }

    var loadConstraintsClosure: ((LoadConstraintsArgumentTuple) -> Void)?
    func loadConstraints(primaryConstraints: [NSLayoutConstraint],
                         primaryTag: Int,
                         secondaryConstraints: [NSLayoutConstraint],
                         secondaryTag: Int) {
        self.loadConstraintsClosure?((primaryConstraints: primaryConstraints,
                                     primaryTag: primaryTag,
                                     secondaryConstraints: secondaryConstraints,
                                     secondaryTag: secondaryTag))
    }

    var switchConstraintsClosure: ((_ animated: Bool, _ completion: ConstraintSwitcherCompletedClosure?) -> Void)?
    func switchConstraints(animated: Bool, completion: ConstraintSwitcherCompletedClosure?) {
    }

    var activateConstraintWithTagClosure: ((ActivateConstraintWithTagArgumentTuple) -> Void)?
    func activateConstraintWithTag(tag: Int, animated: Bool, completion: ConstraintSwitcherCompletedClosure?) {
        self.activateConstraintWithTagClosure?((tag: tag, animated: animated, completion: completion))
    }

    var isConstraintActiveClosure: ((Int?) -> (Bool))?
    func isConstraintActive(tag: Int?) -> Bool {
        return self.isConstraintActiveClosure?(tag) == true
    }
}

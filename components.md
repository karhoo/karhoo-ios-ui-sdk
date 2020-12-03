
# Components Guide

As well as UIViewControllers the SDK offers the UIViews that make up its UIViewControllers. This can be helpful if you want to have more control over your end users experience, or integrate very specific features into your app, such as choosing addresses or booking an existing quote. Avialable components are found in ```karhooUI.components```.


## Address Bar
The Address Bar allows a user to select a pickup and drop off address. The details are observed by all other components which will react accordingly as the user adds details.


```swift
import KarhooUISDK

// create address bar
private var addressBar: AddressBarView!

// initialise it (load view)
addressBar = KarhooUI.components.addressBar(journeyInfo: nil) //prefill component with data. eg a pickup address

// setup constraints on the component and add to subview
view.addSubview(addressBar)
_ = [addressBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
     addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, 
                                         constant: 10.0),
     addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                          constant: -10.0)].map { $0.isActive = true }
```


## Quote List
The QuoteList component searches and displays quotes based on the current booking details. It has a delegate to handle when the user selects a quote.

```swift
import KarhooUISDK

// create quote list
private lazy var quoteList: QuoteListView = {
   let quoteList = KarhooUI.components.quoteList()
   quoteList.set(quoteListActions: self)
   return quoteList
}()

// QuoteList component is a view controller so it must be contained to be embedded
private lazy var quoteListContainer: UIView = {
   let container = UIView()
   container.translatesAutoresizingMaskIntoConstraints = false
   container.isHidden = true
   return container
 }()

// add constraints and subview
[quoteListContainer.heightAnchor.constraint(equalToConstant: 400),
quoteListContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
quoteListContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach { constraint in
            constraint.isActive = true
         }

addChild(quoteList)
quoteListContainer.addSubview(quoteList.view)
quoteList.view.pinEdges(to: quoteListContainer)
quoteList.didMove(toParent: self)

//Quote List action output

// Quote list component output
extension YourViewController: QuoteListActions {
    func quotesAvailabilityDidUpdate(availability: Bool) {
        print("quotesAvailabilityDidUpdate: ", availability)
    }

    func didSelectQuote(_ quote: Quote) {
        print("user selected quote: ", quote)
    }
}

```

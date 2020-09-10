# CardViewController

A simple implementation of iOS' AirPods setup UI.

```
// Initialise using a size configuration, or use .default (see SizeConfiguration.swfit for details).
let cardController = CardViewController(size: .default)

// Set the title of the card
cardController.setTitle("This is an example", color: .white)

// Embed any view controller as the content of the card.
cardController.embed(someViewController)

// Add a primary button (the big blue button), with text and an action.
cardController.setPrimaryAction("Done") {
    // Do something, dismiss it…
    cardController.dismiss(animated: true, completion: nil)
}

// Finally, present it to the user :-)
present(cardController, animated: true, completion: nil)
```

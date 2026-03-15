# AsyncQueue

A FIFO queue to which your application can submit async jobs. Jobs are executed serially, so order is guaranteed and the next job doesn't start until the previous one finishes.

## Usage

```swift
let queue = AsyncQueue()

queue.enqueue {
    await sendMessage(messageOne)
}

queue.enqueue {
    await sendMessage(messageTwo)
}

// sendMessage(messageOne) executes before sendMessage(messageTwo)
```

## Installation

Add AsyncQueue to your project via Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/salnav/AsyncQueue.git", from: "1.0.0")
]
```


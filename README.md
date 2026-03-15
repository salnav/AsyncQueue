# AsyncQueue

An object that executes async jobs serially.

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
    .package(url: "https://github.com/YOUR_USERNAME/AsyncQueue.git", from: "1.0.0")
]
```

## API

### `AsyncQueue(priority: TaskPriority? = nil)`

Creates a new queue. Optionally set the task priority for job execution.

### `enqueue(_ job: @escaping () async -> Void)`

Enqueues a job for serial execution.

### `flush()`

Discards all pending jobs and resets the queue for new work.

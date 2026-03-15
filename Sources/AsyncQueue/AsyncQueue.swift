//
//  AsyncQueue.swift
//  AsyncQueue
//
//  Created by Salman Navroz on 3/14/26.
//

/// An object that executes async jobs serially.
///
/// A FIFO queue to which your application can submit
/// async jobs. Jobs are executed serially, so order is
/// guaranteed and the next job doesn't start until
/// the previous job finishes.
///
/// ```swift
/// let queue = AsyncQueue()
///
/// queue.enqueue {
///     await sendMessage(messageOne)
/// }
///
/// queue.enqueue {
///     await sendMessage(messageTwo)
/// }
///
/// // sendMessage(messageOne) executes before sendMessage(messageTwo)
/// ```
public final class AsyncQueue: @unchecked Sendable {
    // MARK: - Properties

    public let priority: TaskPriority?

    private var continuation: AsyncStream<() async -> Void>.Continuation
    private var processJobsTask: Task<Void, Never>

    // MARK: - Init

    public init(priority: TaskPriority? = nil) {
        self.priority = priority

        let (jobStream, continuation) = AsyncStream<() async -> Void>.makeStream()
        self.continuation = continuation

        processJobsTask = Task(priority: priority) { [jobStream] in
            for await job in jobStream {
                await job()
            }
        }
    }

    deinit {
        cancelStream()
    }
}

// MARK: - Public API

extension AsyncQueue {
    /// Enqueues a job onto the queue for serial execution.
    ///
    /// - Parameter job: An async closure to execute.
    public func enqueue(_ job: @escaping () async -> Void) {
        continuation.yield(job)
    }

    /// Discards all pending jobs and resets the queue for new work.
    public func flush() {
        cancelStream()

        let (jobStream, continuation) = AsyncStream<() async -> Void>.makeStream()
        self.continuation = continuation

        processJobsTask = createConsumingTask(from: jobStream)
    }
}

// MARK: - Helpers

extension AsyncQueue {
    private func cancelStream() {
        continuation.finish()
        processJobsTask.cancel()
    }

    private func createConsumingTask(
        from jobStream: AsyncStream<() async -> Void>
    ) -> Task<Void, Never> {
        Task(priority: priority) { [jobStream] in
            for await job in jobStream {
                await job()
            }
        }
    }
}


// =====================================================
// TASK NORMALIZER CODE
// Created by: Antonio Atamosa Jr
// Date: 2026-02-11
// Version: 1.0.0
// =====================================================
import Foundation


enum TaskStatus: String, Codable {
    case pending
    case done
    
    static func from(_ raw: String?) -> TaskStatus {
        guard let raw = raw?.lowercased().trimmingCharacters(in: .whitespaces),
              !raw.isEmpty else {
            return .pending
        }
        return TaskStatus(rawValue: raw) ?? .pending
    }
}

struct TaskItem: Hashable, CustomStringConvertible {
    let id: String
    let title: String
    let programID: String
    let day: Int?
    let position: Int
    let status: TaskStatus
    let updatedAt: Date
    
    /// Sort key: (day, position, updatedAt timestamp)
    /// Tasks with nil day are sorted last
    func sortKey() -> (Int, Int, TimeInterval) {
        (day ?? Int.max, position, updatedAt.timeIntervalSince1970)
    }
    
    var description: String {
        let dayStr = day.map { "\($0)" } ?? "nil"
        return "TaskItem(id: \(id), title: \"\(title)\", day: \(dayStr), pos: \(position), status: \(status.rawValue))"
    }
}

// =====================================================
// DATA TRANSFER OBJECT
// =====================================================

struct APITask: Codable {
    let taskID: String?
    let title: String?
    let programID: String?
    let day: Int?
    let position: Int?
    let status: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case taskID = "task_id"
        case title
        case programID = "program_id"
        case day
        case position
        case status
        case updatedAt = "updated_at"
    }
}

// =====================================================
// Date parsing
// =====================================================

protocol DateParserProtocol {
    func parse(_ raw: String?) -> Date
}

final class ISO8601DateParser: DateParserProtocol {
    private let primaryFormatter: ISO8601DateFormatter
    private let fallbackFormatter: ISO8601DateFormatter
    
    init() {
        self.primaryFormatter = ISO8601DateFormatter()
        primaryFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        self.fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]
    }
    
    func parse(_ raw: String?) -> Date {
        guard let raw = raw?.trimmingCharacters(in: .whitespaces),
              !raw.isEmpty else {
            return Date.distantPast
        }
        
        // Try with fractional seconds first
        if let date = primaryFormatter.date(from: raw) {
            return date
        }
        
        // Fallback to without fractional seconds
        if let date = fallbackFormatter.date(from: raw) {
            return date
        }
        
        // If all parsing fails, return distant past
        return Date.distantPast
    }
}

// =====================================================
// SOLID: Single Responsibility Principle
// Task validation is separated into its own protocol/implementation
// =====================================================

protocol TaskValidatorProtocol {
    func isValid(_ task: APITask) -> Bool
}

final class TaskValidator: TaskValidatorProtocol {
    func isValid(_ task: APITask) -> Bool {
        guard let taskID = task.taskID,
              !taskID.isEmpty,
              let programID = task.programID,
              !programID.isEmpty else {
            return false
        }
        return true
    }
}

// =====================================================
// Task merging strategy is separated into its own protocol
// =====================================================

protocol TaskMergeStrategyProtocol {
    func merge(_ versions: [APITask]) -> APITask?
}

final class BestDataMergeStrategy: TaskMergeStrategyProtocol {
    private let dateParser: DateParserProtocol
    
    init(dateParser: DateParserProtocol) {
        self.dateParser = dateParser
    }
    
    func merge(_ versions: [APITask]) -> APITask? {
        guard !versions.isEmpty else { return nil }
        
        // Sort by updatedAt (newest first) to prioritize recent data
        let sortedVersions = versions.sorted { v1, v2 in
            dateParser.parse(v1.updatedAt) > dateParser.parse(v2.updatedAt)
        }
        
        // Start with the newest version as base
        var bestTask = sortedVersions.first!
        
        // Merge missing fields from other versions
        for version in sortedVersions.dropFirst() {
            bestTask = mergeTask(bestTask, with: version)
        }
        
        return bestTask
    }
    
    private func mergeTask(_ base: APITask, with other: APITask) -> APITask {
        // Prefer base values, but use other if base is nil/empty
        let mergedTitle = base.title?.isEmpty == false ? base.title : other.title
        let mergedDay = base.day ?? other.day
        let mergedPosition = base.position ?? other.position
        let mergedStatus = base.status ?? other.status
        
        // Use the most recent updatedAt
        let baseDate = dateParser.parse(base.updatedAt)
        let otherDate = dateParser.parse(other.updatedAt)
        let mergedUpdatedAt = baseDate >= otherDate ? base.updatedAt : other.updatedAt
        
        return APITask(
            taskID: base.taskID ?? other.taskID,
            title: mergedTitle,
            programID: base.programID ?? other.programID,
            day: mergedDay,
            position: mergedPosition,
            status: mergedStatus,
            updatedAt: mergedUpdatedAt
        )
    }
}

// =====================================================
// Status merging is separated into its own protocol
// =====================================================

protocol StatusMergeStrategyProtocol {
    func merge(_ versions: [APITask]) -> TaskStatus
}

final class PreferDoneStatusStrategy: StatusMergeStrategyProtocol {
    func merge(_ versions: [APITask]) -> TaskStatus {
        let hasDone = versions.contains { task in
            TaskStatus.from(task.status) == .done
        }
        
        if hasDone {
            return .done
        }
        
        return TaskStatus.from(versions.first?.status)
    }
}

// =====================================================
// Task factory is responsible only for creating Task from APITask
// =====================================================

protocol TaskFactoryProtocol {
    func create(from apiTask: APITask, status: TaskStatus) -> TaskItem?
}

final class TaskFactory: TaskFactoryProtocol {
    private let dateParser: DateParserProtocol
    
    init(dateParser: DateParserProtocol) {
        self.dateParser = dateParser
    }
    
    func create(from apiTask: APITask, status: TaskStatus) -> TaskItem? {
        guard let taskID = apiTask.taskID, !taskID.isEmpty,
              let programID = apiTask.programID, !programID.isEmpty else {
            return nil
        }
        
        let title = apiTask.title?.trimmingCharacters(in: .whitespaces).isEmpty == false
            ? apiTask.title!.trimmingCharacters(in: .whitespaces)
            : "Untitled Task"
        
        return TaskItem(
            id: taskID,
            title: title,
            programID: programID,
            day: apiTask.day,
            position: apiTask.position ?? Int.max,
            status: status,
            updatedAt: dateParser.parse(apiTask.updatedAt)
        )
    }
}

// =====================================================
// Task sorter is responsible only for sorting
// =====================================================

protocol TaskSorterProtocol {
    func sort(_ tasks: [TaskItem]) -> [TaskItem]
}

final class TaskSorter: TaskSorterProtocol {
    func sort(_ tasks: [TaskItem]) -> [TaskItem] {
        return tasks.sorted { $0.sortKey() < $1.sortKey() }
    }
}

// =====================================================
// TaskNormalizer for the normalization process
// =====================================================

protocol TaskNormalizerProtocol {
    func normalize(_ apiTasks: [APITask]) -> [TaskItem]
}

final class TaskNormalizer: TaskNormalizerProtocol {
    private let validator: TaskValidatorProtocol
    private let mergeStrategy: TaskMergeStrategyProtocol
    private let statusStrategy: StatusMergeStrategyProtocol
    private let taskFactory: TaskFactoryProtocol
    private let sorter: TaskSorterProtocol
    
    init(
        validator: TaskValidatorProtocol,
        mergeStrategy: TaskMergeStrategyProtocol,
        statusStrategy: StatusMergeStrategyProtocol,
        taskFactory: TaskFactoryProtocol,
        sorter: TaskSorterProtocol
    ) {
        self.validator = validator
        self.mergeStrategy = mergeStrategy
        self.statusStrategy = statusStrategy
        self.taskFactory = taskFactory
        self.sorter = sorter
    }
    
    /// Normalizes and cleans task data from API
    /// - Removes duplicates by task_id
    /// - Merges multiple versions of the same task (keeps best data)
    /// - Handles missing/null/invalid fields safely
    /// - Returns sorted tasks ready for display
    func normalize(_ apiTasks: [APITask]) -> [TaskItem] {
        let validTasks = apiTasks.filter { validator.isValid($0) }
        let grouped = Dictionary(grouping: validTasks) { task in
            task.taskID ?? UUID().uuidString
        }
        
        var normalizedTasks: [TaskItem] = []
        
        // Process each group of duplicate tasks
        for (_, versions) in grouped {
            guard let mergedAPITask = mergeStrategy.merge(versions) else { continue }
            
            let finalStatus = statusStrategy.merge(versions)
            
            guard let task = taskFactory.create(from: mergedAPITask, status: finalStatus) else {
                continue
            }
            
            normalizedTasks.append(task)
        }
        
        return sorter.sort(normalizedTasks)
    }
}

// =====================================================
// NETWORK LAYER
// =====================================================

protocol TaskServiceProtocol {
    func fetchDailyTasks() async throws -> [APITask]
}

final class MockTaskService: TaskServiceProtocol {
    enum Sample { case clean, dirty }
    private let sample: Sample
    
    init(sample: Sample) {
        self.sample = sample
    }
    
    func fetchDailyTasks() async throws -> [APITask] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 400_000_000)
        
        switch sample {
        case .clean: return sampleATasks()
        case .dirty: return sampleBTasks()
        }
    }
}

// =====================================================
// CACHE LAYER
// =====================================================

protocol TaskCacheProtocol {
    func save(_ tasks: [TaskItem])
    func load() -> [TaskItem]
}

final class MemoryTaskCache: TaskCacheProtocol {
    private var storage: [TaskItem] = []
    
    func save(_ tasks: [TaskItem]) {
        storage = tasks
    }
    
    func load() -> [TaskItem] {
        storage
    }
}

// =====================================================
// USE CASE
// =====================================================

protocol GetTodayTasksUseCaseProtocol {
    func execute(networkAvailable: Bool) async -> [TaskItem]
}

final class GetTodayTasksUseCase: GetTodayTasksUseCaseProtocol {
    private let service: TaskServiceProtocol
    private let cache: TaskCacheProtocol
    private let normalizer: TaskNormalizerProtocol
    
    init(
        service: TaskServiceProtocol,
        cache: TaskCacheProtocol,
        normalizer: TaskNormalizerProtocol
    ) {
        self.service = service
        self.cache = cache
        self.normalizer = normalizer
    }
    
    /// Fetches and normalizes today's tasks
    /// - Parameter networkAvailable: Whether network is available or Offline
    /// - Returns: Clean, sorted list of tasks
    func execute(networkAvailable: Bool) async -> [TaskItem] {
        guard networkAvailable else {
            print(" Offline and using cached tasks")
            let cached = cache.load()
            if cached.isEmpty {
                print("No cached tasks available")
            }
            return cached
        }
        
        do {
            let apiTasks = try await service.fetchDailyTasks()
            let normalized = normalizer.normalize(apiTasks)
            cache.save(normalized)
            print("Fetched \(normalized.count) tasks from API")
            return normalized
        } catch {
            print("Network error: \(error.localizedDescription)")
            print("   → Falling back to cache")
            return cache.load()
        }
    }
}

// =====================================================
// VIEW MODEL
// =====================================================

final class TodayTasksViewModel {
    private let useCase: GetTodayTasksUseCaseProtocol
    private(set) var tasks: [TaskItem] = []
    
    init(useCase: GetTodayTasksUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func load(networkAvailable: Bool) async {
        tasks = await useCase.execute(networkAvailable: networkAvailable)
    }
}

// =====================================================
// FACTORY: Creates dependencies
// =====================================================

final class TaskNormalizerFactory {
    static func create() -> TaskNormalizerProtocol {
        let dateParser = ISO8601DateParser()
        let validator = TaskValidator()
        let mergeStrategy = BestDataMergeStrategy(dateParser: dateParser)
        let statusStrategy = PreferDoneStatusStrategy()
        let taskFactory = TaskFactory(dateParser: dateParser)
        let sorter = TaskSorter()
        
        return TaskNormalizer(
            validator: validator,
            mergeStrategy: mergeStrategy,
            statusStrategy: statusStrategy,
            taskFactory: taskFactory,
            sorter: sorter
        )
    }
}

// =====================================================
// MOCK DATA FOR TESTING
// =====================================================

func sampleATasks() -> [APITask] {
    [
        APITask(
            taskID: "t_01",
            title: "Neck mobility",
            programID: "p_1",
            day: 3,
            position: 1,
            status: "pending",
            updatedAt: "2026-02-10T07:10:00Z"
        ),
        APITask(
            taskID: "t_02",
            title: "Chin tucks",
            programID: "p_1",
            day: 3,
            position: 2,
            status: "done",
            updatedAt: "2026-02-10T08:05:00Z"
        ),
        APITask(
            taskID: "t_03",
            title: "Posture reset",
            programID: "p_2",
            day: 1,
            position: 1,
            status: "pending",
            updatedAt: "2026-02-10T06:50:00Z"
        )
    ]
}

func sampleBTasks() -> [APITask] {
    [
        APITask(
            taskID: "t_01",
            title: "Neck mobility",
            programID: "p_1",
            day: 3,
            position: 1,
            status: "pending",
            updatedAt: "2026-02-10T07:10:00Z"
        ),
        APITask(
            taskID: "t_01",
            title: nil,
            programID: "p_1",
            day: 3,
            position: 1,
            status: "done",
            updatedAt: "2026-02-10T08:30:00Z"
        ),
        APITask(
            taskID: "t_02",
            title: nil,
            programID: "p_1",
            day: 3,
            position: 2,
            status: "done",
            updatedAt: "2026-02-10T08:05:00Z"
        ),
        APITask(
            taskID: "t_03",
            title: nil,
            programID: "p_2",
            day: 1,
            position: 1,
            status: "pending",
            updatedAt: "2026-02-10T06:50:00Z"
        ),
        APITask(
            taskID: "t_04",
            title: "Stretch",
            programID: "p_2",
            day: nil,
            position: 2,
            status: "pending",
            updatedAt: "invalid-date"
        )
    ]
}

// =====================================================
// TEST RUNNER
// =====================================================

func runTests() async {
    // SOLID: Dependency Inversion - using abstractions
    let cache = MemoryTaskCache()
    let normalizer = TaskNormalizerFactory.create()
    
    print("NECKLO TASK NORMALIZER TEST")
    
    // Test Sample A (Clean)
    print("\n TEST 1: Sample A (Clean JSON)")
    let serviceA = MockTaskService(sample: .clean)
    let useCaseA = GetTodayTasksUseCase(
        service: serviceA,
        cache: cache,
        normalizer: normalizer
    )
    let viewModelA = TodayTasksViewModel(useCase: useCaseA)
    await viewModelA.load(networkAvailable: true)
    
    if viewModelA.tasks.isEmpty {
        print("No tasks returned")
    } else {
        viewModelA.tasks.enumerated().forEach { index, task in
            print("   \(index + 1). \(task)")
        }
    }
    
    // Test Sample B (Dirty)
    print("\n TEST 2: Sample B (Dirty JSON)")
    let serviceB = MockTaskService(sample: .dirty)
    let useCaseB = GetTodayTasksUseCase(
        service: serviceB,
        cache: cache,
        normalizer: normalizer
    )
    let viewModelB = TodayTasksViewModel(useCase: useCaseB)
    await viewModelB.load(networkAvailable: true)
    
    if viewModelB.tasks.isEmpty {
        print("No tasks returned")
    } else {
        viewModelB.tasks.enumerated().forEach { index, task in
            print("   \(index + 1). \(task)")
        }
    }
    
    // Test Offline Mode
    print("\nTEST 3: Offline Mode (Using Cache)")
    await viewModelB.load(networkAvailable: false)
    
    if viewModelB.tasks.isEmpty {
        print(" No cached tasks available")
    } else {
        viewModelB.tasks.enumerated().forEach { index, task in
            print("   \(index + 1). \(task)")
        }
    }
}

// Run the tests
let semaphore = DispatchSemaphore(value: 0)
Task {
    await runTests()
    semaphore.signal()
}
semaphore.wait()

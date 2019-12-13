//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct Pipeline<Input, Output>: CustomStringConvertible {
    let description: String

    let runContext: RunContext
    private let _getOutput: (Input) throws -> Output

    fileprivate init(
        runContext: RunContext,
        description: String,
//        latestCached: @escaping () -> Any,
        result: @escaping (Input) throws -> Output
    ) {
        self.runContext = runContext
        self.description = description
        self._getOutput = result
    }
}

// MARK: Init+FunctionBuilder
extension Pipeline {
    init<A, B, C>(runContext: RunContext, _ a: A, _ b: B, _ c: C)
        where
        A: CacheableJob, B: CacheableJob, C: CacheableJob,
        A.Input == Input,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == Output
    {

        let startAtStepUnbound = runContext.startAtStep ?? 255
        let namedTasks: [NamedTask] = [a, b, c]
        let startAtStep: UInt8 = UInt8(min(startAtStepUnbound, namedTasks.count))
        let description: String = descriptionOf(jobs: namedTasks)


        self.init(
            runContext: runContext,
            description: description
        ) { (input: Input) in

            func cachedFrom<J>(_ job: J) -> J.Output? where J: CacheableJob {
                try? job.cachedIfValid()
            }
            let cachedA = cachedFrom(a)
            let cachedB = cachedFrom(b)
            let cachedC = cachedFrom(c)

            switch startAtStep {
                case 0: return try (cachedA ?? (input |> a)) |> b |> c
                case 1: return try (cachedB ?? (input |> a |> b)) |> c
                case 2...255: return try cachedC ?? (input |> a |> b |> c)
                default: fatalError()
            }
        }
    }
}

// MARK: CacheableJob
extension Pipeline {
    func runJobs(input: Input) throws -> Output {
        try _getOutput(input)
    }
}

extension Pipeline where Input == RunContext {
    func runJobs() throws -> Output {
        try runJobs(input: runContext)
    }
}


// MARK: FunctionBuilder
//@_functionBuilder
//struct BuildPipeline {
//
//    static func buildBlock<A>(_ a: A) -> Pipeline<A.Input, A.Output>
//        where
//        A: CacheableJob
//    {
//        Pipeline(description: descriptionOf(jobs: [a])) { input in
//            try a.work(input: input)
//        }
//    }

//    static func buildBlock<A, B>(_ a: A, _ b: B) -> Pipeline<A.Input, B.Output>
//        where
//        A: CacheableJob, B: CacheableJob,
//        A.Output == B.Input
//    {
//        Pipeline(description: descriptionOf(jobs: [a, b])) {
//            try $0 |> a |> b
//        }
//    }

//    static func buildBlock<A, B, C>(runContext: RunContext, _ a: A, _ b: B, _ c: C) -> Pipeline<A.Input, C.Output>
//        where
//        A: CacheableJob, B: CacheableJob, C: CacheableJob,
//        A.Output == B.Input,
//        B.Output == C.Input
//    {
//        Pipeline(
//            runContext: runContext,
//            description: descriptionOf(jobs: [a, b, c])
//        ) {
//            try $0 |> a |> b |> c
//        }
//    }

//    static func buildBlock<A, B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) -> Pipeline<A.Input, D.Output>
//        where
//        A: CacheableJob, B: CacheableJob, C: CacheableJob, D: CacheableJob,
//        A.Output == B.Input,
//        B.Output == C.Input,
//        C.Output == D.Input
//    {
//
//        Pipeline(description: descriptionOf(jobs: [a, b, c, d])) {
//            try $0 |> a |> b |> c |> d
//        }
//    }
//
//    static func buildBlock<A, B, C, D, E>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> Pipeline<A.Input, E.Output>
//        where
//        A: CacheableJob, B: CacheableJob, C: CacheableJob, D: CacheableJob, E: CacheableJob,
//        A.Output == B.Input,
//        B.Output == C.Input,
//        C.Output == D.Input,
//        D.Output == E.Input
//    {
//        Pipeline(description: descriptionOf(jobs: [a, b, c, d, e])) {
//            try $0 |> a |> b |> c |> d |> e
//        }
//    }
//
//    static func buildBlock<A, B, C, D, E, F>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> Pipeline<A.Input, F.Output>
//        where
//        A: CacheableJob, B: CacheableJob, C: CacheableJob, D: CacheableJob, E: CacheableJob, F: CacheableJob,
//        A.Output == B.Input,
//        B.Output == C.Input,
//        C.Output == D.Input,
//        D.Output == E.Input,
//        E.Output == F.Input
//    {
//        Pipeline(description: descriptionOf(jobs: [a, b, c, d, e, f])) {
//            try $0 |> a |> b |> c |> d |> e |> f
//        }
//    }
//
//    static func buildBlock<A, B, C, D, E, F, G>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> Pipeline<A.Input, G.Output>
//        where
//        A: CacheableJob, B: CacheableJob, C: CacheableJob, D: CacheableJob, E: CacheableJob, F: CacheableJob, G: CacheableJob,
//        A.Output == B.Input,
//        B.Output == C.Input,
//        C.Output == D.Input,
//        D.Output == E.Input,
//        E.Output == F.Input,
//        F.Output == G.Input
//    {
//        Pipeline(description: descriptionOf(jobs: [a, b, c, d, e, f, g])) {
//            try $0 |> a |> b |> c |> d |> e |> f |> g
//        }
//    }
//}

precedencegroup Pipe {
    higherThan: NilCoalescingPrecedence
    associativity: left
    assignment: true
}

infix operator |>: Pipe

//struct Piped<A, B, C> where A: Codable, B: Codable, C: Codable {
//    let head: AnyCacheableJob<A, B>
//    let tail: AnyCacheableJob<B, C>
//}

//enum Piped<Head, Tail> where Tail: Codable {
////    case
//    case tailCached(Tail)
//}

private func |> <J>(input: J.Input, job: J) throws -> J.Output where J: CacheableJob {
    try job.work(input: input)
}

//private func |> <A, B>(jobA: A, jobB: B) throws -> Piped<A.Output, B.Output>
//    where A: CacheableJob, B: CacheableJob, A.Output == B.Input
//{
////    try job.work(input: input)
////    do {
////        let cached = try jobB.cachedIfValid()
////        return Piped<A.Output, B.Output>.tailCached(cached)
////    }
//    fatalError()
//}

private func descriptionOf(jobs: [NamedTask]) -> String {
    jobs.map { $0.nameOfJob }.joined(separator: " |> ")
}



precedencegroup PipeCached {
    higherThan: NilCoalescingPrecedence
    associativity: left
    assignment: true
}

infix operator ~>: PipeCached

//struct Piped<A, B, C> where A: Codable, B: Codable, C: Codable {
//    let head: AnyCacheableJob<A, B>
//    let tail: AnyCacheableJob<B, C>
//}

//enum Piped<Head, Tail> where Tail: Codable {
////    case
//    case tailCached(Tail)
//}

private func ~> <A, B, C>(foo: RunOrLoadCached<A, B>, bar: RunOrLoadCached<B, C>) {
//    try job.work(input: input)
}
struct RunOrLoadCached<In, Out> where Out: Codable {
    let startAtStep: UInt8
    let job: AnyCacheableJob<In, Out>
}

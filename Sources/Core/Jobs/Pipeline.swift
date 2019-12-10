//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct Pipeline<Input, Output>: Job, CustomStringConvertible {
    let description: String
    private let _getOutput: (Input) throws -> Output
    fileprivate init(description: String, _ getOutput: @escaping (Input) throws -> Output) {
        self.description = description
        self._getOutput = getOutput
    }
}

// MARK: Init+FunctionBuilder
extension Pipeline {
    init(@BuildPipeline makePipeline: () -> Self) {
        self = makePipeline()
    }
}

// MARK: Job
extension Pipeline {
    func work(input: Input) throws -> Output {
        return try _getOutput(input)
    }
}


// MARK: FunctionBuilder
@_functionBuilder
struct BuildPipeline {

    static func buildBlock<A>(_ jobA: A) -> Pipeline<A.Input, A.Output>
        where
        A: Job
    {
        Pipeline(description: jobA.name) { input in
            try jobA.work(input: input)
        }
    }

    static func buildBlock<A, B>(_ a: A, _ b: B) -> Pipeline<A.Input, B.Output>
        where
        A: Job, B: Job,
        A.Output == B.Input
    {
        Pipeline(description: descriptionOf(jobs: [a, b])) {
            try $0 |> a |> b
        }
    }

    static func buildBlock<A, B, C>(_ a: A, _ b: B, _ c: C) -> Pipeline<A.Input, C.Output>
        where
        A: Job, B: Job, C: Job,
        A.Output == B.Input,
        B.Output == C.Input
    {
        Pipeline(description: descriptionOf(jobs: [a, b, c])) {
            try $0 |> a |> b |> c
        }
    }

    static func buildBlock<A, B, C, D>(_ a: A, _ b: B, _ c: C, _ d: D) -> Pipeline<A.Input, D.Output>
        where
        A: Job, B: Job, C: Job, D: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input
    {
        Pipeline(description: descriptionOf(jobs: [a, b, c, d])) {
            try $0 |> a |> b |> c |> d
        }
    }

    static func buildBlock<A, B, C, D, E>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> Pipeline<A.Input, E.Output>
        where
        A: Job, B: Job, C: Job, D: Job, E: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input,
        D.Output == E.Input
    {
        Pipeline(description: descriptionOf(jobs: [a, b, c, d, e])) {
            try $0 |> a |> b |> c |> d |> e
        }
    }

    static func buildBlock<A, B, C, D, E, F>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) -> Pipeline<A.Input, F.Output>
        where
        A: Job, B: Job, C: Job, D: Job, E: Job, F: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input,
        D.Output == E.Input,
        E.Output == F.Input
    {
        Pipeline(description: descriptionOf(jobs: [a, b, c, d, e, f])) {
            try $0 |> a |> b |> c |> d |> e |> f
        }
    }

    static func buildBlock<A, B, C, D, E, F, G>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F, _ g: G) -> Pipeline<A.Input, G.Output>
        where
        A: Job, B: Job, C: Job, D: Job, E: Job, F: Job, G: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input,
        D.Output == E.Input,
        E.Output == F.Input,
        F.Output == G.Input
    {
        Pipeline(description: descriptionOf(jobs: [a, b, c, d, e, f, g])) {
            try $0 |> a |> b |> c |> d |> e |> f |> g
        }
    }
}

precedencegroup Pipe {
    higherThan: DefaultPrecedence
    associativity: left
    assignment: true
}

infix operator |>: Pipe
private func |> <J>(input: J.Input, job: J) throws -> J.Output where J: Job {
    try job.work(input: input)
}

private func descriptionOf(jobs: [NamedTask]) -> String {
    jobs.map { $0.name }.joined(separator: " |> ")
}

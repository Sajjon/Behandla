//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-12-10.
//

import Foundation

struct Pipeline<Input, Output>: Job {

    private let _getOutput: (Input) throws -> Output
    fileprivate init(_ getOutput: @escaping (Input) throws -> Output) {
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
        Pipeline { input in
            try jobA.work(input: input)
        }
    }

    static func buildBlock<A, B>(_ a: A, _ b: B) -> Pipeline<A.Input, B.Output>
        where
        A: Job, B: Job,
        A.Output == B.Input
    {
        Pipeline {
            try $0 |> a |> b
        }
    }

    static func buildBlock<A, B, C>(_ a: A, b: B, c: C) -> Pipeline<A.Input, C.Output>
        where
        A: Job, B: Job, C: Job,
        A.Output == B.Input,
        B.Output == C.Input
    {
        Pipeline {
            try $0 |> a |> b |> c
        }
    }

    static func buildBlock<A, B, C, D>(_ a: A, b: B, c: C, d: D) -> Pipeline<A.Input, D.Output>
        where
        A: Job, B: Job, C: Job, D: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input
    {
        Pipeline {
            try $0 |> a |> b |> c |> d
        }
    }

    static func buildBlock<A, B, C, D, E>(_ a: A, b: B, c: C, d: D, e: E) -> Pipeline<A.Input, E.Output>
        where
        A: Job, B: Job, C: Job, D: Job, E: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input,
        D.Output == E.Input
    {
        Pipeline {
            try $0 |> a |> b |> c |> d |> e
        }
    }

    static func buildBlock<A, B, C, D, E, F>(_ a: A, b: B, c: C, d: D, e: E, f: F) -> Pipeline<A.Input, F.Output>
        where
        A: Job, B: Job, C: Job, D: Job, E: Job, F: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input,
        D.Output == E.Input,
        E.Output == F.Input
    {
        Pipeline {
            try $0 |> a |> b |> c |> d |> e |> f
        }
    }

    static func buildBlock<A, B, C, D, E, F, G>(_ a: A, b: B, c: C, d: D, e: E, f: F, g: G) -> Pipeline<A.Input, G.Output>
        where
        A: Job, B: Job, C: Job, D: Job, E: Job, F: Job, G: Job,
        A.Output == B.Input,
        B.Output == C.Input,
        C.Output == D.Input,
        D.Output == E.Input,
        E.Output == F.Input,
        F.Output == G.Input
    {
        Pipeline {
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
func |> <J>(input: J.Input, job: J) throws -> J.Output where J: Job {
    try job.work(input: input)
}

//
//  Functional Operators.swift
//  FPLove
//
//  Created by Maxim Kovalko on 6/8/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

func compose<A, B>(_ a: A, callback: (A) -> B) -> B {
    return callback(a)
}

func compose<A, B, C>(_ lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}

precedencegroup CompositionPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: CompositionPrecedence

func |> <A, B>(_ a: A, callback: (A) -> B) -> B {
    return callback(a)
}

func |> <A, B, C>(_ lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}

func curry<A, B, C>(function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in function(a, b) } }
}

func uncury<A, B, C>(function: @escaping (A) -> (B) -> C) -> (A, B) -> C {
    return { a, b in function(a)(b) }
}

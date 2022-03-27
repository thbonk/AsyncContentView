//
//  LoadingState.swift
//  AsyncContentView
//
//  Created by Thomas Bonk on 27.03.22.
//
//  Inspired by the article 'Handling loading states within SwiftUI views'
//  (https://swiftbysundell.com/articles/handling-loading-states-in-swiftui/).
//
//  Copyright 2022 Thomas Bonk
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


import Foundation

/// Loading state of an asynchronous operation.
public enum LoadingState<Value> {
  /// The loader is idle and does nothing.
  case idle

  /// The loader is currently loading the content.
  case loading

  /// An error occured while loading the content.
  ///
  /// - Parameters:
  ///   - error: The error that has been thrown
  case failed(error: Error)

  /// The content has been loaded successfully.
  ///
  /// - Parameters:
  ///   - content: The content that has been loaded
  case loaded(content: Value)
}

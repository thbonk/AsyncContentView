//
//  PublishedObject.swift
//  AsyncContentView
//
//  Created by Thomas Bonk on 28.03.22.
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

import Combine
import Foundation

class PublishedObject<Wrapped: Publisher>: LoadableObject {

  // MARK: - Public Properties

  @Published
  public private(set) var state = LoadingState<Wrapped.Output>.idle


  // MARK: - Private Properties

  private let publisher: Wrapped
  private var cancellable: AnyCancellable?


  // MARK: - Initialization

  init(publisher: Wrapped) {
    self.publisher = publisher
  }


  // MARK: - LoadableObject

  func load() {
    state = .loading

    cancellable = publisher
      .map(LoadingState.loaded)
      .catch { error in
        Just(LoadingState.failed(error: error))
      }
      .sink { [weak self] state in
        self?.state = state
      }
  }
}

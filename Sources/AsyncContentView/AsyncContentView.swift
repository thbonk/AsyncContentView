//
//  AsyncContentView.swift
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

import Combine
import SwiftUI

public struct AsyncContentView<Source: LoadableObject, Content: View, ErrorView: View, LoadingView: View>: View {

  // MARK: - Public Properties

  @ObservedObject
  public private(set) var source: Source

  public var body: some View {
    switch source.state {
      case .idle:
        Color.clear.onAppear(perform: source.load)
      case .loading:
        ProgressView()
      case .failed(let error):
        errorView(error, source.load)
      case .loaded(let output):
        content(output)
    }
  }


  // MARK: - Initialization

  public init(
    source: Source,
    @ViewBuilder content: @escaping (Source.Output) -> Content,
    @ViewBuilder errorView: @escaping (Error, @escaping () -> ()) -> ErrorView) {

      self.source = source
      self.content = content
      self.errorView = errorView
    }


  // MARK: - Private Properties

  private var content: (Source.Output) -> Content
  private var errorView: (Error, @escaping () -> ()) -> ErrorView
}


public extension AsyncContentView {

  init<P: Publisher>(
    source: P,
    @ViewBuilder content: @escaping (P.Output) -> Content,
    @ViewBuilder errorView: @escaping (Error, @escaping () -> ()) -> ErrorView) where Source == PublishedObject<P> {

      self.init(source: PublishedObject(publisher: source), content: content, errorView: errorView)
  }
}

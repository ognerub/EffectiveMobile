//
//  EditorView.swift
//  EffectiveMobile
//
//  Created by Alexander Ognerubov on 03.09.2025.
//

import SwiftUI
import CoreData

struct EditorView: View {

    let item: Item

    @ObservedObject var viewModel: ViewModel

    @FocusState private var isFocusedOnHeader: Bool
    @FocusState private var isFocusedOnBody: Bool

    @State private var minHeightForHeader: CGFloat = 60
    @State private var minHeightForBody: CGFloat = 60

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
            ScrollView() {
                VStack(spacing: 0) {
                    ZStack {
                        Text(viewModel.editableHeader)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.red)
                            .padding(10)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            minHeightForHeader = geo.size.height
                                        }
                                        .onChange(of: geo.size.height) { oldHeight, newHeight in
                                            minHeightForHeader = newHeight
                                        }
                                }
                            )
                            .hidden()
                        if !isFocusedOnHeader
                            && viewModel.editableHeader.isEmpty {
                            Text("Добавьте название")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                        TextEditor(text: $viewModel.editableHeader)
                            .frame(minHeight: minHeightForHeader, maxHeight: .infinity)
                            .font(.system(size: 34, weight: .bold))
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .foregroundColor(.customWhite)
                            .padding(.bottom, 6)
                            .focused($isFocusedOnHeader)
                            .scrollDisabled(true)
                    }
                    Text(item.timestamp ?? Date(), formatter: DateFormatter.itemFormatter)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)
                    ZStack {
                        Text(viewModel.editableBody)
                            .font(.system(size: 16, weight: .regular))
                            .padding(10)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            minHeightForBody = geo.size.height
                                        }
                                        .onChange(of: geo.size.height) { oldHeight, newHeight in
                                            minHeightForBody = newHeight
                                        }
                                }
                            )
                            .hidden()
                        if !isFocusedOnBody
                            && viewModel.editableBody.isEmpty {
                            Text("Добавьте описание")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                        TextEditor(text: $viewModel.editableBody)
                            .font(.system(size: 16, weight: .regular))
                            .frame(minHeight: minHeightForBody, maxHeight: .infinity)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .foregroundColor(.customWhite)
                            .padding(.bottom, 16)
                            .focused($isFocusedOnBody)
                            .scrollDisabled(true)
                    }
                }
                .padding(.horizontal, 20)
                .preferredColorScheme(.dark)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if let last = viewModel.navPath.last {
                        viewModel.updateItem(
                            withId: last.id,
                            header: viewModel.editableHeader,
                            body: viewModel.editableBody,
                            timestamp: last.timestamp,
                            status: last.status)
                        viewModel.navPath.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.customYellow)
                    Text("Назад")
                        .foregroundColor(.customYellow)
                }
            }
        }
    }
}

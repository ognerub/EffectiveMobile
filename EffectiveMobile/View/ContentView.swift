//
//  ContentView.swift
//  EffectiveMobile
//
//  Created by Alexander Ognerubov on 03.09.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @StateObject private var viewModel: ViewModel

    @AppStorage("isFirstStart") private var isFirstStart: Bool = true

    @State private var isShareSheetPresented: Bool = false

    private var viewWidth = CGFloat.zero

    init(context: NSManagedObjectContext, loader: Loader) {
        _viewModel = StateObject(wrappedValue: ViewModel(
            context: context,
            loader: loader)
        )
        setupAppearence()
    }

    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.getFilteredItems()) { item in
                            NavigationLink(value: item) {
                                HStack(alignment: .top) {
                                    Button(action: {
                                        viewModel.toggleItemStatus(withId: item.id)
                                    }, label: {
                                        Image(item.status == true ? .doneIcon : .todoIcon)
                                    })
                                    VStack(spacing: 6) {
                                        let headerAndBody = viewModel.getItemHeaderAndBody(item)
                                        Text(headerAndBody.header)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(item.status == false ? .customWhite : .gray)
                                            .strikethrough(item.status == true)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(headerAndBody.body)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(item.status == false ? .customWhite : .gray)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(item.timestamp ?? Date(), formatter: DateFormatter.itemFormatter)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .background(.black)
                                .contextMenu {
                                    Button("Редактировать", image: .editIcon) {
                                        viewModel.navPath.append(item)
                                    }
                                    Button("Поделиться", image: .exportIcon) {
                                        isShareSheetPresented = true
                                    }
                                    Button("Удалить", image: .trashIcon, role: .destructive) {
                                        viewModel.deleteItems(withId: item.id)
                                    }
                                } preview: {
                                    VStack(spacing: 6) {
                                        let headerAndBody = viewModel.getItemHeaderAndBody(item)
                                        Text(headerAndBody.header)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(item.status == false ? .customWhite : .gray)
                                            .strikethrough(item.status == true)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(headerAndBody.body)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(item.status == false ? .customWhite : .gray)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(item.timestamp ?? Date(), formatter: DateFormatter.itemFormatter)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(width: UIScreen.main.bounds.width - 32, height: 100, alignment: .top)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(.customGray)
                                }
                            }
                        }
                    }
                }
                .searchable(text: $viewModel.searchText)
                .background(.black)
                .navigationTitle("Задачи")
                .navigationDestination(for: Item.self) { item in
                    EditorView(item: item, viewModel: viewModel)
                }
                .safeAreaInset(edge: .bottom) {
                    bottomBar
                }
            }
        .preferredColorScheme(.dark)
        .onAppear() {
            if isFirstStart {
                isFirstStart = false
                viewModel.getNotes()
            }
        }
    }

    private var bottomBar: some View {
        ZStack {
            HStack {
                Spacer()
                Text("\(viewModel.items.count) задач")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.customWhite)
                    .padding([.horizontal, .bottom], 16)
                    .padding(.top, 20)
                Spacer()
            }
            HStack {
                Spacer()
                addButton
            }
        }
        .background(.customGray)
    }

    private var addButton: some View {
        Button(action: {
            viewModel.addItem()
        }, label: {
            Image(.newNoteIcon)
        })
    }

    private func setupAppearence() {
        UINavigationBar.appearance().barTintColor = .customGray
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.white
        UISearchBar.appearance().overrideUserInterfaceStyle = .dark
    }
}

#Preview {
    ContentView(
        context: PersistenceController().container.viewContext,
        loader: Loader()
    )
}

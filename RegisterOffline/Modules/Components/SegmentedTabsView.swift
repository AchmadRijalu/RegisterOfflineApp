//
//  SegmentedTabsView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

struct TabPage<Selection: Hashable>: Identifiable {
    let tag: Selection
    let title: String
    let content: AnyView

    var id: Selection { tag }

    init(tag: Selection, title: String, @ViewBuilder content: @escaping () -> some View) {
        self.tag = tag
        self.title = title
        self.content = AnyView(content())
    }
}

struct SegmentedTabBarStyle {
    var activeColor: Color
    var inactiveColor: Color
    var titleFontActive: Font
    var titleFontInactive: Font
    var tabBarBackground: Color
    var bottomDividerColor: Color
    var underlineHorizontalInset: CGFloat
    var tabAnimation: Animation

    init(
        activeColor: Color = .brandSecondary,
        inactiveColor: Color = .textSecondary,
        titleFontActive: Font = .system(size: 15, weight: .bold),
        titleFontInactive: Font = .system(size: 15, weight: .regular),
        tabBarBackground: Color = .white,
        bottomDividerColor: Color = Color.black.opacity(0.06),
        underlineHorizontalInset: CGFloat = 8,
        tabAnimation: Animation = .spring(response: 0.38, dampingFraction: 0.86)
    ) {
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.titleFontActive = titleFontActive
        self.titleFontInactive = titleFontInactive
        self.tabBarBackground = tabBarBackground
        self.bottomDividerColor = bottomDividerColor
        self.underlineHorizontalInset = underlineHorizontalInset
        self.tabAnimation = tabAnimation
    }

    static let `default` = SegmentedTabBarStyle()
}

struct SegmentedTabsView<Selection: Hashable>: View {
    @Binding private var selection: Selection
    private let tabs: [TabPage<Selection>]
    private let style: SegmentedTabBarStyle
    private let underlineNamespaceId: String

    @Namespace private var underlineNamespace
    @State private var forwardNavigation = true

    init(
        selection: Binding<Selection>,
        tabs: [TabPage<Selection>],
        style: SegmentedTabBarStyle = .default,
        underlineNamespaceId: String = "segmentedTabUnderline"
    ) {
        _selection = selection
        self.tabs = tabs
        self.style = style
        self.underlineNamespaceId = underlineNamespaceId
    }

    var body: some View {
        VStack(spacing: 0) {
            tabBar

            ZStack {
                if let tab = tabs.first(where: { $0.tag == selection }) {
                    tab.content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(slideTransition)
                        .id(selection)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var slideTransition: AnyTransition {
        if forwardNavigation {
            AnyTransition.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        } else {
            AnyTransition.asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        }
    }

    private var tabBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(tabs) { tab in
                    Button {
                        guard tab.tag != selection else { return }
                        let oldIndex = tabs.firstIndex { $0.tag == selection } ?? 0
                        let newIndex = tabs.firstIndex { $0.tag == tab.tag } ?? 0
                        forwardNavigation = newIndex > oldIndex
                        withAnimation(style.tabAnimation) {
                            selection = tab.tag
                        }
                    } label: {
                        VStack(spacing: 0) {
                            Text(tab.title)
                                .font(selection == tab.tag ? style.titleFontActive : style.titleFontInactive)
                                .foregroundColor(selection == tab.tag ? style.activeColor : style.inactiveColor)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)

                            ZStack(alignment: .bottom) {
                                Color.clear.frame(height: 2)

                                if selection == tab.tag {
                                    Capsule()
                                        .fill(style.activeColor)
                                        .frame(height: 2)
                                        .padding(.horizontal, style.underlineHorizontalInset)
                                        .matchedGeometryEffect(id: underlineNamespaceId, in: underlineNamespace)
                                }
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(style.tabBarBackground)

            Rectangle()
                .fill(style.bottomDividerColor)
                .frame(height: 1)
        }
    }
}

extension SegmentedTabsView where Selection: CaseIterable {
    init(
        selection: Binding<Selection>,
        style: SegmentedTabBarStyle = .default,
        underlineNamespaceId: String = "segmentedTabUnderline",
        title: @escaping (Selection) -> String,
        @ViewBuilder content: @escaping (Selection) -> some View
    ) {
        let builtTabs = Selection.allCases.map { tab in
            TabPage(tag: tab, title: title(tab)) {
                content(tab)
            }
        }
        self.init(
            selection: selection,
            tabs: Array(builtTabs),
            style: style,
            underlineNamespaceId: underlineNamespaceId
        )
    }

    init(
        selection: Binding<Selection>,
        style: SegmentedTabBarStyle = .default,
        underlineNamespaceId: String = "segmentedTabUnderline",
        title: KeyPath<Selection, String>,
        @ViewBuilder content: @escaping (Selection) -> some View
    ) {
        self.init(
            selection: selection,
            style: style,
            underlineNamespaceId: underlineNamespaceId,
            title: { $0[keyPath: title] },
            content: content
        )
    }
}

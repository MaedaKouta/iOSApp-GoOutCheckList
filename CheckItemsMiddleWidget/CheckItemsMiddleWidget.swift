//
//  CheckItemsMiddleWidget.swift
//  CheckItemsMiddleWidget
//
//  Created by 前田航汰 on 2022/11/12.
//

import WidgetKit
import SwiftUI
import Intents
import RealmSwift

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [SimpleEntry(date: Date(), configuration: configuration)]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CheckItemsMiddleWidgetEntryView : View {

    var entry: Provider.Entry
    // Widgetの小・中・大の取得
    @Environment(\.widgetFamily) var widgetFamily
    private let realm = RealmManager().realm

    private let findRealmData = FindRealmData()
    private let categoryName = FindRealmData().getWidgetCategory()?.name ?? "カテゴリー無し"
    private let categoryImageNamge =  FindRealmData().getWidgetCategory()?.assetsImageName ?? "question_small"
    private let categoryList = FindRealmData().getWidgetCategory()?.checkItems.elements
    private let categoryListCount = FindRealmData().getWidgetCategory()?.checkItems.elements.count ?? 0

    var body: some View {

        if widgetFamily == .systemSmall {
            VStack(spacing: 0.0) {

                Spacer()

                HStack{
                    Image("\(categoryImageNamge)")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color(UIColor.customIconCircleColor ?? UIColor.gray), lineWidth: 1)
                        )
                        .padding(.leading, 15)

                    Spacer()
                    Text("\(categoryListCount)")
                        .font(Font.futuraMedium(size: 25))
                        .padding(.trailing, 15)
                }

                Spacer()
                
                Text("\(categoryName)")
                    .font(.system(size: 11))
                    .foregroundColor(Color(UIColor.customMainColor ?? UIColor.gray))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 5.0) {
                    ForEach(0..<3) { i in

                        if i < categoryListCount {
                            Text("\(categoryList?[i].name ?? "")")
                                .font(.system(size: 11))
                        } else {
                            Text("")
                                .font(.system(size: 11))
                        }

                        // 最後の行には線を引かない
                        if i < categoryListCount && i != 2 {
                            Divider()
                        }

                    }
                }.padding(.horizontal, 8)

                Spacer()

            }.widgetURL(URL(string: "GoOutCheckList://deeplink?from=widget"))

        } else if widgetFamily == .systemMedium {
            HStack() {
                Spacer()

                VStack(alignment: .leading) {
                    Image("\(categoryImageNamge)")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color(UIColor.customMainColor ?? UIColor.gray), lineWidth: 1)
                        )
                        .padding(.top, 5)

                    Spacer()

                    Text("\(categoryListCount)")
                        .font(Font.futuraMedium(size: 25))

                    Text("\(categoryName)")
                        .font(.system(size: 11))
                        .foregroundColor(Color(UIColor.customMainColor ?? UIColor.gray))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(width: 85)

                VStack(alignment: .leading) {
                    ForEach(0..<5) { i in

                        if i < categoryListCount {
                            Text("\(categoryList?[i].name ?? "")")
                                .font(.system(size: 11))
                        } else {
                            Text("")
                                .font(.system(size: 11))
                        }

                        // 最後の行には線を引かない
                        if i < categoryListCount && i != 4 {
                            Divider()
                        }
                    }
                }

                Spacer()

            }
            .widgetURL(URL(string: "GoOutCheckList://deeplink?from=widget"))
            .padding(12)

        } else if widgetFamily == .systemLarge {
            VStack(spacing: 0.0) {

                Spacer()

                // 上半分
                HStack{

                    VStack(alignment: .leading) {
                        Text("\(categoryListCount)")
                            .font(Font.futuraMedium(size: 25))

                        Text("\(categoryName)")
                            .font(.system(size: 11))
                            .foregroundColor(Color(UIColor.customMainColor ?? UIColor.gray))
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }

                    Spacer()
                    Image("\(categoryImageNamge)")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color(UIColor.customMainColor ?? UIColor.gray), lineWidth: 1)
                        )
                        .padding(.leading, 15)

                    Spacer()

                } // 上半分ここまで

                Divider()
                    .padding(.vertical)

                Spacer()

                // 下半分
                VStack(alignment: .leading, spacing: 5.0) {
                    ForEach(0..<10) { i in

                        if i < categoryListCount {
                            Text("\(categoryList?[i].name ?? "")")
                                .font(.system(size: 11))
                        } else {
                            Text("")
                                .font(.system(size: 11))
                        }

                        // 最後の行には線を引かない
                        if i < categoryListCount && i != 9 {
                            Divider()
                        }
                    }


                }.padding(.horizontal, 8)
                // 下半分ここまで

                Spacer()

            }.widgetURL(URL(string: "GoOutCheckList://deeplink?from=widget"))
                .padding(12)

        }
    }
}

//struct ListCellLabelStyle: LabelStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        HStack() {
//            configuration.icon
//                .scaledToFit()
//                .scaledToFill()
//                .frame(width: 12.0, height: 12.0)
//            configuration.title
//                .font(.caption2)
//                .frame(width: .infinity)
//        }
//        .padding(.horizontal, 10)
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//extension LabelStyle where Self == ListCellLabelStyle {
//    static var listCell: ListCellLabelStyle {
//        .init()
//    }
//}

extension Font {
    static func futuraMedium(size: CGFloat) -> Font {
        //return Font.custom("Courier-Bold", size: size)
        return Font.custom("DamascusSemiBold", size: size)
        //return Font.custom("Courier-Bold", size: size)
        //return Font.custom("AppleColorEmoji", size: size)
    }
}

// ここがウィジェットの心臓部分
// provider: 表示させるための時間
// entry: 表示させるView
// configurationDisplayName:
// description:
struct CheckItemsMiddleWidget: Widget {
    let kind: String = "CheckItemsMiddleWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CheckItemsMiddleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("外出チェッカー")
        .description("登録したタスクを一覧表示できます。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CheckItemsMiddleWidget_Previews: PreviewProvider {
    static var previews: some View {
        CheckItemsMiddleWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

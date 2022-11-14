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
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
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

    var body: some View {

        if widgetFamily == .systemSmall {
            VStack(spacing: 0.0) {

                Spacer()

                HStack{
                    Image("car_small")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                        )
                        .padding(.leading, 15)

                    Spacer()
                    Text("8")
                        //.font(.title)
                        .font(Font.futuraMedium(size: 25))
                        .padding(.trailing, 15)
                }

                Spacer()
                Text("カテゴリー名")
                    .font(.system(size: 11))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 5.0) {
                    Text("タスク１")
                        .font(.system(size: 11))

                    Divider()

                    Text("タスク１")
                        .font(.system(size: 11))

                    Divider()

                    Text("タスク１")
                        .font(.system(size: 11))
                }.padding(.horizontal, 8)

                Spacer()

            }

        } else if widgetFamily == .systemMedium {
            HStack() {
                Spacer()

                VStack(alignment: .leading) {
                    Image("car_small")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                        )

                    Spacer()

                    Text("8")
                        .font(Font.futuraMedium(size: 25))

                    Text("カテゴリー名")
                        .font(.system(size: 11))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(width: 120)


                Spacer()

                VStack(alignment: .leading) {
                    Text("タスク１")
                        .font(.system(size: 11))

                    Divider()

                    Text("タスク２")
                        .font(.system(size: 11))

                    Divider()

                    Text("タスク３")
                        .font(.system(size: 11))

                    Divider()

                    Text("タスク４")
                        .font(.system(size: 11))

                    Divider()

                    Text("タスク５")
                        .font(.system(size: 11))
                }

                Spacer()

            }
            .padding(12)

        } else if widgetFamily == .systemLarge {
            VStack(spacing: 0.0) {

                Spacer()

                // 上半分
                HStack{

                    VStack(alignment: .leading) {
                        Text("8")
                            .font(Font.futuraMedium(size: 25))

                        Text("カテゴリー名")
                            .font(.system(size: 11))
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }

                    Spacer()
                    Image("car_small")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                        )
                        .padding(.leading, 15)

                    Spacer()

                } // 上半分ここまで

                Divider()
                    .bold()
                    .padding(.vertical)

                Spacer()


                // 下半分
                VStack(alignment: .leading, spacing: 5.0) {

                    Group {
                        Text("タスク１")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク２")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク３")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク４")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク５")
                            .font(.system(size: 11))

                        Divider()
                    }

                    Group {
                        Text("タスク６")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク７")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク８")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク９")
                            .font(.system(size: 11))

                        Divider()

                        Text("タスク１０")
                            .font(.system(size: 11))
                    }





                }.padding(.horizontal, 8)
                // 下半分ここまで

                Spacer()

            }.padding(12)


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
        .description("登録したカテゴリーのタスクを一覧で表示できます。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CheckItemsMiddleWidget_Previews: PreviewProvider {
    static var previews: some View {
        CheckItemsMiddleWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct FindRealmdata {
    let categoryListObject = RealmManager().realm.objects(CategoryList.self)
    let userdefault = UserDefaults(suiteName: "group.org.tetoblog.iOSApp-GoOutCheckList.userdefault")

    func getCategory() -> Category? {
        let index = findWidgetCategoryIdIndex()

        return nil
    }

    private func findWidgetCategoryIdIndex() -> Int {
        guard let categoryObjects = categoryListObject.first?.list else {
            return 0
        }
        if categoryObjects.count == 0 {
            return 0
        }

        var widgetCategoryIndex = 0
        for i in 0..<categoryObjects.elements.count {
            if categoryObjects.elements[i].id == UserDefaults.standard.string(forKey: "widgetCategoryId") {
                widgetCategoryIndex = i
            }
        }
        return widgetCategoryIndex
    }

}

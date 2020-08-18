//
//  ProfileScreenView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/17.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

// MEMO: 下記の記事を参考に作ってみました（GeometryReaderの利用がポイントになります）
// （記事）https://blckbirds.com/post/stretchy-header-and-parallax-scrolling-in-swiftui/
// （サンプル）https://github.com/BLCKBIRDS/StretchyHeaderAndParallaxScrollingInSwiftUI

struct ProfileScreenView: View {

    // MARK: - Property

    private let regularFontName = "AvenirNext-Regular"
    private let boldFontName = "AvenirNext-Bold"

    // MARK: - body

    var body: some View {

        // NavigationViewを配置する
        NavigationView {

            // ScrollViewを配置する
            ScrollView {

                // (ブロック1) スクロールで可変するサムネイル画像表示エリア
                // MEMO: GeometryReaderを利用して自身のサイズと座標空間を取得可能
                // https://blog.personal-factory.com/2019/12/08/how-to-know-coorginate-space-by-geometryreader/
                GeometryReader { geometry in
                    
                    // サムネイル画像を表示するエリア
                    ZStack {

                        // MEMO: RootViewからの座標情報を元に場合分けをしている
                        // 従来通りスクロールをした場合
                        if geometry.frame(in: .global).minY <= 0 {

                            // MEMO: Y軸方向の画像の表示オフセット値を利用してParallaxの演出をする
                            Image("profile_background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                // MEMO: 割り算の分母を小さくすると変化度合いが大きくなる
                                .offset(y: -geometry.frame(in: .global).minY/8)
                                .clipped()

                        // 初期表示位置から更に引っ張ってスクロールをした場合
                        } else {
                            
                            // MEMO: Y軸方向の画像の表示オフセット値を利用して拡大するような演出をする
                            Image("profile_background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                .clipped()
                                .offset(y: -geometry.frame(in: .global).minY)
                        }
                    }
                }
                // 高さを280px付与する
                .frame(height: 280)

                // (ブロック2) 文章情報表示ブロック ※各要素は左寄せ
                VStack(alignment: .leading) {

                    // アバター画像とテキストを横に並べて表示する
                    HStack {

                        // アバター画像表示
                        Image("profile_avater")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .border(Color(hex: 0xCCCCCC), width: 2)

                        // ユーザー名テキスト表示
                        VStack(alignment: .leading) {
                            Text("こちらの方が書いています🗒")
                                .font(.custom(regularFontName, size: 13))
                                .foregroundColor(.gray)
                            Text("通りすがりの🐈さん")
                                .padding(.top, 8)
                                .font(.custom(boldFontName, size: 13))
                        }
                    }
                    // 上へ余白を付与する
                    .padding(.top, 18)

                    // タイトルテキスト表示
                    Text("せっかくなのでおいしい食卓の風景をいかがですか？思わす見惚れる料理集")
                        .font(.custom(boldFontName, size: 20))
                        .lineLimit(nil)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    // プロフィール公開日テキスト表示
                    Text("📆 プロフィール公開日:")
                        .font(.custom(regularFontName, size: 13))
                        .foregroundColor(.gray)
                    Text("2020年8月16日 AM 11:00")
                        .font(.custom(regularFontName, size: 13))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .padding(.bottom, 16)

                    // 現在公開中の料理写真テキスト表示
                    Text("🍔 現在公開中の料理写真:")
                        .font(.custom(regularFontName, size: 13))
                        .foregroundColor(.gray)
                    Text("180点")
                        .font(.custom(regularFontName, size: 13))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .padding(.bottom, 16)

                    // 得意な料理ジャンルテキスト表示
                    Text("🍴得意な料理ジャンル:")
                        .font(.custom(regularFontName, size: 13))
                        .foregroundColor(.gray)
                    Text("家庭料理全般 / 和食 / 洋食 / 中華 / フレンチ / イタリアン")
                        .font(.custom(regularFontName, size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .padding(.bottom, 16)

                    // 本文テキスト表示
                    Text(getProfileStatement())
                        .font(.custom(regularFontName, size: 13))
                        .lineLimit(nil)
                        .padding(.top, 4)
                }
                // 全体に余白を付与する
                .padding(16)
            }
            // NavigationBarのタイトル表示の設定
            .navigationBarTitle(Text("Profile"), displayMode: .inline)
            // 上のSafeAreaを越えてコンテンツを表示する
            .edgesIgnoringSafeArea(.top)
        }
        // NavigationViewでNavigationBarを表示する
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private Function

    private func getProfileStatement() -> String {
        return
"""
＜まずは自己紹介＞

はじめまして、都内の大学に通っている学生です。
        
大学1年生の時にフレンチレストランでのアルバイトをきっかけに料理にはまり、自宅でも毎日料理をしています。大学での専攻は生物学でこれからの専攻は植物の遺伝子に関する研究をしていく予定です（実はこう見えてもバリバリの理科系なんです✨）。普段は大学の授業と並行して週に3回程別の調理関連の学校にも通っていわば二足の草鞋を履く生活を送っています。
        
掲載している写真については主に自宅での何気ないご飯の一コマから、友達と一緒に料理をしている時の写真やそのほか実家で家族に振る舞っている手料理がメインです。もし、「この料理の材料ってどんな感じ？」とか「どんな調理器具を使っているの？」とか掲載している料理に関する質問でしたら随時受け付けておりますのでよろしくお願いします！
        
アバターに設定しているのは、私の飼い猫（2歳の♂）になります。
とてもやんちゃで毎日料理のつまみ食い阻止にもおかげさまで大忙しです（汗）
        
＜最近のマイブーム紹介＞

✨ねこねこ食パン🐱
→ 食パンの形が猫ちゃんになっている何とも猫好きにはたまらない食パン。可愛い見た目以上に味もとっても良いので、朝のトーストにするのが最近の鉄板メニューです。

✨サラダさば🐟
→ これ、最近気に入っています。ほどよい塩加減と味付けが好きなんですよね。こちらはご飯のおかずにすることもありますが、冷やしうどんの具材にして食べることが多いです。
"""
    }
}

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreenView()
    }
}

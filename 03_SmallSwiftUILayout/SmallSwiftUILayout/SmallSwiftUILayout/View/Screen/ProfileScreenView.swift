//
//  ProfileScreenView.swift
//  SmallSwiftUILayout
//
//  Created by 酒井文也 on 2020/08/17.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import SwiftUI

// MEMO: 下記の記事を参考に作ってみました（GeometryReaderの利用がポイントになります）


struct ProfileScreenView: View {

    private let regularFontName = "AvenirNext-Regular"
    private let boldFontName = "AvenirNext-Bold"

    // MARK: - body

    var body: some View {

        //
        NavigationView {

            //
            ScrollView {

                //
                GeometryReader { geometry in
                    
                    //
                    ZStack {

                        //
                        if geometry.frame(in: .global).minY <= 0 {
                            
                            //
                            Image("profile_background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(y: geometry.frame(in: .global).minY/10)
                                .clipped()
                                .opacity(0.5)
                            
                        } else {
                            
                            //
                            Image("profile_background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                                .clipped()
                                .offset(y: -geometry.frame(in: .global).minY)
                                .opacity(0.5)
                        }
                    }
                }
                .frame(height: 150) //

                //
                VStack(alignment: .leading) {

                    //
                    HStack {

                        //
                        Image("profile_avater")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .border(Color(hex: 0xCCCCCC), width: 2)

                        //
                        VStack(alignment: .leading) {
                            Text("こちらの方が書いています🗒")
                                .font(.custom(regularFontName, size: 14))
                                .foregroundColor(.gray)
                            Text("通りすがりの🐈さん")
                                .padding(.top, 8)
                                .font(.custom(boldFontName, size: 14))
                        }
                    }
                    .padding(.top, 20)

                    //
                    Text("せっかくなのでおいしい食卓の風景をいかがですか？思わす見惚れる料理集")
                        .font(.custom(boldFontName, size: 24))
                        .lineLimit(nil)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    //
                    Text("📆 プロフィール公開日:")
                        .font(.custom(regularFontName, size: 14))
                        .foregroundColor(.gray)
                    Text("2020年8月16日 AM 11:00")
                        .font(.custom(regularFontName, size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .padding(.bottom, 16)

                    //
                    Text("🍔 現在公開中の料理写真:")
                        .font(.custom(regularFontName, size: 14))
                        .foregroundColor(.gray)
                    Text("180点")
                        .font(.custom(regularFontName, size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .padding(.bottom, 16)

                    //
                    Text("🍴得意な料理ジャンル:")
                        .font(.custom(regularFontName, size: 14))
                        .foregroundColor(.gray)
                    Text("家庭料理全般 / 和食 / 洋食 / 中華 / フレンチ / イタリアン")
                        .font(.custom(regularFontName, size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                        .padding(.bottom, 16)

                    //
                    Text(getProfileStatement())
                        .font(.custom(regularFontName, size: 16))
                        .lineLimit(nil)
                        .padding(.top, 4)
                }
                .padding(16)
            }
            .navigationBarTitle(Text("Your Profile"), displayMode: .automatic)
            .edgesIgnoringSafeArea(.top) //
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private Function
    
    private func getProfileStatement() -> String {
        return
"""
はじめまして、都内の大学に通っている学生です。
        
大学1年生の時にフレンチレストランでのアルバイトをきっかけに料理にはまり、自宅でも毎日料理をしています。大学での専攻は生物学でこれからの専攻は植物の遺伝子に関する研究をしていく予定です（実はこう見えてもバリバリの理科系なんです✨）。普段は大学の授業と並行して週に3回程別の調理関連の学校にも通っていわば二足の草鞋を履く生活を送っています。
        
掲載している写真については主に自宅での何気ないご飯の一コマから、友達と一緒に料理をしている時の写真やそのほか実家で家族に振る舞っている手料理がメインです。もし、「この料理の材料ってどんな感じ？」とか「どんな調理器具を使っているの？」とか掲載している料理に関する質問でしたら随時受け付けておりますのでよろしくお願いします！
        
アバターに設定しているのは、私の飼い猫（2歳の♂）になります。
とてもやんちゃで毎日料理のつまみ食い阻止にもおかげさまで大忙しです（汗）
"""
    }
}

struct ProfileScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreenView()
    }
}

//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct LoginByEmailPWView: View {
    
    @ObservedObject var emailLoginStore: EmailLoginStore
    
    @State private var isPasswordVisible = false // 비밀번호 보이기
    @State private var isPasswordCorrect = false // 패스워드 일치 체크
    
    /// 비밀번호 확인 안내문구
    @State private var adminMessage: String = ""
    
    /// 로그인 성공 시 풀스크린 판별한 Bool 값
    @State private var loginResult: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all) // 배경색
            
            VStack(alignment: .leading) {
                Rectangle().frame(height: 50)
                    
                HStack {
                    // 안내 문구1
                    Text("비밀번호를 입력해 주세요.")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                    // 비밀번호 숨기기,보이기 토글 버튼
                    Button {
                        isPasswordVisible.toggle()
                        
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.trailing, -2)
                    }
                }
                
                Group {
                    HStack {
                        // 비밀번호 숨겼을 경우 ***표시
                        if isPasswordVisible == false {
                            SecureField("비밀번호", text: $emailLoginStore.password, prompt: Text("비밀번호").foregroundColor(.gray))
                                .foregroundColor(Color.white.opacity(0.3))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .autocapitalization(.none)
                                .frame(height: 35)
                            
                        } else { // 비밀번호 보이게 할 경우 숫자 표시
                            TextField("비밀번호", text: $emailLoginStore.password, prompt: Text("비밀번호").foregroundColor(.white))
                                .foregroundColor(Color.white.opacity(0.3))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .autocapitalization(.none)
                                .frame(height: 35)
                        }
                        
                        // 입력한 비밀번호 지우기 버튼
                        Button {
                            emailLoginStore.password = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                        
                    }
                    .foregroundColor(.white.opacity(0.4))
                    
                    Rectangle().frame(height: 1)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.bottom, 5)
                    
                    // 비밀번호 확인 안내문구
                    Text(adminMessage)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                    
                }
                .padding(.leading, 15)
                
                Spacer()
            }
            .padding(.trailing, 15)
            .background(Color.black)
            // 상단 네비게이션 바
            .navigationBarItems(trailing:
                                    Button(action: {
                
                Task {
                    do {
                        let emailLoginResult: Bool = try await emailLoginStore.login()
                        
                        print(loginResult)
                        loginResult = emailLoginResult
                        print(loginResult)
                    } catch {
                        print("로그인 실패")
                        adminMessage = "비밀번호를 다시 입력해주세요"
                    }
                }
            }, label: {
                Text("로그인")
                    .fontWeight(.semibold)
                    .padding(.trailing, 5)
                    .font(.headline)
            }
                                          )
            )
            .fullScreenCover(isPresented: $loginResult, content: {
                ContentView()
            })
        }
    }
}

#Preview {
    LoginByEmailPWView(emailLoginStore: EmailLoginStore())
}
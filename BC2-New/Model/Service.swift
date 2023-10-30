//
//  Service.swift
//  BC2-New
//
//  Created by 신아인 on 10/30/23.
//

import Foundation
import CryptoKit
//충전 요청 함수
func charge(email: String, balance: Int, charged_money: Int, completion: @escaping (Result<Void, Error>) -> Void) -> Bool {
    let urlString = APIConstants.sendURL  // 충전 API 엔드포인트 URL
    guard let url = URL(string: urlString) else {
        print("유효하지 않은 URL입니다.")
        return false
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"  // POST 요청 설정
    
    // Request Body 생성
//    let requestBody = "email=\(email)&balance=\(balance)&charged_money=\(charged_money)"
//    let httpBody = requestBody.data(using: .utf8)
    let requestBody = [
        "email": email,
        "balance": balance + charged_money,
        "charged_money": charged_money
    ] as [String : Any]
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody)

    var bool: Bool = false
    
    // URLSession을 사용하여 Request 보내기
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            print("요청 실패: \(error)")
            return
        }
        
        // 응답 처리
        if let data = data {
            do {
                // JSON 데이터 파싱
                if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let balance = responseJSON["balance"]!
                    print("계정 잔액: \(balance)")
                    
                    let successsRange = 200..<300
                    
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
                    else {
                        print("")
                        print("====================================")
                        print("[requestPOST : http post 요청 에러]")
                        print("error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                        print("msg : ", (response as? HTTPURLResponse)?.description ?? "")
                        print("====================================")
                        print("")
                        
                        completion(.failure(URLError(.badServerResponse)))
                        return
                    }
                    bool = true
                    completion(.success(()))
                    
                    print(statusCode)
                }
            } catch {
                print("응답 데이터 처리 실패: \(error)")
            }
            
        }
    }
    task.resume()
    return bool
    
}



//QR결제 요청 함수
import Foundation

//충전 요청 함수
func QRPayment(email: String,balance: Int, menu: String, price: Int, quantity: Int,number: Int, completion: @escaping (Result<Void, Error>) -> Void) {
    let urlString = APIConstants.QRURL
    guard let url = URL(string: urlString) else {
        print("유효하지 않은 URL입니다.")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"  // POST 요청 설정
    
    // Request Body 생성
//    let requestBody = "email=\(email)&balance=\(balance)&menu=\(menu)&price=\(price)&quantity=\(quantity)"
//    let httpBody = requestBody.data(using: .utf8)
    let requestBody = [
        "email": email,
        "balance": balance,
        "menu": menu,
        "price": price,
        "quantity": quantity,
        "number": number
    ] as [String : Any]
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: requestBody)
    
    // URLSession을 사용하여 Request 보내기
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            print("요청 실패: \(error)")
            return
        }
        
        // 응답 처리
        if let data = data {
            do {
                // JSON 데이터 파싱
                if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let balance = responseJSON["balance"]!
                    print("계정 잔액: \(balance)")
                    
                    let successsRange = 200..<300
                    
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
                    else {
                        print("")
                        print("====================================")
                        print("[requestPOST : http post 요청 에러]")
                        print("error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                        print("msg : ", (response as? HTTPURLResponse)?.description ?? "")
                        print("====================================")
                        print("")
                        completion(.failure(URLError(.badServerResponse)))
                        return
                    }
                    print("요청 성공.  상태 코드: \(statusCode)")
                    completion(.success(()))
                }
            } catch {
                print("응답 데이터 처리 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    task.resume()
}

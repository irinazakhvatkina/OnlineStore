//
//  RegistrationValidator.swift
//  BestRecipe
//
//  Created by Zarina Sadykova on 03.09.25.
//
import UIKit

struct RegistrationValidator {
    
    static func validate(fields: [String], fieldTitles: [String]) -> ValidationError? {
        // Проверка на пустые поля
        for (index, value) in fields.enumerated() {
            if value.isEmpty {
                return .emptyField(field: fieldTitles[index], index: index)
            }
        }
        
        // Индексы полей после удаления last name:
        // [0] - First Name
        // [1] - Email
        // [2] - Password
        // [3] - Confirm Password
        
        let firstName = fields[0]
        let email = fields[1]
        let password = fields[2]
        let confirmPassword = fields[3]
        
        // Валидация имени
        let nameRegex = "^[A-Za-z]{2,15}$"
        if !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: firstName) {
            return .invalidFirstName(index: 0)
        }
        
        // Валидация email
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            return .invalidEmail(index: 1)
        }
        
        // Валидация пароля
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{6,10}$"
        if !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
            return .invalidPassword(index: 2)
        }
        
        // Проверка совпадения паролей
        if password != confirmPassword {
            return .passwordsDoNotMatch(index: 3)
        }
        
        return nil
    }
}

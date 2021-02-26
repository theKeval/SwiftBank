//
//  ModelClass.swift
//  SwiftBank
//
//  Created by Keval on 2/25/21.
//

import Foundation

class Customer: Codable {
    var name: String
    var contactNo: String
    var address: String
    var password: String
    
    var accounts: Accounts?
    
    init(name: String, contactNo: String, address: String, password: String) {
        self.name = name
        self.contactNo = contactNo
        self.address = address
        self.password = password
        
        // self.accounts = []
    }
    
    func addBankAccounts(accs: Accounts) {
        accounts = accs
    }
}

class Accounts: Codable {
    var salaryAcc: SalaryAccount?
    var SavingsAcc: SavingsAccount?
    var FixedDepositAcc: FixedDepositAccount?
    
    init(salAcc: SalaryAccount? = nil, savAcc: SavingsAccount? = nil, fixAcc: FixedDepositAccount? = nil) {
        self.salaryAcc = salAcc
        self.SavingsAcc = savAcc
        self.FixedDepositAcc = fixAcc
    }
}

class BankAccount: Codable {
    var accountNo: Int
    var accountBalance: Double
    
    init(accNo: Int, accBalance: Double) {
        self.accountNo = accNo
        self.accountBalance = accBalance
    }
    
    
    // way to encode manually due to inheritance
    
    private enum CodingKeys: String, CodingKey {
        case accountNo
        case accountBalance
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountNo, forKey: .accountNo)
        try container.encode(accountBalance, forKey: .accountBalance)
    }
    
    
    // Functions for transactions
    
    func addBalance(amountToAdd: Double) -> Double {
        return accountBalance + amountToAdd
    }
    
    func deductBalance(amountToDeduct: Double) -> Double {
        return accountBalance - amountToDeduct
    }
}

class SalaryAccount: BankAccount {
    var employer: String
    var monthlySalary: Double
    
    init(accNo: Int, accBalance: Double, employer: String, monthlySalary: Double) {
        self.employer = employer
        self.monthlySalary = monthlySalary
        
        super.init(accNo: accNo, accBalance: accBalance)
    }
    
    private enum CodingKeys: String, CodingKey {
        case employer
        case monthlySalary
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(employer, forKey: .employer)
        try container.encode(monthlySalary, forKey: .monthlySalary)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        employer = try container.decode(String.self, forKey: .employer)
        monthlySalary = try container.decode(Double.self, forKey: .monthlySalary)
        try super.init(from: decoder)
        
        
        // fatalError("init(from:) has not been implemented")

        // for possible correct implementation, go through the below link
        // https://stackoverflow.com/a/48281951/2049623
        //
        // https://benscheirman.com/2017/06/swift-json/
        // https://stackoverflow.com/a/48523100/2049623
    }
}

class SavingsAccount: BankAccount {
    var minBalance: Double
    var interestRate: Double
    
    init(accNo: Int, accBalance: Double, minBal: Double, intRate: Double) {
        self.minBalance = minBal
        self.interestRate = intRate
        
        super.init(accNo: accNo, accBalance: accBalance)
    }
    
    private enum CodingKeys: String, CodingKey {
        case minBalance
        case interestRate
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(minBalance, forKey: .minBalance)
        try container.encode(interestRate, forKey: .interestRate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        minBalance = try container.decode(Double.self, forKey: .minBalance)
        interestRate = try container.decode(Double.self, forKey: .interestRate)
        try super.init(from: decoder)
    }
}

class FixedDepositAccount: BankAccount {
    var depositAmount: Double
    var maturityDate: Date
    var termDuration: Int
    
    init(accNo: Int, accBalance: Double, depoAmount: Double, matDate: Date, termDur: Int) {
        self.depositAmount = depoAmount
        self.maturityDate = matDate
        self.termDuration = termDur
        
        super.init(accNo: accNo, accBalance: accBalance)
    }
    
    private enum CodingKeys: String, CodingKey {
        case depositAmount
        case maturityDate
        case termDuration
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(depositAmount, forKey: .depositAmount)
        try container.encode(maturityDate, forKey: .maturityDate)
        try container.encode(termDuration, forKey: .termDuration)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        depositAmount = try container.decode(Double.self, forKey: .depositAmount)
        maturityDate = try container.decode(Date.self, forKey: .maturityDate)
        termDuration = try container.decode(Int.self, forKey: .termDuration)
        try super.init(from: decoder)
    }
}

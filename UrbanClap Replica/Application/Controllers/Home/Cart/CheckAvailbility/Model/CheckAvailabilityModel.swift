
//

import Foundation



// MARK: - Welcome
struct Slot_Model: Decodable
{
    let code: Int
    let message: String
    let body: SlotsResult
}

// MARK: - Body
struct SlotsResult: Decodable
{
    let slots: [Slot]
  //  let leaves: [String]?
  //  let id, fromDate, toDate, startTime: String?
  //  let endTime, companyID: String?
  //  let status, createdAt: Int?

    enum CodingKeys: String, CodingKey
    {
        case slots
       // case slots, id, fromDate, toDate, startTime, endTime
       // case companyID = "companyId"
       // case status, createdAt
      //  case leaves
    }
}

// MARK: - Slot
struct Slot: Decodable
{
    let slot, bookings: String?
    let status:Int?
}



//MARK: INSTRUCTIONS MODEL


// MARK: - Welcome
struct InstructionsModel: Codable
{
    let code: Int
    let message: String?
    let body: BodyInstruct
}

// MARK: - Body
struct BodyInstruct: Codable
{
    let deliveryInstructions, pickupInstructions: [Instruction]
   // let tips: JSONNull?
    let id: Int?
    let cookingInstructions, companyID: String?
    let status: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case deliveryInstructions, pickupInstructions, id, cookingInstructions
        case companyID = "companyId"
        case status, createdAt
       // case tips
    }
}

// MARK: - Instruction
struct Instruction: Codable
{
    let id: Int?
    let heading, instruction: String?
}


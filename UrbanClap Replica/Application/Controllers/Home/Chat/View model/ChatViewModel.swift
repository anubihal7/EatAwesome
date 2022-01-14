///
////
//
//import Foundation
//import Alamofire
//
//protocol ChatViewDelegate:class
//{
//    func Show(msg: String)
//    func didError(error:String)
//}
//
//class ChatViewModel
//{
//  //  typealias successHandler = (CreateGroupModel) -> Void
//   // typealias successHandlerGroupMember = (AddedGroupMemberModel) -> Void
//    typealias successHandlerGetUsers = (GetUsersModel) -> Void
//    var delegate : CreateGroupDelegate
//    var view : UIViewController
//
//    init(Delegate : CreateGroupDelegate, view : UIViewController)
//    {
//        delegate = Delegate
//        self.view = view
//    }
//
////    func addParticipants(Params : [String:Any],completion: @escaping successHandler)
////    {
//////        WebService.Shared.PostApi(url: APIAddress.BASE_URL + APIEndPoint.addMembers , parameter:Params, Target: self.view, completionResponse: { response in
//////            print(response)
//////            do
//////            {
//////                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//////                let getAllListResponse = try JSONDecoder().decode(CreateGroupModel.self, from: jsonData)
//////                completion(getAllListResponse)
//////            }
//////            catch
//////            {
//////                print(error.localizedDescription)
//////                self.view.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
//////            }
//////
//////        }, completionnilResponse: {(error) in
//////            self.delegate.didError(error: error)
//////        })
////    }
//
////    //MARK:- Delete Users
////    func DeleteUsersFromGroup(Params : [String:Any],completion: @escaping successHandler)
////    {
//////        WebService.Shared.deleteApi(url: APIAddress.BASE_URL + APIEndPoint.addMembers, parameter: Params, Target: self.view, completionResponse: { (response) in
//////            print(response)
//////            do
//////            {
//////                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//////                let getAllListResponse = try JSONDecoder().decode(CreateGroupModel.self, from: jsonData)
//////                completion(getAllListResponse)
//////            }
//////            catch
//////            {
//////                print(error.localizedDescription)
//////                self.view.showAlertMessage(titleStr: kAppName, messageStr: error.localizedDescription)
//////            }
//////        }) { (error) in
//////            self.delegate.didError(error: error)
//////        }
////    }
//
//    //MARK:- GetAddedMembersInGroup
////    func getAddedMembersInGroup(groupId:String,completion: @escaping successHandlerGroupMember)
////    {
//////        WebService.Shared.GetApi(url: APIAddress.BASE_URL + APIEndPoint.kmemberList + groupId, Target: self.view, completionResponse: { (response) in
//////                if let responseData  = response as? [String : Any]
//////                {
//////                    self.AddedMembersJSON(data: responseData, completionResponse: { (addedMember) in
//////                        completion(addedMember)
//////                    }, completionError: { (error) in
//////
//////                    })
//////                }
//////                else{
//////
//////                }
//////
//////        }, completionnilResponse: { (error) in
//////            self.delegate.didError(error: error)
//////        })
////    }
//
//    //MARK:- GetUsers List
//    func GetUsers(completion: @escaping successHandlerGetUsers)
//    {
//        WebService.Shared.GetApi(url: "http://camonher.infinitywebtechnologies.com:9080/api/members", Target: self.view, showLoader: true, completionResponse: { (response) in
//                if let responseData  = response as? [String : Any]
//                {
//                    self.UserDataJSON(data: responseData, completionResponse: { (Data) in
//                        completion(Data)
//                    }, completionError: { (error) in
//
//                    })
//                }
//        }, completionnilResponse: { (error) in
//            self.delegate.didError(error: error)
//        })
//    }
//
//    func jsonToString(json: [String:Any]) -> String
//    {
//        do
//        {
//            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//            print(convertedString ?? "defaultvalue")
//            return convertedString ?? ""
//        }
//        catch let myJSONError
//        {
//            print(myJSONError)
//            return ""
//        }
//
//    }
//    //MARK:- AllUsersList
//    private func UserDataJSON(data: [String : Any],completionResponse:  @escaping (GetUsersModel) -> Void,completionError: @escaping (String?) -> Void)  {
//        let userData = GetUsersModel(dict: data)
//        completionResponse(userData)
//    }
//
//    //MARK:- AddedMembers
////    private func AddedMembersJSON(data: [String : Any],completionResponse:  @escaping (AddedGroupMemberModel) -> Void,completionError: @escaping (String?) -> Void)
////    {
////        let addedMembersData = AddedGroupMemberModel(dict: data)
////        completionResponse(addedMembersData)
////
////    }
//
//}
//

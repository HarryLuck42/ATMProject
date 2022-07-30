
class Account{
  String? idUser = "";
  String? email = "";
  String? username = "";
  int? deposit = 0;


  Map<String, dynamic> toJson(){
    return {
      'uid_user': this.idUser,
      'email': this.email,
      'username': this.username,
      'deposit': this.deposit,
    };
  }
}
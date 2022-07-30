
class Debt{
  String? userId = "";
  String? username = "";
  int? debt = 0;

  Map<String, dynamic> toJson(){
    return {
      'user_id': this.userId,
      'username' : this.username,
      'debt': this.debt
    };
  }
}
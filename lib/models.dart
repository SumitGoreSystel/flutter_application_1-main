class LoginResponse {
  final bool success;
  final String message;
  final int statusCode;
  final UserData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });
}

class UserData {
  String token;
  String profileImage;
  int userId;
  String userNameInitial; // Corrected the typo in the key
  String designation;
  String emailId;
  String mobileNo;
  int roleId;

  UserData({
    required this.token,
    required this.profileImage,
    required this.userId,
    required this.userNameInitial,
    required this.designation,
    required this.emailId,
    required this.mobileNo,
    required this.roleId, required String errorMessage,
  });

  // Add a factory constructor to convert from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: json['data']['token'],
      profileImage: json['data']['profileImage'],
      userId: json['data']['userId'],
      userNameInitial: json['data']['userNameIntial'], // Corrected the typo
      designation: json['data']['designation'],
      emailId: json['data']['emailId'],
      mobileNo: json['data']['mobileNo'],
      roleId: int.parse(json['data']['roleId'].toString()), errorMessage: '',
    );
  }
}

class UserResponse {
  String token;
  int userId;
  String profileImage;
  String userName;
  String designation;
  String emailId;
  String mobileNo;
  int roleId;

  UserResponse({
    required this.token,
    required this.userId,
    required this.profileImage,
    required this.userName,
    required this.designation,
    required this.emailId,
    required this.mobileNo,
    required this.roleId,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      token: json['token'],
      userId: json['userId'],
      profileImage: json['profileImage'],
      userName: json['userName'],
      designation: json['designation'],
      emailId: json['emailId'],
      mobileNo: json['mobileNo'],
      roleId: int.parse(json['roleId'].toString().trim()), // Parsing and trimming to handle extra whitespaces
    );
  }
}



class MenuItem {
  int userId;
  int roleId;
  int menuId;
  int parentMenuId;
  int subRoleId;
  String subRoleName;
  String subRoleCode;
  String subRoleDesc;
  int displayOrder;
  int defaultChildMenuId;
  String menuIconUrl;
  String templatePath;
  int isParent;
  int childrenCount;
  int childIsParent;

  MenuItem({
    required this.userId,
    required this.roleId,
    required this.menuId,
    required this.parentMenuId,
    required this.subRoleId,
    required this.subRoleName,
    required this.subRoleCode,
    required this.subRoleDesc,
    required this.displayOrder,
    required this.defaultChildMenuId,
    required this.menuIconUrl,
    required this.templatePath,
    required this.isParent,
    required this.childrenCount,
    required this.childIsParent,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      userId: json['userId'],
      roleId: json['roleId'],
      menuId: json['menuId'],
      parentMenuId: json['parentMenuId'],
      subRoleId: json['subRoleId'],
      subRoleName: json['subRoleName'],
      subRoleCode: json['subRoleCode'],
      subRoleDesc: json['subRoleDesc'],
      displayOrder: json['displayOrder'],
      defaultChildMenuId: json['defaultChildMenuId'],
      menuIconUrl: json['menuIconUrl'],
      templatePath: json['templatePath'],
      isParent: json['isParent'],
      childrenCount: json['childrenCount'],
      childIsParent: json['childIsParent'],
    );
  }
}

class MenuData {
  List<MenuItem> items;

  MenuData({
    required this.items,
  });

  factory MenuData.fromJson(Map<String, dynamic> json) {
    List<MenuItem> menuItems = [];
    for (var item in json['items']) {
      menuItems.add(MenuItem.fromJson(item));
    }

    return MenuData(items: menuItems);
  }
}


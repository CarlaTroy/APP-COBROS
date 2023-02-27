class UserModel {
    UserModel({
        this.username,
        this.email,
        this.password,
        this.password2,
        this.is_staff,
        this.is_active,
        this.group
    });

    String? username;
    String? email;
    String? password;
    String? password2;
    bool? is_staff;
    bool? is_active;
    String? group;
}
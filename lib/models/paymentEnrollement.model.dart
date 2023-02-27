import 'dart:convert';

List<PaymentEnrollementModel> paymentEnrollementModelFromJson(String str) => List<PaymentEnrollementModel>.from(json.decode(str).map((x) => PaymentEnrollementModel.fromJson(x)));

String paymentEnrollementModelToJson(List<PaymentEnrollementModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentEnrollementModel {
    PaymentEnrollementModel({
        this.id,
        this.amount,
        this.datePay,
        this.dateLimit,
        this.statusPay,
        this.enrollement,
    });

    int? id;
    String? amount;
    DateTime? datePay;
    DateTime? dateLimit;
    Pay? statusPay;
    Enrollement? enrollement;
    

    factory PaymentEnrollementModel.fromJson(Map<String, dynamic> json) => PaymentEnrollementModel(
        id: json["id"],
        amount: json["amount"],
        datePay: DateTime.parse(json["date_pay"]),
        dateLimit: DateTime.parse(json["date_limit"]),
        statusPay: Pay.fromJson(json["status_pay"]),
        enrollement: Enrollement.fromJson(json["enrollement"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "date_pay": "${datePay!.year.toString().padLeft(4, '0')}-${datePay!.month.toString().padLeft(2, '0')}-${datePay!.day.toString().padLeft(2, '0')}",
        "date_limit": "${dateLimit!.year.toString().padLeft(4, '0')}-${dateLimit!.month.toString().padLeft(2, '0')}-${dateLimit!.day.toString().padLeft(2, '0')}",
        "status_pay": statusPay!.toJson(),
        "enrollement": enrollement!.toJson(),
    };
}

class Enrollement {
    Enrollement({
        this.id,
        this.student,
        this.cohorte,
        this.tipePay,
        this.cuotas,
        this.dayLimite,
        this.cash,
        this.discount,
        this.createdOn,
    });

    int? id;
    Student? student;
    Cohorte? cohorte;
    Pay? tipePay;
    int? cuotas;
    int? dayLimite;
    int? cash;
    int? discount;
    DateTime? createdOn;

    factory Enrollement.fromJson(Map<String, dynamic> json) => Enrollement(
        id: json["id"],
        student: Student.fromJson(json["student"]),
        cohorte: Cohorte.fromJson(json["cohorte"]),
        tipePay: Pay.fromJson(json["tipe_pay"]),
        cuotas: json["cuotas"],
        dayLimite: json["day_limite"],
        cash: json["cash"],
        discount: json["discount"],
        createdOn: DateTime.parse(json["created_on"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "student": student!.toJson(),
        "cohorte": cohorte!.toJson(),
        "tipe_pay": tipePay!.toJson(),
        "cuotas": cuotas,
        "day_limite": dayLimite,
        "cash": cash,
        "discount": discount,
        "created_on": createdOn!.toIso8601String(),
    };
}

class Cohorte {
    Cohorte({
        this.id,
        this.name,
        this.dateInit,
        this.dateEnd,
        this.costEffective,
        this.costCredit,
        this.course,
    });

    int? id;
    String? name;
    DateTime? dateInit;
    DateTime? dateEnd;
    String? costEffective;
    String? costCredit;
    Course? course;

    factory Cohorte.fromJson(Map<String, dynamic> json) => Cohorte(
        id: json["id"],
        name: json["name"],
        dateInit: DateTime.parse(json["date_init"]),
        dateEnd: DateTime.parse(json["date_end"]),
        costEffective: json["cost_effective"],
        costCredit: json["cost_credit"],
        course: Course.fromJson(json["course"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date_init": "${dateInit!.year.toString().padLeft(4, '0')}-${dateInit!.month.toString().padLeft(2, '0')}-${dateInit!.day.toString().padLeft(2, '0')}",
        "date_end": "${dateEnd!.year.toString().padLeft(4, '0')}-${dateEnd!.month.toString().padLeft(2, '0')}-${dateEnd!.day.toString().padLeft(2, '0')}",
        "cost_effective": costEffective,
        "cost_credit": costCredit,
        "course": course!.toJson(),
    };
}

class Course {
    Course({
        this.id,
        this.name,
        this.description,
        this.createdOn,
        this.updatedOn,
    });

    int? id;
    String? name;
    String? description;
    DateTime? createdOn;
    DateTime? updatedOn;

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_on": createdOn!.toIso8601String(),
        "updated_on": updatedOn!.toIso8601String(),
    };
}

class Student {
    Student({
        this.id,
        this.name,
        this.lastName,
        this.identification,
        this.cellPhone,
        this.address,
        this.user,
    });

    int? id;
    String? name;
    String? lastName;
    String? identification;
    String? cellPhone;
    String? address;
    User? user;

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        identification: json["identification"],
        cellPhone: json["cell_phone"],
        address: json["address"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "identification": identification,
        "cell_phone": cellPhone,
        "address": address,
        "user": user!.toJson(),
    };
}

class User {
    User({
        this.id,
        this.username,
        this.email,
    });

    int? id;
    String? username;
    String? email;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
    };
}

class Pay {
    Pay({
        this.id,
        this.name,
        this.codigo,
    });

    int? id;
    String? name;
    String? codigo;

    factory Pay.fromJson(Map<String, dynamic> json) => Pay(
        id: json["id"],
        name: json["name"],
        codigo: json["codigo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "codigo": codigo,
    };
}

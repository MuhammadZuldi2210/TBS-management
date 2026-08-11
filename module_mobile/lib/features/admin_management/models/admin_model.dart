// Model untuk merepresentasikan data Admin
class AdminModel {
  // ID unik admin dari MongoDB
  final String id;

  // Nama admin
  final String name;

  // Email admin
  final String email;

  // Role admin
  final String role;

  // Status aktif admin
  final bool isActive;

  // ID pemilik admin (jika ada)
  final String? ownerId;

  // Jumlah coin yang dimiliki admin
  final int coinBalance;

  // Tanggal masa aktif modul
  final DateTime? moduleExpiredAt;

  // Tanggal akun dibuat
  final DateTime? createdAt;

  // Tanggal terakhir akun diperbarui
  final DateTime? updatedAt;

  // Constructor
  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    this.ownerId,
    required this.coinBalance,
    this.moduleExpiredAt,
    this.createdAt,
    this.updatedAt,
  });

  // Factory untuk mengubah JSON menjadi object AdminModel
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      // Mengambil _id dari MongoDB
      id: json["_id"] ?? "",

      // Mengambil nama admin
      name: json["name"] ?? "",

      // Mengambil email admin
      email: json["email"] ?? "",

      // Mengambil role admin
      role: json["role"] ?? "",

      // Mengambil status aktif
      isActive: json["isActive"] ?? false,

      // Mengambil ownerId
      ownerId: json["ownerId"],

      // Mengambil jumlah coin
      coinBalance: json["coinBalance"] ?? 0,

      // Mengubah String menjadi DateTime
      moduleExpiredAt: json["moduleExpiredAt"] != null
          ? DateTime.parse(json["moduleExpiredAt"])
          : null,

      // Mengubah createdAt menjadi DateTime
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      // Mengubah updatedAt menjadi DateTime
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }

  // Mengubah object AdminModel menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "role": role,
      "isActive": isActive,
      "ownerId": ownerId,
      "coinBalance": coinBalance,
      "moduleExpiredAt": moduleExpiredAt?.toIso8601String(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}

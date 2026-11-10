class CompanySettings {
  const CompanySettings({
    this.id,
    this.companyName,
    this.factoryName,
    this.department,
    this.address,
    this.phone,
    this.email,
  });

  final int? id;
  final String? companyName;
  final String? factoryName;
  final String? department;
  final String? address;
  final String? phone;
  final String? email;

  factory CompanySettings.fromMap(Map<String, dynamic> map) {
    return CompanySettings(
      id: (map['id'] as num?)?.toInt(),
      companyName: _clean(map['company_name']),
      factoryName: _clean(map['factory_name']),
      department: _clean(map['department']),
      address: _clean(map['address']),
      phone: _clean(map['phone']),
      email: _clean(map['email']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company_name': companyName,
      'factory_name': factoryName,
      'department': department,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }

  static String? _clean(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  /// Teks untuk ditampilkan; "-" jika kosong.
  static String display(String? value) {
    return (value == null || value.isEmpty) ? '-' : value;
  }
}
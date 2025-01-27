class CheckoutDataEntity {
  String? fullName;
  String? emailAddress;
  String? phone;
  String? address;
  String? zipCode;
  String? city;
  String? country;
  CheckoutDataEntity(
      {this.address,
      this.city,
      this.country,
      this.emailAddress,
      this.fullName,
      this.phone,
      this.zipCode});

  CheckoutDataEntity copyWith({
    String? fullName,
    String? emailAddress,
    String? phone,
    String? address,
    String? zipCode,
    String? city,
    String? country,
  }) {
    return CheckoutDataEntity(
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckoutDataEntity &&
        other.fullName == fullName &&
        other.emailAddress == emailAddress &&
        other.phone == phone &&
        other.address == address &&
        other.zipCode == zipCode &&
        other.city == city &&
        other.country == country;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        emailAddress.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        zipCode.hashCode ^
        city.hashCode ^
        country.hashCode;
  }
}

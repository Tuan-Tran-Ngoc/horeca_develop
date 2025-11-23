class AddressVisitDto {
  int? customerAddressId;
  String? address;

  AddressVisitDto({this.customerAddressId, this.address});

  factory AddressVisitDto.fromMap(Map<dynamic, dynamic> map) {
    return AddressVisitDto(
        customerAddressId: map['customer_address_id'], address: map['address']);
  }
}

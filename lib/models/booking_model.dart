import 'schedule_model.dart';

class Booking {
  final int id;
  final int userId;
  final int scheduleId;
  final int quantity;
  final double totalPrice;
  final String status;
  final String? qrCodeData;
  final Schedule? schedule;

  Booking({
    required this.id,
    required this.userId,
    required this.scheduleId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    this.qrCodeData,
    this.schedule,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      scheduleId: json['schedule_id'],
      quantity: json['quantity'],
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['status'],
      qrCodeData: json['qr_code_data'],
      schedule: json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null,
    );
  }
}

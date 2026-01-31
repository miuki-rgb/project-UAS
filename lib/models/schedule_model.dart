class Schedule {
  final int id;
  final int busId;
  final int routeId;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int stockAvailable;
  final bool isActive;
  final Bus? bus;
  final RouteData? route;

  Schedule({
    required this.id,
    required this.busId,
    required this.routeId,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.stockAvailable,
    required this.isActive,
    this.bus,
    this.route,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      busId: json['bus_id'],
      routeId: json['route_id'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      price: double.parse(json['price'].toString()),
      stockAvailable: json['stock_available'] ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      bus: json['bus'] != null ? Bus.fromJson(json['bus']) : null,
      route: json['route'] != null ? RouteData.fromJson(json['route']) : null,
    );
  }
}

class Bus {
  final int id;
  final String name;
  final String plateNumber;
  final int capacity;
  final String? photo;

  Bus({
    required this.id, 
    required this.name, 
    required this.plateNumber, 
    required this.capacity,
    this.photo,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'] ?? 'Bus',
      plateNumber: json['plate_number'] ?? '-',
      capacity: json['capacity'] ?? 0,
      photo: json['photo'],
    );
  }
}

class RouteData {
  final int id;
  final String origin;
  final String destination;
  final String? distanceKm;
  final int? durationMinutes;

  RouteData({
    required this.id, 
    required this.origin, 
    required this.destination, 
    this.distanceKm,
    this.durationMinutes,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) {
    return RouteData(
      id: json['id'],
      origin: json['origin'] ?? 'Unknown',
      destination: json['destination'] ?? 'Unknown',
      distanceKm: json['distance_km']?.toString(),
      durationMinutes: json['duration_minutes'],
    );
  }
}
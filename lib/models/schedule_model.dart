class Schedule {
  final int id;
  final int busId;
  final int routeId;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final int stockAvailable;
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
      stockAvailable: json['stock_available'],
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

  Bus({required this.id, required this.name, required this.plateNumber, required this.capacity});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      name: json['name'],
      plateNumber: json['plate_number'], // Adjust based on actual DB column if different
      capacity: json['capacity'],
    );
  }
}

class RouteData {
  final int id;
  final String origin;
  final String destination;
  final double distance;

  RouteData({required this.id, required this.origin, required this.destination, required this.distance});

  factory RouteData.fromJson(Map<String, dynamic> json) {
    return RouteData(
      id: json['id'],
      origin: json['origin'],
      destination: json['destination'],
      distance: double.parse((json['distance_km'] ?? json['distance'] ?? 0).toString()),
    );
  }
}

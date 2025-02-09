class WorkDay {
  final int? id; 
  final String date;
  final String? arrivalTime;
  final String? departureTime;

  WorkDay({
    this.id,  
    required this.date,
    this.arrivalTime,
    this.departureTime,
  });

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    return WorkDay(
      id: json['id'],  
      date: json['date'],
      arrivalTime: json['arrival_time'],
      departureTime: json['departure_time'],
    );
  }
}

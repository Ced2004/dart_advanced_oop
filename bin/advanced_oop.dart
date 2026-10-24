abstract class Maintainable {
  void performMaintenance();
}

mixin GPSLocatable {
  void trackLocation(String vehicleId) {
    print('[GPS TRACKER]: Vehicle $vehicleId is currently live on route tracking system.');
  }
}

abstract class Vehicle implements Maintainable {
  String vehicleId;
  String routeName;
  int passengerCapacity;
  double baseFare;

  Vehicle({
    required this.vehicleId,
    required this.routeName,
    required this.passengerCapacity,
    required this.baseFare,
  });

  double calculateFare(int distanceInKm);

  void displayInfo() {
    print('ID: $vehicleId | Route: $routeName | Capacity: $passengerCapacity');
  }
}

class TraditionalJeepney extends Vehicle with GPSLocatable {
  TraditionalJeepney({
    required String vehicleId,
    required String routeName,
    required int passengerCapacity,
  }) : super(
          vehicleId: vehicleId,
          routeName: routeName,
          passengerCapacity: passengerCapacity,
          baseFare: 13.00,
        );

  @override
  double calculateFare(int distanceInKm) {
    if (distanceInKm <= 4) return baseFare;
    return baseFare + ((distanceInKm - 4) * 1.75);
  }

  @override
  void performMaintenance() {
    print('   [MAINTENANCE]: Changing engine oil and checking brakes for Traditional Jeep $vehicleId.');
  }
}

class ModernElectricJeepney extends Vehicle implements Maintainable {
  bool hasAircon;

  ModernElectricJeepney({
    required String vehicleId,
    required String routeName,
    required int passengerCapacity,
    this.hasAircon = true,
  }) : super(
          vehicleId: vehicleId,
          routeName: routeName,
          passengerCapacity: passengerCapacity,
          baseFare: 15.00,
        );

  @override
  double calculateFare(int distanceInKm) {
    double fare = distanceInKm <= 4 ? baseFare : baseFare + ((distanceInKm - 4) * 2.00);
    return hasAircon ? fare + 2.00 : fare;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('   Type: Modern E-Jeepney | Airconditioned: $hasAircon');
  }

  @override
  void performMaintenance() {
    print('   [MAINTENANCE]: Diagnostics check on battery cells and AC unit for E-Jeep $vehicleId.');
  }
}

void main() {
  print('=== NTC ADVANCED PUBLIC TRANSIT SYSTEM ===\n');

  TraditionalJeepney traditionalJeep = TraditionalJeepney(
    vehicleId: 'TJ-101',
    routeName: 'Quiapo - Espana',
    passengerCapacity: 18,
  );

  ModernElectricJeepney modernJeep = ModernElectricJeepney(
    vehicleId: 'EJ-202',
    routeName: 'Cubao - Divisoria',
    passengerCapacity: 24,
    hasAircon: true,
  );

  List<Vehicle> transitFleet = [traditionalJeep, modernJeep];

  int tripDistance = 8;

  print('--- FLEET FARE COMPUTATION & POLYMORPHISM ($tripDistance km trip) ---');
  for (var vehicle in transitFleet) {
    vehicle.displayInfo();
    double totalFare = vehicle.calculateFare(tripDistance);
    print('   Calculated Fare: ₱${totalFare.toStringAsFixed(2)}');

    vehicle.performMaintenance();

    if (vehicle is GPSLocatable) {
      (vehicle as GPSLocatable).trackLocation(vehicle.vehicleId);
    }
    print('----------------------------------');
  }
}

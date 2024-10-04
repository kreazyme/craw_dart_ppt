abstract class Vehicle {
  void drive();

  void makeNoise() {
    print('Vehicle noise');
  }
}

class Car implements Vehicle {
  @override
  void drive() {
    // TODO: implement drive
  }

  @override
  void makeNoise() {
    // TODO: implement makeNoise
  }
}

class Bike extends Vehicle {
  @override
  void drive() {
    const _Test();
  }
}

class _Test {}

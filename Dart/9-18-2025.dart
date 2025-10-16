




abstract class Fly
{
  void flying()
  {
    print("Flying");
  }
}

abstract class Vehicle //using absract means that you cannot create an object of this class directly (no vehicle but you can make children classes)
{
  void start()
  {
    print("Vehicle started");
  }
  void stop()
  {
    print("Vehicle stopped");
  }
}

class Car extends Vehicle 
{
  @override
  void start()
  {
    print("Car started");
  }

  @override
  void stop()
  {
    print("Car stopped");
  }
}

class Bike implements Vehicle, Fly //Using implement means that you promise to use all methods inside the parent class
//implement allows you to inherit from multiple classes while extend only allows for inheritence from a single class
{
  @override
  void start()
  {
    print("Bike started");
  }

  @override
  void stop()
  {
    print("Bike stopped");
  }
  @override
  void flying()
  {
    print("Bike is flying");
  }
}

void main()
{
  Car myCar = Car();
  myCar.start();
  myCar.stop();
}
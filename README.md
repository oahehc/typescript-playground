## Basic Types

- boolean, number, string, null, undefined
- array: string[]
- tuple: [string, number]
- enum
- unknown
- any
- void
- never
- object

## type assertion

```ts
let someValue: any = "this is a string";

let strLength: number = (someValue as string).length;
let strLength: number = (<string>someValue).length;
```

## interface

```ts
interface Point {
  color: string;
  width?: number; // optional
  readonly x: number;
  [propName: string]: any; // Excess Property
}
```

- let ro: ReadonlyArray<number> = a;

```ts
// function
interface SearchFunc {
  (source: string, subString: string): boolean; // function
}
```

```ts
// indexable
interface NumberOrStringDictionary {
  [index: string]: number | string;
  length: number;
  name: string;
}
```

```ts
// class
interface ClockInterface {
  currentTime: Date;
}

class Clock implements ClockInterface {
  currentTime: Date = new Date();
  constructor(h: number, m: number) {}
}
```

```ts
// extends
interface Shape {
  color: string;
}

interface PenStroke {
  penWidth: number;
}

interface Square extends Shape, PenStroke {
  sideLength: number;
}
```

```ts
class Control {
  private state: any;
}

interface SelectableControl extends Control {
  select(): void;
}

class Button extends Control implements SelectableControl {
  select() {}
}
```

## function

```ts
function buildName(firstName = "Smith", lastName?: string) {
  if (!lastName) return firstName;
  return firstName + " " + lastName;
}

function buildName(firstName: string, ...restOfName: string[]) {
  return firstName + " " + restOfName.join(" ");
}
```

```ts
// this
interface Card {
  suit: string;
  card: number;
}

interface Deck {
  suits: string[];
  cards: number[];
  createCardPicker(this: Deck): () => Card;
}

let deck: Deck = {
  suits: ["hearts", "spades", "clubs", "diamonds"],
  cards: Array(52),
  // NOTE: The function now explicitly specifies that its callee must be of type Deck
  createCardPicker: function (this: Deck) {
    return () => {
      let pickedCard = Math.floor(Math.random() * 52);
      let pickedSuit = Math.floor(pickedCard / 13);

      return { suit: this.suits[pickedSuit], card: pickedCard % 13 };
    };
  },
};
```

```ts
// overloads
function pickCard(x: { suit: string; card: number }[]): number;
function pickCard(x: number): { suit: string; card: number };
function pickCard(x: any): any {
  // Check to see if we're working with an object/array
  // if so, they gave us the deck and we'll pick the card
  if (typeof x == "object") {
    let pickedCard = Math.floor(Math.random() * x.length);
    return pickedCard;
  }
  // Otherwise just let them pick the card
  else if (typeof x == "number") {
    let pickedSuit = Math.floor(x / 13);
    return { suit: suits[pickedSuit], card: x % 13 };
  }
}
```

## Literal Types

```ts
type Easing = "ease-in" | "ease-out" | "ease-in-out";
```

```ts
interface ValidationSuccess {
  isValid: true;
  reason: null;
}

interface ValidationFailure {
  isValid: false;
  reason: string;
}

type ValidationResult = ValidationSuccess | ValidationFailure;
```

## Union Types

```ts
type NetworkLoadingState = {
  state: "loading";
};

type NetworkFailedState = {
  state: "failed";
  code: number;
};

type NetworkSuccessState = {
  state: "success";
  response: {
    title: string;
    duration: number;
    summary: string;
  };
};

type NetworkState =
  | NetworkLoadingState
  | NetworkFailedState
  | NetworkSuccessState;
```

## Intersection Types

```ts
interface ErrorHandling {
  success: boolean;
  error?: { message: string };
}

interface ArtworksData {
  artworks: { title: string }[];
}

interface ArtistsData {
  artists: { name: string }[];
}

type ArtworksResponse = ArtworksData & ErrorHandling;
type ArtistsResponse = ArtistsData & ErrorHandling;
```

## Classes

```ts
class Greeter {
  greeting: string;

  constructor(message: string) {
    this.greeting = message;
  }

  greet() {
    return "Hello, " + this.greeting;
  }
}

let greeter = new Greeter("world");
```

```ts
// inheritance
class Animal {
  name: string;
  constructor(theName: string) {
    this.name = theName;
  }
  move(distanceInMeters: number = 0) {
    console.log(`${this.name} moved ${distanceInMeters}m.`);
  }
}

class Snake extends Animal {
  constructor(name: string) {
    super(name);
  }
  move(distanceInMeters = 5) {
    console.log("Slithering...");
    super.move(distanceInMeters);
  }
}
```

```ts
// Private
// With TypeScript 3.8, TypeScript supports the new JavaScript syntax for private fields:
class Animal {
  #name: string;
  constructor(theName: string) {
    this.#name = theName;
  }
}
```

```ts
// protected
// acts much like the private modifier with the exception that members declared protected can also be accessed within deriving classes.
class Person {
  protected name: string;
  constructor(name: string) {
    this.name = name;
  }
}
```

```ts
// Readonly
class Octopus {
  readonly name: string;
  readonly numberOfLegs: number = 8;

  constructor(theName: string) {
    this.name = theName;
  }
}
```

```ts
// getter and setter
const fullNameMaxLength = 10;

class Employee {
  private _fullName: string;

  get fullName(): string {
    return this._fullName;
  }

  set fullName(newName: string) {
    if (newName && newName.length > fullNameMaxLength) {
      throw new Error("fullName has a max length of " + fullNameMaxLength);
    }

    this._fullName = newName;
  }
}
```

```ts
// Static
class Grid {
  static origin = { x: 0, y: 0 };

  calculateDistanceFromOrigin(point: { x: number; y: number }) {
    let xDist = point.x - Grid.origin.x;
    let yDist = point.y - Grid.origin.y;
    return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
  }

  constructor(public scale: number) {}
}
```

```ts
// Abstract
// Unlike an interface, an abstract class may contain implementation details for its members
abstract class Animal {
  // not contain an implementation, must be implemented in derived classes
  abstract makeSound(): void;

  // contain an implementation
  move(): void {
    console.log("roaming the earth...");
  }
}
```

## enum

```ts
enum LogLevel {
  ERROR,
  WARN,
  INFO,
  DEBUG,
}

/**
 * This is equivalent to:
 * type LogLevelStrings = 'ERROR' | 'WARN' | 'INFO' | 'DEBUG';
 */
type LogLevelStrings = keyof typeof LogLevel;
```

```ts
// Reverse mappings
enum Enum {
  A,
}

let a = Enum.A;
let nameOfA = Enum[a]; // "A"
```

```ts
// Const enums are completely removed during compilation
const enum Directions {
  Up,
  Down,
  Left,
  Right,
}
```

## Generics

```ts
// generic interface
interface GenericIdentityFn {
  <T>(arg: T): T;
}

function identity<T>(arg: T): T {
  return arg;
}

let myIdentity: GenericIdentityFn = identity;
```

```ts
// move generic to parameter
interface GenericIdentityFn<T> {
  (arg: T): T;
}

function identity<T>(arg: T): T {
  return arg;
}

let myIdentity: GenericIdentityFn<number> = identity;
```

```ts
// Generic Classes
class GenericNumber<T> {
  zeroValue: T;
  add: (x: T, y: T) => T;
}

let myGenericNumber = new GenericNumber<number>();
```

```ts
// extends property
interface Lengthwise {
  length: number;
}

function loggingIdentity<T extends Lengthwise>(arg: T): T {
  console.log(arg.length); // Now we know it has a .length property, so no more error
  return arg;
}
```

```ts
// Using Type Parameters
function getProperty<T, K extends keyof T>(obj: T, key: K) {
  return obj[key];
}
```

```ts
// Using Class Types
function create<T>(c: { new (): T }): T {
  return new c();
}
```

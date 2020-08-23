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

## Advanced Types

```ts
// type guards
if ("swim" in pet) {
  pet.swim();
}

// or

if (typeof padding === "number") {
  return Array(padding + 1).join(" ") + value;
}

// or

if (padder instanceof SpaceRepeatingPadder) {
  //...
}
```

```ts
// type predicates
function isFish(pet: Fish | Bird): pet is Fish {
  return (pet as Fish).swim !== undefined;
}
```

```ts
// identifier `!` removes null and undefined
interface UserAccount {
  id: number;
  email?: string;
}

const user = getUser("admin");

if (user) {
  // user.email.length; // Object is possibly 'undefined'.
  user!.email!.length;
}
```

```ts
type LinkedList<Type> = Type & { next: LinkedList<Type> };

interface Person {
  name: string;
}

let people: LinkedList<Person> = getDriversLicenseQueue();
/*
people.name;
people.next.name;
people.next.next.name;
people.next.next.next.name;
...
*/
```

```ts
// Index types: K extends keyof T
function pluck<T, K extends keyof T>(o: T, propertyNames: K[]): T[K][] {
  return propertyNames.map((n) => o[n]);
}
```

```ts
// Mapped types
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

type PartialWithNewMember<T> = {
  [P in keyof T]?: T[P];
} & { newMember: boolean }; // this syntax describes a type rather than a member. If you want to add members, you can use an intersection type

type Nullable<T> = { [P in keyof T]: T[P] | null };

type Pick<T, K extends keyof T> = {
  [P in K]: T[P];
};

type Record<K extends keyof any, T> = {
  [P in K]: T;
};
```

```ts
// Conditional Types : T extends U ? X : Y
type TypeName<T> = T extends string
  ? "string"
  : T extends number
  ? "number"
  : T extends boolean
  ? "boolean"
  : T extends undefined
  ? "undefined"
  : T extends Function
  ? "function"
  : "object";

type Diff<T, U> = T extends U ? never : T;
type Filter<T, U> = T extends U ? T : never;
```

```ts
// Type inference
type Foo<T> = T extends { a: infer U; b: infer U } ? U : never;

type T1 = Foo<{ a: string; b: string }>;
//   ^ = type T1 = string
type T2 = Foo<{ a: string; b: number }>;
//   ^ = type T2 = string | number
```

## Utility Types

```ts
Partial<Type>
Readonly<Todo>
Required<Type>
Record<Keys,Type>
Pick<Type, Keys>
Omit<Type, Keys>
Exclude<Type, ExcludedUnion>
Extract<Type, Union>
NonNullable<Type>

Parameters<Type>
ConstructorParameters<Type>
ReturnType<Type>
InstanceType<Type>

ThisParameterType<Type>
OmitThisParameter<Type>
ThisType<Type>
```

## decorator

```ts
function f() {
  console.log("f(): evaluated");
  return function (
    target,
    propertyKey: string,
    descriptor: PropertyDescriptor
  ) {
    console.log("f(): called");
  };
}

class C {
  @f()
  method() {
    console.log("method");
  }
}
```

## Declaration Merging

```ts
// Merging Interfaces

interface Box {
  height: number;
  width: number;
}

interface Box {
  scale: number;
}

let box: Box = { height: 5, width: 6, scale: 10 };
```

```ts
// Merging Namespaces
namespace Animals {
  export class Zebra {}
}
namespace Animals {
  export interface Legged {
    numberOfLegs: number;
  }
  export class Dog {}
}

// equivalent to
namespace Animals {
  export interface Legged {
    numberOfLegs: number;
  }

  export class Zebra {}
  export class Dog {}
}
```

## Module Augmentation

```ts
// observable.ts
export class Observable<T> {
  // ... implementation left as an exercise for the reader ...
}

// map.ts
import { Observable } from "./observable";
declare module "./observable" {
  interface Observable<T> {
    map<U>(f: (x: T) => U): Observable<U>;
  }
}
Observable.prototype.map = function (f) {
  // ... another exercise for the reader
};

// consumer.ts
import { Observable } from "./observable";
import "./map";
let o: Observable<number>;
o.map((x) => x.toFixed());
```

```ts
// Global augmentation
// observable.ts
export class Observable<T> {
  // ... still no implementation ...
}

declare global {
  interface Array<T> {
    toObservable(): Observable<T>;
  }
}

Array.prototype.toObservable = function () {
  // ...
};
```

## modules

```ts
// re-exports
export { ZipCodeValidator as RegExpBasedZipCodeValidator } from "./ZipCodeValidator";
export * from "./StringValidator";
export * as utilities from "./utilities";
```

```ts
// Importing Types
// Re-using the same import
import { APIResponseType } from "./api";

// Explicitly use import type -> guaranteed to be removed from your JavaScript
import type { APIResponseType } from "./api";
```

```ts
// Ambient Modules
// @node.d.ts (simplified excerpt)
declare module "url" {
  export interface Url {
    protocol?: string;
    hostname?: string;
    pathname?: string;
  }

  export function parse(
    urlStr: string,
    parseQueryString?,
    slashesDenoteHost?
  ): Url;
}

// @other files
/// <reference path="node.d.ts"/>
import * as URL from "url";
let myUrl = URL.parse("http://www.typescriptlang.org");
```

```ts
// Shorthand ambient modules -> All imports from a shorthand module will have the any type
declare module "hot-new-module";
```

```ts
// Wildcard module declarations
declare module "*!text" {
  const content: string;
  export default content;
}
declare module "json!*" {
  const value: any;
  export default value;
}
```

## Namespaces

```ts
// Validation.ts
namespace Validation {
  export interface StringValidator {
    isAcceptable(s: string): boolean;
  }
}

//LettersOnlyValidator.ts
/// <reference path="Validation.ts" />
namespace Validation {
  const lettersRegexp = /^[A-Za-z]+$/;
  export class LettersOnlyValidator implements StringValidator {
    isAcceptable(s: string) {
      return lettersRegexp.test(s);
    }
  }
}

// ZipCodeValidator.ts
/// <reference path="Validation.ts" />
namespace Validation {
  const numberRegexp = /^[0-9]+$/;
  export class ZipCodeValidator implements StringValidator {
    isAcceptable(s: string) {
      return s.length === 5 && numberRegexp.test(s);
    }
  }
}
```

```ts
// Ambient Namespaces

// D3.d.ts (simplified excerpt)
declare namespace D3 {
  export interface Selectors {
    select: {
      (selector: string): Selection;
      (element: EventTarget): Selection;
    };
  }

  export interface Event {
    x: number;
    y: number;
  }

  export interface Base extends Selectors {
    event: Event;
  }
}

declare var d3: D3.Base;
```

---

## 4.0: https://devblogs.microsoft.com/typescript/announcing-typescript-4-0/

```ts
type Unbounded = [...Strings, ...Numbers, boolean];

// Labeled Tuple Elements
type Range = [start: number, end: number];

// Short-Circuiting Assignment Operators
&&=, ||=, ??=

// /** @deprecated */ Support
let obj = {
  /** @deprecated */
  someMethod() { ... }
}
```

---

## Interfaces vs. Type Aliases

interface more closely maps how JavaScript object, recommend using an interface over a type alias when possible.

```ts
interface Animal {
  name: string;
}

interface Bear extends Animal {
  honey: boolean;
}

//...

type Animal = {
  name: string;
};

type Bear = Animal & {
  honey: Boolean;
};
```

```ts
// `interface` cna adding new fields to an existing interface
interface Window {
  title: string;
}

interface Window {
  ts: import("typescript");
}
```

## Namespaces and Modules

### Using Modules

- Modules can contain both code and declarations.
- for Node.js applications, modules are the default and we recommended modules over namespaces in modern code.
- for new projects modules would be the recommended code organization mechanism.

### Using Namespaces

- Namespaces are a TypeScript-specific way to organize code.
- Namespaces can be a good way to structure your code in a Web Application, with all dependencies included as <script> tags in your HTML page.

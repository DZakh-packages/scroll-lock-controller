/* TypeScript file generated from Manager.resi by genType. */
/* eslint-disable import/first */


// @ts-ignore: Implicit any on import
import * as Curry__Es6Import from 'rescript/lib/es6/curry.js';
const Curry: any = Curry__Es6Import;

// @ts-ignore: Implicit any on import
import * as ManagerBS__Es6Import from './Manager.bs';
const ManagerBS: any = ManagerBS__Es6Import;

import type {element as Dom_element} from '../src/shims/Dom.shim';

// tslint:disable-next-line:interface-over-type-literal
export type targetElements = Dom_element[];

// tslint:disable-next-line:interface-over-type-literal
export type pluginHooks = {
  readonly onBodyScrollLock?: () => void; 
  readonly onBodyScrollUnlock?: () => void; 
  readonly onLockTargetsAdd?: (_1:targetElements) => void; 
  readonly onLockTargetsRemove?: (_1:targetElements) => void
};

// tslint:disable-next-line:interface-over-type-literal
export type pluginFactory = () => pluginHooks;

// tslint:disable-next-line:max-classes-per-file 
// tslint:disable-next-line:class-name
export abstract class t { protected opaque!: any }; /* simulate opaque types */

export const make: (_1:{ readonly plugins?: pluginFactory[] }, _2:void) => t = function (Arg1: any, Arg2: any) {
  const result = Curry._2(ManagerBS.make, Arg1.plugins, Arg2);
  return result
};

export const lock: (_1:t, _2:targetElements) => void = function (Arg1: any, Arg2: any) {
  const result = Curry._2(ManagerBS.lock, Arg1, Arg2);
  return result
};

export const unlock: (_1:t, _2:targetElements) => void = function (Arg1: any, Arg2: any) {
  const result = Curry._2(ManagerBS.unlock, Arg1, Arg2);
  return result
};

export const clear: (_1:t) => void = ManagerBS.clear;

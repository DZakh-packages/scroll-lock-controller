import * as Manager from './Manager.gen';
export type { pluginFactory, targetElements, pluginHooks } from './Manager.gen'

export const makeScrollockManager = (_1: { readonly plugins?: Manager.pluginFactory[] }) => {
  const scrollock = Manager.make(_1);

  const lock = (targetElements: Manager.targetElements) => {
    Manager.lock(scrollock, targetElements);
  };

  const unlock = (targetElements: Manager.targetElements) => {
    Manager.unlock(scrollock, targetElements);
  };

  const clear = () => {
    Manager.clear(scrollock);
  };

  return {
    lock,
    unlock,
    clear,
  }
}
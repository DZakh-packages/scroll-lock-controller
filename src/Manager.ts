import * as Manager from './Manager.gen';
export type { pluginFactory, targetElements, pluginHooks } from './Manager.gen'

export const makeScrollokManager = (_1: { readonly plugins?: Manager.pluginFactory[] }) => {
  const scrollok = Manager.make(_1);

  const lock = (targetElements: Manager.targetElements) => {
    Manager.lock(scrollok, targetElements);
  };

  const unlock = (targetElements: Manager.targetElements) => {
    Manager.unlock(scrollok, targetElements);
  };

  const clear = () => {
    Manager.clear(scrollok);
  };

  return {
    lock,
    unlock,
    clear,
  }
}
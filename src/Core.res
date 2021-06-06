module LocksSet = {
  type lock = Dom.element
  type locks = array<lock>
  type t = ref<locks>

  let uniq: Scrollock__Helpers.uniq<lock> = Scrollock__Helpers.uniq

  let make = (): t => {
    ref([])
  }

  let isEmpty = (it: t) => {
    Scrollock__Helpers.isEmptyArray(it.contents)
  }

  let getCurrentLocks = (it: t) => {
    it.contents
  }

  let isExistingLock = (it: t, lock: lock) => {
    it.contents->Js.Array2.some(entityLock => {
      entityLock === lock
    })
  }

  let add = (it: t, locks: locks) => {
    let uniqLocks = uniq(locks)

    let added = uniqLocks->Js.Array2.filter(lock => {
      !(it->isExistingLock(lock))
    })

    it := it.contents->Js.Array2.concat(added)

    added
  }

  let remove = (it: t, locks: locks) => {
    let removingLocksRef = ref(uniq(locks))
    let removedRef = ref([])

    it :=
      it.contents->Js.Array2.filter(existingLock => {
        let removingLockIdx = removingLocksRef.contents->Js.Array2.indexOf(existingLock)
        let isRemovingLock = removingLockIdx >= 0

        let removedLocks =
          removingLocksRef.contents->Js.Array2.removeCountInPlace(~count=1, ~pos=removingLockIdx)

        removedRef := removedRef.contents->Js.Array2.concat(removedLocks)

        !isRemovingLock
      })

    removedRef.contents
  }
}

module TrackedValue = {
  type t<'curValue> = {valueRef: ref<'curValue>, onChange: 'curValue => unit}

  let make = (~onChage, ~defaultValue): t<'curValue> => {
    {valueRef: ref(defaultValue), onChange: onChage}
  }

  let set = (it: t<'curValue>, valueGetter) => {
    let prevValue = it.valueRef.contents
    let newValue = valueGetter(. prevValue)

    switch newValue !== prevValue {
    | true => {
        it.valueRef := newValue
        it.onChange(newValue)
      }
    | false => ()
    }
  }
}

type targetElements = LocksSet.locks

type onLockTargetsAdd = targetElements => unit
type onLockTargetsRemove = targetElements => unit

type t = {
  locks: LocksSet.t,
  isLocked: TrackedValue.t<bool>,
  onLockTargetsAdd: option<onLockTargetsAdd>,
  onLockTargetsRemove: option<onLockTargetsRemove>,
}
type hooks = {
  onBodyScrollLock: option<unit => unit>,
  onBodyScrollUnlock: option<unit => unit>,
  onLockTargetsAdd: option<targetElements => unit>,
  onLockTargetsRemove: option<targetElements => unit>,
}

let make = ({onBodyScrollLock, onBodyScrollUnlock, onLockTargetsAdd, onLockTargetsRemove}): t => {
  let locks = LocksSet.make()

  let isLocked = TrackedValue.make(~onChage=newIsLocked => {
    switch (newIsLocked, onBodyScrollLock, onBodyScrollUnlock) {
    | (true, Some(onBodyScrollLockCb), _) => onBodyScrollLockCb()
    | (false, _, Some(onBodyScrollUnlockCb)) => onBodyScrollUnlockCb()
    | (_, _, _) => ()
    }
  }, ~defaultValue=false)

  {
    locks: locks,
    isLocked: isLocked,
    onLockTargetsAdd: onLockTargetsAdd,
    onLockTargetsRemove: onLockTargetsRemove,
  }
}

let isBodyScrollLocked = (it: t) => {
  !(it.locks->LocksSet.isEmpty)
}

let lock = (it: t, targetElements) => {
  let added = it.locks->LocksSet.add(targetElements)
  let hasAddedTargetElements = added->Js.Array2.length > 0

  added->Js.Array2.forEach(targetElement => {
    targetElement->BodyScrollLock.disableBodyScroll(
      ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
      (),
    )
  })

  it.isLocked->TrackedValue.set((. _) => it->isBodyScrollLocked)

  switch (it.onLockTargetsAdd, hasAddedTargetElements) {
  | (Some(onLockTargetsAdd), true) => onLockTargetsAdd(added)
  | (_, _) => ()
  }
}

let unlock = (it: t, targetElements) => {
  let removed = it.locks->LocksSet.remove(targetElements)
  let hasRemovedTargetElements = removed->Js.Array2.length > 0

  removed->Js.Array2.forEach(targetElement => {
    targetElement->BodyScrollLock.enableBodyScroll
  })

  it.isLocked->TrackedValue.set((. _) => it->isBodyScrollLocked)

  switch (it.onLockTargetsRemove, hasRemovedTargetElements) {
  | (Some(onLockTargetsRemove), true) => onLockTargetsRemove(removed)
  | (_, _) => ()
  }
}

let clear = (it: t) => {
  it->unlock(it.locks->LocksSet.getCurrentLocks)
}

let isServer = Js.Types.test(Webapi.Dom.window, Undefined)

let uniq: array<'a> => array<'a> = %raw("(array) => [...new Set(array)]")

let isEmptyArray = array => array->Js.Array2.length === 0

module LocksSet = {
  type lock = Dom.element
  type locks = array<lock>
  type t = ref<locks>

  type addResult = {
    new: locks,
    existing: locks,
  }

  let make = (): t => {
    ref([])
  }

  let isEmpty = (entity: t) => {
    isEmptyArray(entity.contents)
  }

  let isExistingLock = (entity: t, lock: lock) => {
    entity.contents->Js.Array2.some(entityLock => {
      entityLock === lock
    })
  }

  let add = (entity: t, locks: locks) => {
    let uniqLocks = uniq(locks)

    let added = uniqLocks->Js.Array2.filter(lock => {
      !(entity->isExistingLock(lock))
    })

    entity := entity.contents->Js.Array2.concat(added)

    added
  }

  let remove = (entity: t, locks: locks) => {
    let removingLocksRef = ref(uniq(locks))
    let removedRef = ref([])

    entity :=
      entity.contents->Js.Array2.filter(existingLock => {
        let removingLockIdx = removingLocksRef.contents->Js.Array2.indexOf(existingLock)
        let isRemovingLock = removingLockIdx >= 0

        let removedLocks =
          removingLocksRef.contents->Js.Array2.removeCountInPlace(~count=1, ~pos=removingLockIdx)

        removedRef := removedRef.contents->Js.Array2.concat(removedLocks)

        !isRemovingLock
      })

    removingLocksRef.contents
  }
}

module TrackedValue = {
  type t<'curValue> = {valueRef: ref<'curValue>, onChange: 'curValue => unit}

  let make = (~onChage, ~defaultValue): t<'curValue> => {
    {valueRef: ref(defaultValue), onChange: onChage}
  }

  let set = (entity: t<'curValue>, valueGetter) => {
    let prevValue = entity.valueRef.contents
    let newValue = valueGetter(. prevValue)

    switch newValue !== prevValue {
    | true => {
        entity.valueRef := newValue
        entity.onChange(newValue)
      }
    | false => ()
    }
  }

  let get = (entity: t<'curValue>) => {
    entity.valueRef.contents
  }
}

let checkIsElementNode: Dom.node => bool = %raw("(node) => node instanceof Element")
external convertNodeToElement: Dom.node => Dom.element = "%identity"
let convertNodeToElement = node => {
  switch checkIsElementNode(node) {
  | true => Some(convertNodeToElement(node))
  | false => None
  }
}

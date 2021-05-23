let isServer = Js.Types.test(Webapi.Dom.window, Undefined)

let uniq: array<'a> => array<'a> = %raw("(array) => [...new Set(array)]")

let isEmpty = array => array->Js.Array2.length === 0

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
    isEmpty(entity.contents)
  }

  let isExistingLock = (entity: t, lock: lock) => {
    entity.contents->Js.Array2.some(entityLock => {
      entityLock === lock
    })
  }

  let add = (entity: t, locks: locks) => {
    let uniqLocks = uniq(locks)
    let result = uniqLocks->Js.Array2.reduce((acc, lock) => {
      switch entity->isExistingLock(lock) {
      | true => {new: acc.new, existing: acc.existing->Js.Array2.concat([lock])}
      | false => {new: acc.new->Js.Array2.concat([lock]), existing: acc.existing}
      }
    }, {new: [], existing: []})

    entity := entity.contents->Js.Array2.concat(result.new)

    result
  }

  let remove = (entity: t, lock: lock) => {
    entity.contents =
      entity.contents->Js.Array2.filter(existingLock => {
        existingLock !== lock
      })
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

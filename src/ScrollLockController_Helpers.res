module Environment = {
  open Webapi.Dom

  let isServer = Js.Types.test(window, Undefined)
}

module LocksSet = {
  type t = ref<array<Dom.element>>

  let make = (): t => {
    ref([])
  }

  // let isEmpty = value => {
  //   value.contents->Js.Array2.length === 0
  // }

  let add = (entity, lock) => {
    entity.contents = entity.contents->Js.Array2.concat([lock])
  }

  let remove = (entity: t, lock) => {
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

  let set = (entity, valueGetter) => {
    let prevValue = entity.valueRef.contents
    let newValue = valueGetter(. prevValue)

    switch newValue !== prevValue {
    | true => {
        entity.valueRef.contents = newValue
        entity.onChange(newValue)
      }
    | false => ()
    }
  }

  let get = entity => {
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

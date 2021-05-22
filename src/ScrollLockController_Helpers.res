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

  let add = (value, lock) => {
    value.contents = value.contents->Js.Array2.concat([lock])
  }

  let remove = (value: t, lock) => {
    value.contents =
      value.contents->Js.Array2.filter(existingLock => {
        existingLock !== lock
      })
  }
}

module TrackedValue = {
  type t<'curValue> = {valueRef: ref<'curValue>, onChange: 'curValue => unit}

  type setOptions = {silent: bool}

  let make = (~onChage, ~defaultValue): t<'curValue> => {
    {valueRef: ref(defaultValue), onChange: onChage}
  }

  let set = (value, ~options=?, valueGetter) => {
    let prevValue = value.valueRef.contents
    let newValue = valueGetter(. prevValue)
    let isValueChanged = newValue !== prevValue

    if isValueChanged {
      value.valueRef.contents = newValue

      switch options {
      | Some({silent}) =>
        if silent === true {
          value.onChange(newValue)
        }
      | None => ()
      }
    }
  }

  let get = value => {
    value.valueRef.contents
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

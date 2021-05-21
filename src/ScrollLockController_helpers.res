module Environment = {
  open Webapi.Dom

  let isServer = Js.Types.test(window, Undefined)
}

module TrackedValue = {
  type updateValueOptions = {silent: bool}
  type controls<'value> = {
    getValue: unit => 'value,
    setValue: (~options: updateValueOptions=?, (. 'value) => 'value) => unit,
  }

  let create = (~onChage, ~defaultValue: 'value): controls<'value> => {
    let valueRef = ref(defaultValue)

    let updateValue = (newValue, options) => {
      valueRef.contents = newValue

      switch options {
      | Some({silent}) =>
        if silent === true {
          onChage(. newValue)
        }
      | None => ()
      }
    }

    let setValue = (~options=?, valueGetter) => {
      let prevValue = valueRef.contents
      let newValue = valueGetter(. prevValue)
      let isValueChanged = newValue !== prevValue

      if isValueChanged {
        updateValue(newValue, options)
      }
    }

    let getValue = () => {
      valueRef.contents
    }

    {
      getValue: getValue,
      setValue: setValue,
    }
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

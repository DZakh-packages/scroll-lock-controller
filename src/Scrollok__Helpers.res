type uniq<'a> = array<'a> => array<'a>
let uniq = %raw("(array) => [...new Set(array)]")

let isEmptyArray = array => array->Js.Array2.length === 0

let isServer = Js.Types.test(Webapi.Dom.window, Undefined)

let checkIsElementNode: Dom.node => bool = %raw("(node) => node instanceof Element")
external convertNodeToElement: Dom.node => Dom.element = "%identity"
let convertNodeToElement = node => {
  switch checkIsElementNode(node) {
  | true => Some(convertNodeToElement(node))
  | false => None
  }
}

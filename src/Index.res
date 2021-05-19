%%raw(`import './style.css';`)

open Webapi.Dom

let renderApp = appEl => {
  appEl->Element.setInnerHTML(`
    <h1>Hello Vite!</h1>
    <a href="https://vitejs.dev/guide/features.html" target="_blank">Documentation</a>
  `)
}

switch document |> Document.querySelector("#app") {
| Some(appEl) => renderApp(appEl)
| None => () // do nothing
}

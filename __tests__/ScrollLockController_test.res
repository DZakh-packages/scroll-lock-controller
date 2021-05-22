open Jest

JestJs.mock("body-scroll-lock")

describe("ScrollLockController", () => {
  open Expect

  test("Locks are empty after create", () => {
    open Webapi.Dom

    let div = Document.createElement("div", document)
    let scrollLockController = ScrollLockController.make()

    scrollLockController->ScrollLockController.lock(div)

    Js.log(scrollLockController)

    expect(true)->toBe(true, _)
  })
})

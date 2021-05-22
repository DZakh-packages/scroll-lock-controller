open Jest

JestJs.mock("body-scroll-lock")

describe("ScrollLockController", () => {
  open Expect

  test("Locks are empty after create", () => {
    let controls = ScrollLockController.create()

    expect(controls.isEmpty())->toBe(true, _)
  })

  test("Locks aren't empty after lock", () => {
    open Webapi.Dom

    let div = Document.createElement("div", document)
    let controls = ScrollLockController.create()
    controls.lock(div)

    expect(controls.isEmpty())->toBe(false, _)
  })

  test("Locks are empty after lock and unlock", () => {
    open Webapi.Dom

    let div = Document.createElement("div", document)
    let controls = ScrollLockController.create()
    controls.lock(div)
    controls.unlock(div, ())

    expect(controls.isEmpty())->toBe(true, _)
  })
})

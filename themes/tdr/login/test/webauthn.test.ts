import WebAuthn from "../src/webauthn";

beforeEach(() => {
  return jest.spyOn(document, 'querySelector').mockImplementation((selector: string) => {
    console.log("AAAAAAAAAAAAAAAAAAA")
    switch (selector) {
      case "#challenge":
        return {value: "challenge"} as HTMLInputElement
      case "#createTimeout":
        return {value: "1"} as HTMLInputElement
      default: return null
    }
  })
})

test("checkIfWebAuthnSupported should set an error message if webauthn is not supported ", () => {
  const element: HTMLInputElement = {} as HTMLInputElement
  Object.defineProperty(global.window, 'PublicKeyCredential', {value: undefined})
  jest.spyOn(document, 'querySelector').mockImplementation((selector: string) => {
    switch (selector) {
      case "error":
        return element
      default: return null
    }
  })
  const webAuthn = new WebAuthn()
  webAuthn.checkIfWebAuthnSupported()

  expect(element.value).toEqual("")
})
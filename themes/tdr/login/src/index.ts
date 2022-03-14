import WebAuthn from "./webauthn";

window.onload = () => {

  const webAuthn = new WebAuthn()

  const register = document.querySelector("#registerWebAuthn")
  const authenticate = document.querySelector("#authenticateWebAuthnButton")

  if (register) {
    register.addEventListener("click", () => {
      webAuthn.registerSecurityKey()
    })
  }

  if (authenticate) {
    authenticate.addEventListener("click", () => {
      webAuthn.webAuthnAuthenticate()
    })
  }
}

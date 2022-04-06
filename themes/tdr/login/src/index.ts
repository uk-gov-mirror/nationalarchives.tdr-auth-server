import WebAuthn from "./webauthn";

window.onload = () => {

  const webAuthn = new WebAuthn()

  const register = document.querySelector("#registerWebAuthn")
  const authenticate = document.querySelector("#authenticateWebAuthnButton")

  if (register) {
    register.addEventListener("click", () => {
      const publicKey = webAuthn.getCreationPublicKey()
      webAuthn.registerSecurityKey(publicKey)
    })
  }

  if (authenticate) {
    authenticate.addEventListener("click", () => {
      webAuthn.webAuthnAuthenticate(webAuthn.doAuthenticate.bind(webAuthn))
    })
  }
}

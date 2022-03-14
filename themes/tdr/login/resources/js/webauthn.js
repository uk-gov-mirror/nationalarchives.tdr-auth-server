window.onload = () => {
  const challenge = document.querySelector("#challenge").value
  const createTimeout = parseInt(document.querySelector("#createTimeout").value, 10)

  function checkIfWebAuthnSupported() {
    if (!window.PublicKeyCredential) {
      const unsupportedMessage = document.querySelector("#unsupported-browser-message").value
      $("#error").val(unsupportedMessage)
      $("#register").submit()
    }
  }

  function webAuthnAuthenticate() {
    let isUserIdentified = document.querySelector("#isUserIdentified").value
    if (!isUserIdentified) {
      doAuthenticate([])
      return
    }
    checkAllowCredentials()
  }

  function checkAllowCredentials() {
    let allowCredentials = []
    let authn_use = document.forms['authn_select'].authn_use_chk

    if (authn_use !== undefined) {
      if (authn_use.length === undefined) {
        allowCredentials.push({
          id: base64url.decode(authn_use.value, {loose: true}),
          type: 'public-key',
        })
      } else {
        for (let i = 0; i < authn_use.length; i++) {
          allowCredentials.push({
            id: base64url.decode(authn_use[i].value, {loose: true}),
            type: 'public-key',
          })
        }
      }
    }
    doAuthenticate(allowCredentials)
  }


  function doAuthenticate(allowCredentials) {

    checkIfWebAuthnSupported()

    let userVerification = document.querySelector("#userVerification").value
    let publicKey = {
      rpId: document.querySelector("#rpId").value,
      challenge: base64url.decode(challenge, {loose: true})
    }

    if (createTimeout !== 0) publicKey.timeout = createTimeout * 1000

    if (allowCredentials.length) {
      publicKey.allowCredentials = allowCredentials
    }

    if (userVerification !== 'not specified') publicKey.userVerification = userVerification

    navigator.credentials.get({publicKey})
      .then((result) => {
        window.result = result

        let clientDataJSON = result.response.clientDataJSON
        let authenticatorData = result.response.authenticatorData
        let signature = result.response.signature

        $("#clientDataJSON").val(base64url.encode(new Uint8Array(clientDataJSON), {pad: false}))
        $("#authenticatorData").val(base64url.encode(new Uint8Array(authenticatorData), {pad: false}))
        $("#signature").val(base64url.encode(new Uint8Array(signature), {pad: false}))
        $("#credentialId").val(result.id)
        if (result.response.userHandle) {
          $("#userHandle").val(base64url.encode(new Uint8Array(result.response.userHandle), {pad: false}))
        }
        $("#webauth").submit()
      })
      .catch((err) => {
        $("#error").val(err)
        $("#webauth").submit()
      })

  }

  function registerSecurityKey() {

    // Check if WebAuthn is supported by this browser
    checkIfWebAuthnSupported()

    // mandatory parameters
    const challenge = document.querySelector("#challenge").value
    const userid = document.querySelector("#userid").value
    const username = document.querySelector("#username").value
    const signatureAlgorithms = document.querySelector("#signatureAlgorithms").value
    const rpEntityName = document.querySelector("#rpEntityName").value
    const pubKeyCredParams = getPubKeyCredParams(signatureAlgorithms)

    const rp = {name: rpEntityName}

    const publicKey = {
      challenge: base64url.decode(challenge, {loose: true}),
      rp: rp,
      user: {
        id: base64url.decode(userid, {loose: true}),
        name: username,
        displayName: username
      },
      pubKeyCredParams: pubKeyCredParams,
    }

    // optional parameters
    publicKey.rp.id = document.querySelector("#rpId").value

    const attestationConveyancePreference = document.querySelector("#attestationConveyancePreference").value
    if (attestationConveyancePreference !== 'not specified') publicKey.attestation = attestationConveyancePreference

    const authenticatorSelection = {}
    let isAuthenticatorSelectionSpecified = false

    const authenticatorAttachment = document.querySelector("#authenticatorAttachment").value
    if (authenticatorAttachment !== 'not specified') {
      authenticatorSelection.authenticatorAttachment = authenticatorAttachment
      isAuthenticatorSelectionSpecified = true
    }

    const requireResidentKey = document.querySelector("#requireResidentKey").value
    if (requireResidentKey !== 'not specified') {
      if (requireResidentKey === 'Yes')
        authenticatorSelection.requireResidentKey = true
      else
        authenticatorSelection.requireResidentKey = false
      isAuthenticatorSelectionSpecified = true
    }

    const userVerificationRequirement = document.querySelector("#userVerificationRequirement").value
    if (userVerificationRequirement !== 'not specified') {
      authenticatorSelection.userVerification = userVerificationRequirement
      isAuthenticatorSelectionSpecified = true
    }

    if (isAuthenticatorSelectionSpecified) publicKey.authenticatorSelection = authenticatorSelection

    if (createTimeout !== 0) publicKey.timeout = createTimeout * 1000

    const excludeCredentialIds = document.querySelector("#excludeCredentialIds").value
    const excludeCredentials = getExcludeCredentials(excludeCredentialIds)
    if (excludeCredentials.length > 0) publicKey.excludeCredentials = excludeCredentials

    navigator.credentials.create({publicKey})
      .then(function (result) {
        window.result = result
        const clientDataJSON = result.response.clientDataJSON
        const attestationObject = result.response.attestationObject
        const publicKeyCredentialId = result.rawId

        $("#clientDataJSON").val(base64url.encode(new Uint8Array(clientDataJSON), {pad: false}))
        $("#attestationObject").val(base64url.encode(new Uint8Array(attestationObject), {pad: false}))
        $("#publicKeyCredentialId").val(base64url.encode(new Uint8Array(publicKeyCredentialId), {pad: false}))

        const initLabel = "WebAuthn Authenticator (Default Label)"
        let labelResult = window.prompt("Please input your registered authenticator's label", initLabel)
        if (labelResult === null) labelResult = initLabel
        $("#authenticatorLabel").val(labelResult)

        $("#register").submit()

      })
      .catch(function (err) {
        $("#error").val(err)
        $("#register").submit()

      })
  }

  function getPubKeyCredParams(signatureAlgorithms) {
    const pubKeyCredParams = []
    if (signatureAlgorithms === "") {
      pubKeyCredParams.push({type: "public-key", alg: -7})
      return pubKeyCredParams
    }
    const signatureAlgorithmsList = signatureAlgorithms.split(',')

    for (let i = 0; i < signatureAlgorithmsList.length; i++) {
      pubKeyCredParams.push({
        type: "public-key",
        alg: signatureAlgorithmsList[i]
      })
    }
    return pubKeyCredParams
  }

  function getExcludeCredentials(excludeCredentialIds) {
    const excludeCredentials = []
    if (excludeCredentialIds === "") return excludeCredentials

    const excludeCredentialIdsList = excludeCredentialIds.split(',')

    for (let i = 0; i < excludeCredentialIdsList.length; i++) {
      excludeCredentials.push({
        type: "public-key",
        id: base64url.decode(excludeCredentialIdsList[i],
          {loose: true})
      })
    }
    return excludeCredentials
  }

  function refreshPage() {
    document.getElementById('isSetRetry').value = 'retry';
    document.getElementById('executionValue').value = '${execution}';
    document.getElementById('kc-error-credential-form').submit();
  }

  const register = document.querySelector("#registerWebAuthn")
  const authenticate = document.querySelector("#authenticateWebAuthnButton")
  const errorPageRefresh = document.querySelector("#errorPageRefresh")
  if (register) {
    register.addEventListener("click", () => {
      registerSecurityKey()
    })
  }

  if (authenticate) {
    document.querySelector("#authenticateWebAuthnButton").addEventListener("click", () => {
      webAuthnAuthenticate()
    })
  }

  if (errorPageRefresh) {
    errorPageRefresh.addEventListener("click", () => {
      refreshPage()
    })
  }
}

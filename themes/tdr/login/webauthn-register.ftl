<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
      title
    <#elseif section = "header">
      <span class="${properties.kcWebAuthnKeyIcon}"></span>
        ${kcSanitize(msg("webauthn-registration-title"))?no_esc}
    <#elseif section = "form">
      <input type="hidden" id="unsupported-browser-message" value="${msg("webauthn-unsupported-browser-text")?no_esc}">
      <input type="hidden" id="challenge" value="${challenge}">
      <input type="hidden" id="userid" value="${userid}">
      <input type="hidden" id="username" value="${username}">
      <input type="hidden" id="signatureAlgorithms" value="${signatureAlgorithms}">
      <input type="hidden" id="rpEntityName" value="${rpEntityName}">
      <input type="hidden" id="rpId" value="${rpId}">
      <input type="hidden" id="attestationConveyancePreference" value="${attestationConveyancePreference}">
      <input type="hidden" id="authenticatorAttachment" value="${authenticatorAttachment}">
      <input type="hidden" id="requireResidentKey" value="${requireResidentKey}">
      <input type="hidden" id="userVerificationRequirement" value="${userVerificationRequirement}">
      <input type="hidden" id="createTimeout" value="${createTimeout}">
      <input type="hidden" id="excludeCredentialIds" value="${excludeCredentialIds}">

      <form id="register" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
        <div class="${properties.kcFormGroupClass!}">
          <input type="hidden" id="clientDataJSON" name="clientDataJSON"/>
          <input type="hidden" id="attestationObject" name="attestationObject"/>
          <input type="hidden" id="publicKeyCredentialId" name="publicKeyCredentialId"/>
          <input type="hidden" id="authenticatorLabel" name="authenticatorLabel"/>
          <input type="hidden" id="error" name="error"/>
        </div>
      </form>

      <script type="text/javascript" src="${url.resourcesCommonPath}/node_modules/jquery/dist/jquery.min.js"></script>
      <script type="text/javascript" src="${url.resourcesPath}/js/base64url.js"></script>

      <label class="govuk-label" for="registerWebAuthn">
        Click register to setup your hardware token
      </label>

      <input type="submit"
             name="registerWebAuthn"
             class="govuk-button ${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
             id="registerWebAuthn" value="${msg("doRegister")}"/>

        <#if !isSetRetry?has_content && isAppInitiatedAction?has_content>
          <form action="${url.loginAction}" class="${properties.kcFormClass!}" id="kc-webauthn-settings-form"
                method="post">
            <button type="submit"
                    class="govuk-button {properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                    id="cancelWebAuthnAIA" name="cancel-aia" value="true">${msg("doCancel")}
            </button>
          </form>
        </#if>

    </#if>
</@layout.registrationLayout>
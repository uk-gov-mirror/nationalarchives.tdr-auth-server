<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
      title
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

      <label class="govuk-label" for="registerWebAuthn">
        Click register to setup your hardware token
      </label>

      <input type="submit" name="registerWebAuthn" class="govuk-button" id="registerWebAuthn" value="${msg("doRegister")}"/>
    </#if>
</@layout.registrationLayout>

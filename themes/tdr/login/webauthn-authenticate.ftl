<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${kcSanitize(msg("webauthn-login-title"))?no_esc}
    <#elseif section = "form">

      <form id="webAuth" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
        <input type="hidden" id="clientDataJSON" name="clientDataJSON"/>
        <input type="hidden" id="authenticatorData" name="authenticatorData"/>
        <input type="hidden" id="signature" name="signature"/>
        <input type="hidden" id="credentialId" name="credentialId"/>
        <input type="hidden" id="userHandle" name="userHandle"/>
        <input type="hidden" id="error" name="error"/>
      </form>

        <#if authenticators??>
          <form id="authn_select" class="${properties.kcFormClass!}">
              <#list authenticators.authenticators as authenticator>
                <input type="hidden" class="authn_use_check" name="authn_use_chk" value="${authenticator.credentialId}"/>
              </#list>
          </form>
        </#if>

      <input id="authenticateWebAuthnButton" type="button" value="${kcSanitize(msg("webauthn-doAuthenticate"))}" class="govuk-button">
      <input type="hidden" id="unsupported-browser-message" value="${msg("webauthn-unsupported-browser-text")?no_esc}">
      <input type="hidden" id="challenge" value="${challenge}">
      <input type="hidden" id="createTimeout" value="${createTimeout}">
      <input type="hidden" id="userVerification" value="${userVerification}">
      <input type="hidden" id="isUserIdentified" value="${isUserIdentified}">
      <input type="hidden" id="rpId" value="${rpId}">
    <#elseif section = "info">

    </#if>
</@layout.registrationLayout>

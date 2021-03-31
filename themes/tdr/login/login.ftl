<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <p class="govuk-body">${msg("loginDescription")}</p>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
        <#if realm.password>
          <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}"
                method="post">
            <div class="govuk-form-group<#if message?has_content>--error</#if>">
              <div class="govuk-form-group">
                  <label class="govuk-label" for="username">
                      ${msg("email")}
                  </label>
                <input id="username" class="govuk-input govuk-!-width-two-thirds" name="username"
                       value="${(login.username!'')}" type="text" autofocus autocomplete="off"/>
              </div>
              <div class="govuk-form-group">
                  <label class="govuk-label" for="password">
                  ${msg("password")}
                  </label>
                <input id="password" class="govuk-input govuk-!-width-two-thirds" name="password" type="password"
                       autocomplete="off"/>
              </div>
            </div>

              <#if message?has_content>
                <span class="govuk-error-message" id="error-kc-form-login">
                  <span class="govuk-visually-hidden">${msg("screenReaderError")}</span>
                  ${message.summary}
                </span>
              </#if>

            <input type="hidden" id="id-hidden-input" name="credentialId"
                   <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>


            <button class="govuk-button" type="submit" data-module="govuk-button" role="button" name="login">
                ${msg("signInButton")}
            </button>
              <p class="govuk-body-s">
                  <a class="govuk-link" href="${properties.tdrHomeUrl}/contact">${msg("resetPassword")}</a>
              </p>
          </form>
        </#if>
    </#if>
</@layout.registrationLayout>

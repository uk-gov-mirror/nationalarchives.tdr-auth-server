<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
        <#if realm.password>
          <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}"
                method="post">
            <div class="govuk-form-group<#if message?has_content>--error</#if>">
              <div class="govuk-form-group">
                <h1 class="govuk-label-wrapper">
                  <label for="username" class="govuk-label govuk-label--l">
                      ${msg("email")}
                  </label>
                </h1>
                <input id="username" class="govuk-input govuk-!-width-one-half" name="username"
                       value="${(login.username!'')}" type="text" autofocus autocomplete="off"/>
              </div>
              <div class="govuk-form-group">
                <h1 class="govuk-label-wrapper">
                  <label for="password" class="govuk-label govuk-label--l">${msg("password")}</label>
                </h1>
                <input id="password" class="govuk-input govuk-!-width-one-half" name="password" type="password"
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
                ${msg("continueButton")}
            </button>
          </form>
        </#if>
    </#if>
</@layout.registrationLayout>

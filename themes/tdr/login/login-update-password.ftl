<#import "template.ftl" as layout>
<#assign updatePasswordPageTitle = msg("updatePasswordTitle")>
<#assign hasError = (message?has_content && message.type = 'error')?then(true, false)>

<@layout.registrationLayout pageTitle=updatePasswordPageTitle displayMessage=hasError displayBackLink=true; section>
    <#if section = "header">
        ${updatePasswordPageTitle}
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="govuk-form-group<#if message?has_content && message.type = 'error'>--error</#if>">
                <div class="govuk-form-group">
                    <p class="govuk-body govuk-!-margin-bottom-4">${msg("passwordInfo")}</p>
                    <h2 class="govuk-label-wrapper">
                        <label for="password-new" class="govuk-label govuk-label--m">${msg("passwordNew")}</label>
                    </h2>
                    <div id="password-new-hint">
                        <p class="govuk-hint govuk-!-margin-bottom-1">${msg("passwordRestrictionsInfo")}</p>
                        <ul class="govuk-list govuk-list--bullet govuk-hint">
                            <li>${msg("passwordRestrictionCharacters")}</li>
                            <li>${msg("passwordRestrictionCapitalLetter")}</li>
                            <li>${msg("passwordRestrictionNumber")}</li>
                        </ul>
                    </div>
                <input type="password" id="password-new" name="password-new" class="govuk-input govuk-input--width-10" autofocus autocomplete="new-password" />
                </div>

              <div class="govuk-form-group">
                <h2 class="govuk-label-wrapper">
                  <label for="password-confirm" class="govuk-label govuk-label--m">${msg("passwordConfirm")}</label>
                </h2>
                <input type="password" id="password-confirm" name="password-confirm" class="govuk-input govuk-input--width-10" autocomplete="new-password" />
              </div>
            </div>
            <#if message?has_content && message.type = 'error'>
                <p class="govuk-error-message" id="error-kc-form-login">
                  <span class="govuk-visually-hidden">${msg("screenReaderError")}</span>
                  ${message.summary}
                </p>
            </#if>

            <button class="govuk-button" type="submit" data-module="govuk-button" role="button">
                ${msg("doSubmit")}
            </button>
        </form>
    </#if>
</@layout.registrationLayout>

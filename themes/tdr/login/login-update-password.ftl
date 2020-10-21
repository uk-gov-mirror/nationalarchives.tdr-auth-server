<#import "template.ftl" as layout>
<#assign updatePasswordPageTitle = msg("updatePasswordTitle")>

<@layout.registrationLayout pageTitle=updatePasswordPageTitle displayInfo=true; section>
    <#if section = "header">
        ${updatePasswordPageTitle}
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <input type="text" id="username" name="username" value="${username}" autocomplete="username" readonly="readonly" style="display:none;"/>
            <input type="password" id="password" name="password" autocomplete="current-password" style="display:none;"/>

            <div class="govuk-form-group">
                <h1 class="govuk-label-wrapper">
                    <label for="password-new" class="govuk-label govuk-label--l">${msg("passwordNew")}</label>
                </h1>
                <div id="password-new-hint" class="govuk-hint">
                    ${msg("passwordRestrictions")}
                </div>
                <input type="password" id="password-new" name="password-new" class="govuk-input govuk-!-width-one-half" autofocus autocomplete="new-password" />
            </div>

            <div class="govuk-form-group">
                <h1 class="govuk-label-wrapper">
                    <label for="password-confirm" class="govuk-label govuk-label--l">${msg("passwordConfirm")}</label>
                </h1>
                <input type="password" id="password-confirm" name="password-confirm" class="govuk-input govuk-!-width-one-half" autocomplete="new-password" />
            </div>

            <button class="govuk-button" type="submit" data-module="govuk-button" role="button">
                ${msg("doSubmit")}
            </button>
        </form>
    </#if>
</@layout.registrationLayout>

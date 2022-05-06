<#import "template.ftl" as layout>
<#assign forgotPasswordPageTitle = msg("emailForgotTitle")>

<@layout.registrationLayout pageTitle=forgotPasswordPageTitle; section>
    <#if section = "header">
        ${forgotPasswordPageTitle}
    <#elseif section = "form">
        <form id="kc-reset-password-form" action="${url.loginAction}" method="post">
            <div class="govuk-form-group">
                <div class="govuk-form-group">
                    <label class="govuk-label" for="username">
                        ${msg("receiveResetPasswordEmail")}
                    </label>
                    <input type="text" class="govuk-input govuk-!-width-two-thirds" id="username" name="username"
                           value="${(login.username!'')}" type="text" autofocus autocomplete="off"/>
                </div>
            </div>
            <button class="govuk-button" type="submit" data-module="govuk-button" role="button" name="login">
                ${msg("doSubmit")}
            </button>
        </form>
        <p class="govuk-body"><a id="backToLogin" class="govuk-link" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></p>
    </#if>
</@layout.registrationLayout>

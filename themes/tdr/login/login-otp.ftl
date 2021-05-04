<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section="header">
        ${msg("doLogIn")}
    <#elseif section="form">
        <form id="otp-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}"
              method="post">
            <div class="govuk-form-group<#if message?has_content>--error</#if>">
                <div class="govuk-form-group">
                    <label class="govuk-label" for="otp">
                        ${msg("loginOtpOneTime")}
                    </label>
                    <input id="otp" name="otp" autocomplete="off" type="text" class="govuk-input govuk-!-width-two-thirds"
                           autofocus/>
                </div>
            </div>

            <button class="govuk-button" type="submit" data-module="govuk-button" role="button" name="login">
                ${msg("signInButton")}
            </button>
        </form>
    </#if>
</@layout.registrationLayout>

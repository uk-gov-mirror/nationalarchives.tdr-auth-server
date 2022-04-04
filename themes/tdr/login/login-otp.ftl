<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section="header">
        ${msg("doLogIn")}
    <#elseif section="form">
        <form id="otp-login-form" action="${url.loginAction}" method="post">
            <div class="govuk-form-group<#if message?has_content>--error</#if>">
                <div class="govuk-form-group">
                    <label class="govuk-label" for="otp">
                        ${msg("loginOtpOneTime")}
                    </label>
                    <div id="otp-hint" class="govuk-hint">
                      ${msg("loginTotpHint")}
                    </div>
                    <input id="otp" name="otp" autocomplete="off" type="text" class="govuk-input govuk-!-width-two-thirds"
                           autofocus/>
                    <#if message?has_content>
                      <p class="govuk-error-message" id="error-kc-form-login">
                        <span class="govuk-visually-hidden">${msg("screenReaderError")}</span>
                        ${message.summary}
                      </p>
                    </#if>
                </div>
            </div>

            <button class="govuk-button" type="submit" data-module="govuk-button" role="button" name="login">
                Continue
            </button>
        </form>
    </#if>
</@layout.registrationLayout>

<#import "template.ftl" as layout>
<#assign enterOtpPageTitle = msg("enterOtp")>
<@layout.registrationLayout pageTitle=enterOtpPageTitle errorTarget="otp"; section>
    <#if section="header">
        ${msg("doLogIn")}
    <#elseif section="form">
        <form id="otp-login-form" action="${url.loginAction}" method="post">
            <div class="govuk-form-group<#if message?has_content>--error</#if>">
                <div class="govuk-form-group">
                    <div id="otp-hint" class="govuk-hint">
                      ${msg("loginTotpHint")}
                    </div>
                    <details class="govuk-details govuk-!-margin-bottom-4" data-module="govuk-details">
                        <summary class="govuk-details__summary">
                          <span class="govuk-details__summary-text">
                            Where do I find the one-time passcode?
                          </span>
                        </summary>
                        <div class="govuk-details__text">
                            Your one-time passcode can be found in your chosen authenticator app that was used to set up your account.
                        </div>
                    </details>
                    <input id="otp" name="otp" autocomplete="off" type="text" class="govuk-input govuk-input--width-5" inputmode="numeric" autofocus/>
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

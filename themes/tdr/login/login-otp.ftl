<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section="header">
        ${msg("doLogIn")}
    <#elseif section="form">
        <form id="kc-otp-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}"
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

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                    </div>
                </div>
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <button class="govuk-button" type="submit" data-module="govuk-button" role="button" name="login">
                        ${msg("signInButton")}
                    </button>
                </div>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

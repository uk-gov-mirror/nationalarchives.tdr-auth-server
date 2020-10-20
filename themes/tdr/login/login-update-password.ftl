<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <input type="text" id="username" name="username" value="${username}" autocomplete="username" readonly="readonly" style="display:none;"/>
            <input type="password" id="password" name="password" autocomplete="current-password" style="display:none;"/>

            <div class="govuk-form-group">
                <h1 class="govuk-label-wrapper">
                    <label for="password-new" class="${properties.kcLabelClass!}">${msg("passwordNew")}</label>
                </h1>
                <input type="password" id="password-new" name="password-new" class="govuk-input govuk-!-width-one-half" autofocus autocomplete="new-password" />
            </div>

            <div class="govuk-form-group">
                <h1 class="govuk-label-wrapper">
                    <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>
                </h1>
                <input type="password" id="password-confirm" name="password-confirm" class="govuk-input govuk-!-width-one-half" autocomplete="new-password" />
            </div>

            <#if isAppInitiatedAction??>
                <button class="govuk-button" type="submit" data-module="govuk-button" role="button">
                    ${msg("doSubmit")}
                </button>

                <button class="govuk-button" type="submit" name="cancel-aia" value="true" data-module="govuk-button" role="button">
                    ${msg("doCancel")}
                </button>
            <#else>
                <button class="govuk-button" type="submit" data-module="govuk-button" role="button">
                    ${msg("doSubmit")}
                </button>
            </#if>
        </form>
    </#if>
</@layout.registrationLayout>

<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        <#if messageHeader??>
            ${messageHeader}
        <#else>
            ${message.summary}
        </#if>
    <#elseif section = "form">
        <p class="govuk-body">
            ${message.summary}<#t>
            <#if message.summary == "To begin a transfer">, <a id="backToApplication" class="govuk-link" href="${properties.tdrHomeUrl}/homepage">${kcSanitize(msg("backToApplication"))?lower_case?no_esc}</a><#t>
            <#elseif requiredActions??>:<#t>
            </#if>
        </p>
        <#if skipLink??>
        <#else>
            <#if pageRedirectUri?has_content>
                <p class="govuk-body"><a class="govuk-link" href="${pageRedirectUri}">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
            <#elseif actionUri?has_content>
                <p class="govuk-body"><a class="govuk-link" href="${actionUri}"><#if requiredActions??><#list requiredActions><#items as reqActionItem>${msg("requiredAction.${reqActionItem}")}<#sep>, </#items></#list><#else></#if></a></p>
            <#elseif (client.baseUrl)?has_content>
                <p class="govuk-body"><a class="govuk-link" href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
            </#if>
        </#if>
    </#if>
</@layout.registrationLayout>

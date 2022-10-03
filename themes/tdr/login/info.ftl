<#import "template.ftl" as layout>
<#assign backToApplicationText = kcSanitize(msg("backToApplication"))>
<#assign continueToApplicationText = kcSanitize(msg("continueToApplication"))>

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
            <#-- if the user has updated their account provide link back to TDR so they can login -->
            <#if message.summary == msg("accountUpdatedMessage")>
                , <a id="backToApplication" class="govuk-link" href="${properties.tdrHomeUrl}/homepage">${backToApplicationText?lower_case?no_esc}</a><#t>
            <#elseif requiredActions??>:<#t>
            </#if>
        </p>
        <#if skipLink??>
        <#else>
            <#if pageRedirectUri?has_content>
                <p class="govuk-body"><a class="govuk-link" href="${pageRedirectUri}">${backToApplicationText?no_esc}</a></p>
            <#elseif actionUri?has_content>
                <p class="govuk-body"><a class="govuk-link" href="${actionUri}"><#if requiredActions??><#list requiredActions><#items as reqActionItem>${msg("requiredAction.${reqActionItem}")}<#sep>, </#items></#list><#else></#if></a></p>
            <#elseif message.summary == msg("alreadyLoggedInMessage")>
                <p class="govuk-body"><a class="govuk-link" href="${properties.tdrHomeUrl}/homepage"> ${continueToApplicationText?no_esc} </a></p>
            <#elseif (client.baseUrl)?has_content>
                <p class="govuk-body"><a class="govuk-link" href="${client.baseUrl}">${backToApplicationText?no_esc}</a></p>
            </#if>
        </#if>
    </#if>
</@layout.registrationLayout>

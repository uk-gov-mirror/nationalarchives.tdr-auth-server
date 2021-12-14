<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("errorTitle")}
    <#elseif section = "form">
        <p class="govuk-body">${message.summary?no_esc}</p>
        <#if client?? && client.baseUrl?has_content>
            <p class="govuk-body"><a id="backToApplication" class="govuk-link" href="${properties.tdrHomeUrl}/homepage">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
        <#else>
            <p class="govuk-body">Please <a class="govuk-link" href="${properties.tdrHomeUrl}/contact">contact</a> us to send you a new link.</p>
        </#if>
    </#if>
</@layout.registrationLayout>

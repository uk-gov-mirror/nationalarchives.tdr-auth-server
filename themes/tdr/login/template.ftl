<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false displayWide=false showAnotherWayIfPresent=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="${properties.kcHtmlClass!}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>

    <link rel="shortcut icon" type="image/ico" href="${url.resourcesPath}/img/favicon.ico">
    <script src="https://code.iconify.design/1/1.0.3/iconify.min.js"></script>
</head>

<body class="${properties.kcBodyClass!}">
    <#-- Start TDR Template header -->
    <header class="govuk-header " role="banner" data-module="header">
        <div class="govuk-header__container govuk-width-container">
            <div class="govuk-header__tna-logo">
                <a href="${properties.tdrHomeUrl}" class="govuk-header__tna_link govuk-header__tna_link--homepage">
                    <img src="${url.resourcesPath}/img/tna-horizontal-white-logo.svg" class="govuk-header__tna-logo-image" alt="TNA horizontal logo" />
                </a>
            </div>

            <div class="govuk-header__tna-content">
                <a href="#" class="govuk-header__link govuk-header__link--service-name">
                    ${msg("mainHeader")}
                </a>
            </div>
        </div>
    </header>
    <#-- End TDR Template header -->
    <div class="govuk-width-container">
        <main class="govuk-main-wrapper " id="main-content" role="main">
            <div><#nested "back"></div>

            <div class="grid-row">
                <div class="column-two-thirds">
                    <h1 class="heading-large"><#nested "title"></h1>

                    <div id="kc-container" class="${properties.kcContainerClass!}">
                        <div id="kc-container-wrapper" class="${properties.kcContainerWrapperClass!}">
                            <#if realm.internationalizationEnabled>
                                <div id="kc-locale" class="${properties.kcLocaleClass!}">
                                    <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                                        <div class="kc-dropdown" id="kc-locale-dropdown">
                                            <a href="#" id="kc-current-locale-link">${locale.current}</a>
                                            <ul>
                                                <#list locale.supported as l>
                                                    <li class="kc-dropdown-item"><a href="${l.url}">${l.label}</a></li>
                                                </#list>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </#if>

                        <div id="kc-content" class="${properties.kcContentClass!}">
                            <div id="kc-content-wrapper" class="${properties.kcContentWrapperClass!}">
                                <#if displayMessage && message?has_content>
                                    <#if message.type = 'error'>
                                        <div class="error-summary" role="group" aria-labelledby="error-summary-heading-example-1" tabindex="-1">
                                            <h1 class="heading-medium error-summary-heading" id="error-summary-heading-example-1">
                                                There is a problem with this form
                                            </h1>

                                            <ul class="error-summary-list" id="error-details">
                                                <li>${message.summary}</li>
                                            </ul>
                                        </div>
                                    <#else>
                                        <div class="${properties.kcFeedbackAreaClass!}">
                                            <div class="alert alert-${message.type}"><p>
                                                <#if message.type = 'success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                                                <#if message.type = 'warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                                                <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                                                <span class="kc-feedback-text">${message.summary}</span></p>
                                            </div>
                                        </div>
                                    </#if>
                                </#if>

                                <div id="kc-form" class="${properties.kcFormAreaClass!}">
                                    <div id="kc-form-wrapper" class="${properties.kcFormAreaWrapperClass!}">
                                        <#nested "form">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="column-one-third">
                <#if displayInfo>
                    <div id="kc-info" class="${properties.kcInfoAreaClass!}">
                        <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                            <#nested "info">
                        </div>
                    </div>
                </#if>
            </div>
        </div>
    </main>
</div>

<#-- Start TDR Template footer -->
<footer class="govuk-footer " role="contentinfo">
    <div class="govuk-width-container ">
        <div class="govuk-footer__meta">
            <div class="govuk-footer__meta-item govuk-footer__meta-item--grow">

                <svg role="presentation" focusable="false" class="govuk-footer__licence-logo" xmlns="http://www.w3.org/2000/svg" viewbox="0 0 483.2 195.7" height="17" width="41">
                    <path fill="currentColor" d="M421.5 142.8V.1l-50.7 32.3v161.1h112.4v-50.7zm-122.3-9.6A47.12 47.12 0 0 1 221 97.8c0-26 21.1-47.1 47.1-47.1 16.7 0 31.4 8.7 39.7 21.8l42.7-27.2A97.63 97.63 0 0 0 268.1 0c-36.5 0-68.3 20.1-85.1 49.7A98 98 0 0 0 97.8 0C43.9 0 0 43.9 0 97.8s43.9 97.8 97.8 97.8c36.5 0 68.3-20.1 85.1-49.7a97.76 97.76 0 0 0 149.6 25.4l19.4 22.2h3v-87.8h-80l24.3 27.5zM97.8 145c-26 0-47.1-21.1-47.1-47.1s21.1-47.1 47.1-47.1 47.2 21 47.2 47S123.8 145 97.8 145" />
                </svg>
                <span class="govuk-footer__licence-description">
                        All content is available under the
                        <a class="govuk-footer__link" href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/" rel="license">Open Government Licence v3.0</a>, except where otherwise stated
                    </span>
            </div>
            <div class="govuk-footer__meta-item">
                <a class="govuk-footer__link govuk-footer__copyright-logo" href="https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/">© Crown copyright</a>
            </div>
        </div>
    </div>
</footer>

<script>
        window.GOVUKFrontend.initAll()
</script>
<#-- End TDR Template footer -->

</body>
</html>
</#macro>

<#assign signInPageTitle = msg("loginTitle")>
<#assign betaBanner = msg("betaBanner")>
<#assign betaBannerInfo = msg("betaBannerInfo")>
<#assign betaBannerLink = msg("betaBannerLink")>
<#assign loggedInPageTitle = msg("loggedInTitle")>

<#macro registrationLayout pageTitle=signInPageTitle displayHeading=true displayMessage=true displayRequiredFields=false showAnotherWayIfPresent=true errorTarget="error-kc-form-login">
    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en" class="govuk-template">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="robots" content="noindex, nofollow">

        <#if properties.meta?has_content>
            <#list properties.meta?split(' ') as meta>
                <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
            </#list>
        </#if>
        <#if properties.blockSharedPages = 'true'>
            <#if displayMessage && message?has_content && message.type = 'error'>
            <title>Error: ${pageTitle} Transfer Digital Records - GOV.UK</title>
            <#else>
            <title>${pageTitle} Transfer Digital Records - GOV.UK</title>
            </#if>
        <#else>
            <#if displayMessage && message?has_content && message.type = 'error'>
            <title>Error: ${pageTitle} Transfer & Access Your Records - GOV.UK</title>
            <#else>
            <title>${pageTitle} Transfer & Access Your Records - GOV.UK</title>
            </#if>
        </#if>

        <link rel="icon" href="${url.resourcesPath}/img/favicon.ico"/>
        <#if properties.stylesCommon?has_content>
            <#list properties.stylesCommon?split(' ') as style>
                <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet"/>
            </#list>
        </#if>
        <#if properties.styles?has_content>
            <#list properties.styles?split(' ') as style>
                <link href="${url.resourcesPath}/${style}" rel="stylesheet"/>
            </#list>
        </#if>
        <#if properties.scripts?has_content>
            <#list properties.scripts?split(' ') as script>
                <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
            </#list>
        </#if>

        <link rel="shortcut icon" type="image/ico" href="${url.resourcesPath}/img/favicon.ico">
        <script src="https://code.iconify.design/1/1.0.3/iconify.min.js"></script>
    </head>

    <body class="govuk-template__body">
    <#-- Start TDR Template header -->
    <#if properties.blockSharedPages = 'true'>
    <header class="govuk-header" role="banner" data-module="govuk-header">
        <div class="govuk-header__container govuk-width-container tna-header">
            <div class="govuk-header__logo">
                <a href="${properties.tdrHomeUrl}" class="govuk-header__link govuk-header__link--homepage">
                    <svg xmlns="http://www.w3.org/2000/svg" width="220" viewBox="0 0 250 35">
                        <g clip-path="url(#a)">
                            <path fill="currentColor" d="M1.17 1.17h48.58v31.97H1.17V1.17ZM0 0v34.31h50.92V0H0Z"/>
                            <path fill="currentColor" d="M13.41 12.33h-3.4v-1.91H19v1.91h-3.4V23.9h-2.19V12.33ZM19.86 10.42h2.19v5.68h5.24v-5.68h2.19V23.9h-2.19v-5.86h-5.24v5.86h-2.19V10.42ZM32 10.42h7.72v1.89h-5.53v3.81h4.63v1.9h-4.63v3.96h5.53v1.92H32V10.42ZM50.91 1.17h98.33v31.97H50.91V1.17ZM49.74 0v34.31h100.67V0H49.74Z"/>
                            <path fill="currentColor" d="M62.14 10.42h2.36l4.03 7.89c.35.68.72 1.72 1.04 2.54h.14c-.14-1.09-.21-2.25-.21-3.01v-7.42h2.17V23.9h-2.35l-3.97-7.75c-.43-.86-.74-1.68-1.09-2.64h-.14c.1.86.21 2.11.21 3.14v7.25h-2.19V10.42ZM79.78 18.8l-1.06-3.95c-.2-.7-.35-1.39-.55-2.38h-.12c-.19.98-.31 1.62-.53 2.38l-1.07 3.95h3.33Zm-2.99-8.38h2.66l3.89 13.48h-2.23l-.92-3.28h-4.14l-.9 3.28h-2.27l3.91-13.48ZM85.7 12.33h-3.4v-1.91h8.99v1.91h-3.4V23.9H85.7V12.33ZM94.59 10.42H92.4V23.9h2.19V10.42ZM104.8 17.18c0-3.32-1.04-5.04-3.03-5.04-2.01 0-3.03 1.72-3.03 5.04 0 3.3 1.02 5 3.03 5 2 0 3.03-1.7 3.03-5Zm-8.36 0c0-4.39 1.92-6.95 5.34-6.95 3.4 0 5.32 2.56 5.32 6.95 0 4.37-1.92 6.91-5.32 6.91-3.43 0-5.34-2.54-5.34-6.91ZM109.06 10.42h2.36l4.03 7.89c.35.68.72 1.72 1.04 2.54h.14c-.14-1.09-.21-2.25-.21-3.01v-7.42h2.17V23.9h-2.35l-3.97-7.75c-.43-.86-.74-1.68-1.09-2.64h-.14c.1.86.21 2.11.21 3.14v7.25h-2.19V10.42ZM126.75 18.8l-1.06-3.95c-.2-.7-.35-1.39-.55-2.38h-.12c-.2.98-.31 1.62-.53 2.38l-1.07 3.95h3.33Zm-2.99-8.38h2.66l3.89 13.48h-2.23l-.92-3.28h-4.14l-.9 3.28h-2.27l3.91-13.48ZM131.49 10.42h2.19v11.56h5.26v1.92h-7.45V10.42ZM150.43 1.17h98.33v31.97h-98.33V1.17Zm-1.18 33.15h100.67V0H149.25v34.32Z"/>
                            <path fill="currentColor" d="m166.17 18.76-1.06-3.95c-.2-.7-.35-1.39-.55-2.38h-.12c-.2.98-.31 1.62-.53 2.38l-1.07 3.95h3.33Zm-2.99-8.38h2.66l3.89 13.48h-2.23l-.92-3.28h-4.14l-.9 3.28h-2.27l3.91-13.48ZM174.38 17.08c1.58 0 2.13-1.02 2.13-2.42 0-1.37-.61-2.42-2.13-2.42h-1.68v4.84h1.68Zm-3.85-6.7h4.03c2.85 0 4.22 1.54 4.22 4.14 0 1.95-.94 3.52-2.33 3.94v.12c.64.72 2.5 4.75 3.01 4.96v.31h-2.36c-.63-.35-2.29-4.53-2.8-4.88h-1.58v4.88h-2.19V10.38ZM182.52 17.08c0 3.36 1.17 5.06 2.99 5.06 1.8 0 2.52-1.27 2.5-3.26l2.19.08c.02.1.04.27.04.37 0 2.77-1.35 4.73-4.71 4.73-3.24 0-5.34-2.44-5.34-6.97 0-4.43 2.09-6.89 5.34-6.89 4.05 0 4.73 2.91 4.73 4.53 0 .2-.02.45-.04.57l-2.21.08c.02-2.07-.72-3.26-2.5-3.26-1.8-.02-2.99 1.72-2.99 4.96ZM192.03 10.38h2.19v5.68h5.23v-5.68h2.19v13.48h-2.19V18h-5.23v5.86h-2.19V10.38ZM206.73 10.38h-2.19v13.48h2.19V10.38ZM208.5 10.38h2.29l2.03 7.75c.31 1.21.49 2.28.7 3.53h.16c.22-1.27.39-2.32.7-3.53l2.01-7.75h2.29l-3.81 13.48h-2.56l-3.81-13.48Z"/>
                            <path fill="currentColor" d="M220.18 10.38h7.72v1.9h-5.53v3.8H227v1.9h-4.63v3.96h5.53v1.92h-7.72V10.38ZM231.32 19.29c-.02.16-.04.33-.04.49 0 1.21.49 2.34 2.15 2.34 1.35 0 2.07-.74 2.07-1.82 0-.98-.43-1.54-1.41-1.89l-2.17-.8c-1.52-.57-2.66-1.54-2.66-3.61 0-2.23 1.47-3.81 4.16-3.81 3.44 0 4.05 2.27 4.05 3.69 0 .21-.02.45-.06.66l-2.15.04c.02-.14.04-.33.04-.47 0-1.05-.37-1.99-1.92-1.99-1.31 0-1.9.78-1.9 1.78 0 1.09.59 1.56 1.39 1.86l2.21.8c1.66.61 2.68 1.66 2.68 3.63 0 2.27-1.5 3.87-4.4 3.87-3.69 0-4.3-2.46-4.3-4.06 0-.19.02-.41.06-.62l2.2-.09Z"/>
                        </g>
                        <defs>
                            <clipPath id="a">
                                <path fill="currentColor" d="M0 0h249.93v34.48H0z"/>
                            </clipPath>
                        </defs>
                    </svg>
                    <span class="govuk-visually-hidden">
                                ${msg("mainHeader")}
                    </span>
                </a>
            </div>

            <div class="govuk-header__content govuk-header__content--nav-right">
                <a href="${properties.tdrHomeUrl}" class="govuk-header__link govuk-header__service-name">
                    ${msg("mainHeader")}
                </a>
            </div>
        </div>
    </header>
    <#-- End TDR Template header -->
    <#else>
    <#-- Start AYR Template header -->

    <header class="govuk-header" role="banner" data-module="govuk-header">
        <div class="govuk-header__container govuk-header__container--ayr govuk-width-container">
            <div class="govuk-header__logo govuk-header__logo--ayr">
                <p class="govuk-header__link govuk-header__link--homepage govuk-header__link--homepage--ayr">
                    <span class="govuk-header__logotype-text govuk-header__logotype--ayr">${msg("ayrHeader")}</span>
                </p>
            </div>
            <div class="govuk-header__content govuk-header__content--ayr">
                Delivered by
                <a href="https://www.nationalarchives.gov.uk/"
                   class="govuk-header__link govuk-header__link--ayr">The
                National Archives</a>
            </div>
        </div>
    </header>


    </#if>
    <#-- End AYR Template header -->

    <#-- Start TDR Content -->
    <div class="govuk-width-container">

        <div class="govuk-phase-banner">
            <p class="govuk-phase-banner__content">
                <strong class="govuk-tag govuk-phase-banner__content__tag">${msg("betaBanner")}</strong>
                <span class="govuk-phase-banner__text">${msg("betaBannerInfo")}
                <a class="govuk-link" target="_blank" rel="noreferrer noopener"
                   href="${properties.tdrHomeUrl}/contact">${msg("betaBannerLink")}</a>
                </span>
            </p>
        </div>

        <main class="govuk-main-wrapper " id="main-content" role="main">
            <div class="govuk-grid-row">
                <div class="govuk-grid-column-two-thirds">
                    <#-- Start TDR Error Messages -->
                    <#if displayMessage && message?has_content>
                        <#if message.type = 'error'>
                            <div class="govuk-error-summary" aria-labelledby="error-summary-title" role="alert"
                                 tabindex="-1" data-module="govuk-error-summary">
                                <h2 class="govuk-error-summary__title" id="error-summary-title">
                                    There is a problem
                                </h2>
                                <div class="govuk-error-summary__body">
                                    <ul class="govuk-list govuk-error-summary__list">
                                        <li>
                                            <#if message.summary = msg("webauthn-error-register-verification")>
                                                <p>${msg("webauthn-error-register-verification")?no_esc}</p>
                                            <#elseif message.summary = msg("webauthn-error-api-get")>
                                                <p>${msg("webauthn-error-api-get")?no_esc}</p>
                                            <#else>
                                                <a href="#${errorTarget}">${message.summary}</a>
                                            </#if>
                                        </li>
                                    </ul>
                                    <#if message.summary = msg("invalidTotpMessage") || message.summary = msg("missingTotpDeviceNameMessage")>
                                        <p>${msg("totpErrorContact")?no_esc}</p>
                                    </#if>
                                </div>
                            </div>
                        <#else>
                            <div class="govuk-warning-text" aria-labelledby="warning-message" role="alert" tabindex="-1">
                                <#if message.type = 'success'><span
                                    class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                                <#if message.type = 'warning'><span class="govuk-warning-text__icon" aria-hidden="true">!</span></#if>
                                <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                                <strong class="govuk-warning-text__text" id="warning-message">
                                    <span class="govuk-warning-text__assistive">Warning</span>
                                    ${message.summary}
                                </strong>
                            </div>
                        </#if>
                    </#if>
                    <#-- End TDR Error Messages -->
                    <#if displayHeading>
                        <h1 class="govuk-heading-l">
                            <#if message?has_content && message.summary = msg("alreadyLoggedInMessage")>
                                ${loggedInPageTitle}
                            <#else>
                                <#if properties.blockSharedPages = 'true'>
                                    ${pageTitle}
                                <#else>
                                    <#-- Display AYR Warning Text -->
                                    <div class="govuk-warning-text">
                                    <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
                                    <strong class="govuk-warning-text__text">
                                        <span class="govuk-visually-hidden">Warning</span>
                                        Do not share your sign in details with anyone else.
                                    </strong>
                                    </div>
                                    ${pageTitle}
                                </#if>
                            </#if>
                        </h1>
                    </#if>
                    <#nested "form">
                </div>
            </div>
        </main>
    </div>
    <#-- End TDR Content -->

    <#-- Start TDR Template footer -->
    <footer class="govuk-footer " role="contentinfo">
        <div class="govuk-width-container ">
            <div class="govuk-footer__meta">
                <div class="govuk-footer__meta-item govuk-footer__meta-item--grow">

                    <h2 class="govuk-visually-hidden">Support links</h2>
                    <ul class="govuk-footer__inline-list">
                        <li class="govuk-footer__inline-list-item">
                            <a class="govuk-footer__link" href="${properties.tdrHomeUrl}/contact">
                                Contact
                            </a>
                        </li>
                        <li class="govuk-footer__inline-list-item">
                            <a class="govuk-footer__link" href="${properties.tdrHomeUrl}/cookies">
                                Cookies
                            </a>
                        </li>
                    </ul>

                    <svg role="presentation" focusable="false" class="govuk-footer__licence-logo"
                         xmlns="http://www.w3.org/2000/svg" viewbox="0 0 483.2 195.7" height="17" width="41">
                        <path fill="currentColor"
                              d="M421.5 142.8V.1l-50.7 32.3v161.1h112.4v-50.7zm-122.3-9.6A47.12 47.12 0 0 1 221 97.8c0-26 21.1-47.1 47.1-47.1 16.7 0 31.4 8.7 39.7 21.8l42.7-27.2A97.63 97.63 0 0 0 268.1 0c-36.5 0-68.3 20.1-85.1 49.7A98 98 0 0 0 97.8 0C43.9 0 0 43.9 0 97.8s43.9 97.8 97.8 97.8c36.5 0 68.3-20.1 85.1-49.7a97.76 97.76 0 0 0 149.6 25.4l19.4 22.2h3v-87.8h-80l24.3 27.5zM97.8 145c-26 0-47.1-21.1-47.1-47.1s21.1-47.1 47.1-47.1 47.2 21 47.2 47S123.8 145 97.8 145"/>
                    </svg>
                    <span class="govuk-footer__licence-description">
                                All content is available under the
                                <a class="govuk-footer__link"
                                   href="https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/"
                                   rel="license">Open Government Licence v3.0</a>, except where otherwise stated
                            </span>
                </div>
                <div class="govuk-footer__meta-item">
                    <a class="govuk-footer__link govuk-footer__copyright-logo"
                       href="https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/">©
                        Crown copyright</a>
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

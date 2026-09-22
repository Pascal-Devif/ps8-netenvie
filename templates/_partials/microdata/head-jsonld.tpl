{**
 * Copyright since 2007 PrestaShop SA and Contributors
 * PrestaShop is an International Registered Trademark & Property of PrestaShop SA
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.md.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to https://devdocs.prestashop.com/ for more information.
 *
 * @author    PrestaShop SA and Contributors <contact@prestashop.com>
 * @copyright Since 2007 PrestaShop SA and Contributors
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 *}
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name" : "{$shop.name|escape:'javascript':'UTF-8'}",
    "url" : "{$urls.pages.index|escape:'javascript':'UTF-8'}"
    {if $shop.logo_details}
     ,"logo": {
        "@type": "ImageObject",
        "url":"{$shop.logo_details.src|escape:'javascript':'UTF-8'}"
      }
    {/if}
    {if $shop.email}
     ,"email": "{$shop.email|escape:'javascript':'UTF-8'}"
    {/if}
    {if $shop.address.address1 || $shop.address.city || $shop.address.postcode}
     ,"address": {
        "@type": "PostalAddress"
        {if $shop.address.address1}
          ,"streetAddress": "{$shop.address.address1|escape:'javascript':'UTF-8'}"
        {/if}
        {if $shop.address.postcode}
          ,"postalCode": "{$shop.address.postcode|escape:'javascript':'UTF-8'}"
        {/if}
        {if $shop.address.city}
          ,"addressLocality": "{$shop.address.city|escape:'javascript':'UTF-8'}"
        {/if}
        {if $shop.address.state}
          ,"addressRegion": "{$shop.address.state|escape:'javascript':'UTF-8'}"
        {/if}
        {if $shop.address.country}
          ,"addressCountry": "{$shop.address.country|escape:'javascript':'UTF-8'}"
        {/if}
      }
    {/if}
    {if $shop.phone}
     ,"contactPoint": [{
        "@type": "ContactPoint",
        "telephone": "{$shop.phone|escape:'javascript':'UTF-8'}",
        "contactType": "customer service"
      }]
    {/if}
  }
</script>

<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebPage",
    "isPartOf": {
      "@type": "WebSite",
      "url":  "{$urls.pages.index}",
      "name": "{$shop.name}"
    },
    "name": "{$page.meta.title}",
    "url":  "{$urls.current_url}"
  }
</script>

{if $page.page_name == 'index'}
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      "url" : "{$urls.pages.index}",
      {if $shop.logo_details}
        "image": {
          "@type": "ImageObject",
          "url":"{$shop.logo_details.src}"
        },
      {/if}
      "potentialAction": {
        "@type": "SearchAction",
        "target": "{'--search_term_string--'|str_replace:'{search_term_string}':$link->getPageLink('search',true,null,['search_query'=>'--search_term_string--'])}",
        "query-input": "required name=search_term_string"
      }
    }
  </script>
{/if}

{if isset($breadcrumb.links[1])}
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [
        {foreach from=$breadcrumb.links item=path name=breadcrumb}
          {
            "@type": "ListItem",
            "position": {$smarty.foreach.breadcrumb.iteration},
            "name": "{$path.title}",
            "item": "{$path.url}"
          }{if !$smarty.foreach.breadcrumb.last},{/if}
        {/foreach}
      ]
    }
  </script>
{/if}

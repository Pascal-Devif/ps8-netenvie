{**
 * Global JSON-LD: Organization, WebPage, WebSite, BreadcrumbList.
 *}
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": {$shop.name|json_encode nofilter},
    "url": {$urls.pages.index|json_encode nofilter}
    {if $shop.logo_details}
    ,"logo": {
      "@type": "ImageObject",
      "url": {$shop.logo_details.src|json_encode nofilter}
    }
    {/if}
    {if $shop.email}
    ,"email": {$shop.email|json_encode nofilter}
    {/if}
    {if $shop.address.address1 || $shop.address.city || $shop.address.postcode}
    ,"address": {
      "@type": "PostalAddress"
      {if $shop.address.address1}
      ,"streetAddress": {$shop.address.address1|json_encode nofilter}
      {/if}
      {if $shop.address.postcode}
      ,"postalCode": {$shop.address.postcode|json_encode nofilter}
      {/if}
      {if $shop.address.city}
      ,"addressLocality": {$shop.address.city|json_encode nofilter}
      {/if}
      {if $shop.address.state}
      ,"addressRegion": {$shop.address.state|json_encode nofilter}
      {/if}
      {if $shop.address.country}
      ,"addressCountry": {$shop.address.country|json_encode nofilter}
      {/if}
    }
    {/if}
    {if $shop.phone}
    ,"contactPoint": [{
      "@type": "ContactPoint",
      "telephone": {$shop.phone|json_encode nofilter},
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
      "url": {$urls.pages.index|json_encode nofilter},
      "name": {$shop.name|json_encode nofilter}
    },
    "name": {$page.meta.title|json_encode nofilter},
    "url": {$urls.current_url|json_encode nofilter}
  }
</script>

{if $page.page_name == 'index'}
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "url": {$urls.pages.index|json_encode nofilter},
    {if $shop.logo_details}
    "image": {
      "@type": "ImageObject",
      "url": {$shop.logo_details.src|json_encode nofilter}
    },
    {/if}
    "potentialAction": {
      "@type": "SearchAction",
      "target": {{'--search_term_string--'|str_replace:'{search_term_string}':$link->getPageLink('search',true,null,['search_query'=>'--search_term_string--'])}|json_encode nofilter},
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
        "name": {$path.title|json_encode nofilter},
        "item": {$path.url|json_encode nofilter}
      }{if !$smarty.foreach.breadcrumb.last},{/if}
      {/foreach}
    ]
  }
</script>
{/if}

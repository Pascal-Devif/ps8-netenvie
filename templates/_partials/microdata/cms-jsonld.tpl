{assign var='cms_article_headline' value=$cms.meta_title|default:$page.meta.title}
{assign var='cms_article_description' value=$page.meta.description|default:$cms.meta_description|default:''}
{if !$cms_article_description && isset($cms.content) && $cms.content}
  {assign var='cms_article_description' value=$cms.content|strip_tags|regex_replace:'/\s+/':' '|trim|truncate:160:'...':true}
{/if}
{assign var='cms_article_url' value=$page.canonical|default:$urls.current_url}
{assign var='cms_article_image' value=''}

{if isset($cms_jsonld_image) && $cms_jsonld_image}
  {assign var='cms_article_image' value=$cms_jsonld_image}
{elseif isset($cms.content) && $cms.content|strstr:'/img/cms/'}
  {assign var='cms_article_image' value=$cms.content|regex_replace:'#^[\s\S]*?((?:https?:)?(?://[^"\'>\s]+)?/img/cms/[^"\'>\s]+\.(?:webp|jpg|jpeg|png|gif))[\s\S]*$#iu':'$1'}
  {if !$cms_article_image|strstr:'/img/cms/'}
    {assign var='cms_article_image' value=''}
  {/if}
{/if}

{if $cms_article_image && $cms_article_image|substr:0:2 == '//'}
  {assign var='cms_article_image' value="https:{$cms_article_image}"}
{elseif $cms_article_image && $cms_article_image|substr:0:1 == '/'}
  {assign var='cms_article_image' value="{$urls.shop_domain_url}{$cms_article_image}"}
{/if}

{assign var='cms_article_lang' value=$language.locale|default:'fr-FR'}
{if isset($cms_jsonld_date_published) && $cms_jsonld_date_published}
  {assign var='cms_date_published' value=$cms_jsonld_date_published}
{else}
  {assign var='cms_date_published' value=''}
{/if}
{if isset($cms_jsonld_date_modified) && $cms_jsonld_date_modified}
  {assign var='cms_date_modified' value=$cms_jsonld_date_modified}
{else}
  {assign var='cms_date_modified' value=$cms_date_published}
{/if}

{if isset($shop.logo_details.src) && $shop.logo_details.src}
  {assign var='cms_publisher_logo' value=$shop.logo_details.src}
{else}
  {assign var='cms_publisher_logo' value=$shop.logo}
{/if}

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": {$cms_article_headline|json_encode nofilter},
  "description": {$cms_article_description|regex_replace:"/[\r\n]/" : " "|json_encode nofilter},
  {if $cms_article_image}
  "image": {$cms_article_image|json_encode nofilter},
  {/if}
  {if $cms_date_published}
  "datePublished": {$cms_date_published|json_encode nofilter},
  {/if}
  {if $cms_date_modified}
  "dateModified": {$cms_date_modified|json_encode nofilter},
  {/if}
  "inLanguage": {$cms_article_lang|json_encode nofilter},
  "author": {
    "@type": "Organization",
    "name": {$shop.name|json_encode nofilter},
    "url": {$urls.pages.index|json_encode nofilter}
  },
  "publisher": {
    "@type": "Organization",
    "name": {$shop.name|json_encode nofilter},
    "logo": {
      "@type": "ImageObject",
      "url": {$cms_publisher_logo|json_encode nofilter}
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": {$cms_article_url|json_encode nofilter}
  }
}
</script>

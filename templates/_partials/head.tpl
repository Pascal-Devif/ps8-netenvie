{**
 * 2007-2017 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.txt.
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
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2017 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
 
{block name='head_font'}
  {include file="_partials/font-pre.tpl"}
{/block}
{block name='head_charset'}
  <meta charset="utf-8">
{/block}
{block name='head_ie_compatibility'}
  <meta http-equiv="x-ua-compatible" content="ie=edge">
{/block}

{block name='head_seo'}
  <title>{block name='head_seo_title'}{$page.meta.title}{/block}</title>
  {hook h="displayAfterTitleTag"}
  <meta name="description" content="{block name='head_seo_description'}{$page.meta.description}{/block}">
  <meta name="keywords" content="{block name='head_seo_keywords'}{$page.meta.keywords}{/block}">
  {if $page.meta.robots !== 'index'}
    <meta name="robots" content="{$page.meta.robots}">
  {/if}
    {* if listing is sort or with facet *}
  {if ($page.meta.robots === 'index' && isset($smarty.get.order)) || ($page.meta.robots === 'index' && isset($smarty.get.q))}
    <meta name="robots" content="none">
  {/if}

  {if isset($preloads)}
      {foreach from=$preloads item=preload}
         <link rel="preload" fetchpriority="high" as="image" href="{$preload}" />
      {/foreach}
  {/if}

  {block name='head_font'}
    {include file="_partials/font-load.tpl"}
  {/block}
  
  {if $page.page_name == 'product'}
    <link rel="canonical" href="{$product.canonical_url}">
  {elseif $page.canonical}
    <link rel="canonical" href="{$page.canonical}">
  {/if}
  {block name='head_hreflang'}
      {if isset($urls.alternative_langs) && $urls.alternative_langs|count > 1}
      {foreach from=$urls.alternative_langs item=pageUrl key=code}
        <link rel="alternate" href="{$pageUrl}" hreflang="{$code}">
      {/foreach}
      {/if}
  {/block}

  {block name='head_microdata'}
    {include file='_partials/microdata/head-jsonld.tpl'}
  {/block}

  {block name='head_microdata_special'}{/block}

  {block name='head_pagination_seo'}
    {include file='_partials/pagination-seo.tpl'}
  {/block}

  {block name='head_open_graph'}
    <meta property="og:title" content="{$page.meta.title}">
    <meta property="og:description" content="{$page.meta.description}">
    <meta property="og:url" content="{$urls.current_url}">
    <meta property="og:site_name" content="{$shop.name}">
    {if !isset($product) && $page.page_name != 'product'}
      <meta property="og:type" content="website">
    {/if}
    {if $page.page_name === 'category' && isset($category) && isset($category.image) && isset($category.image.large) && $category.image.large.url}
      <meta property="og:image" content="{$category.image.large.url}">
    {elseif $page.page_name != 'product'}
      <meta property="og:image" content="{$shop.logo}">
    {/if}
  {/block}

{/block}

{block name='head_viewport'}
  <meta name="viewport" content="width=device-width, initial-scale=1">
{/block}

{block name='head_icons'}
  <link rel="icon" type="image/vnd.microsoft.icon" href="{$shop.favicon}?{$shop.favicon_update_time}">
  <link rel="shortcut icon" type="image/x-icon" href="{$shop.favicon}?{$shop.favicon_update_time}">
{/block}

{block name='stylesheets'}
  {include file="_partials/stylesheets.tpl" stylesheets=$stylesheets}
{/block}

{block name='javascript_head'}
  {include file="_partials/javascript.tpl" javascript=$javascript.head vars=$js_custom_vars}
{/block}

{block name='hook_header'}
  {$HOOK_HEADER nofilter}
{/block}

{block name='hook_extra'}{/block}

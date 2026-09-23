<?php

use PrestaShop\PrestaShop\Core\Util\File\YamlParser;

class CmsControllerTheme extends CmsControllerCore
{
    /** @var array */
    public $themeSettings = [];

    /** @var array */
    public $overrideSettings = [];

    public function init()
    {
        parent::init();

        // Must run AFTER parent::init(): FrontControllerTheme overwrites $this->overrideSettings
        // with class_front_controller settings.
        $configurationCacheDirectory = (new Configuration())->get('_PS_CACHE_DIR_');
        $yamlParser = new YamlParser($configurationCacheDirectory);
        $this->themeSettings = $yamlParser->parse(_PS_THEME_DIR_ . '/config/theme.yml');
        $this->overrideSettings = $this->themeSettings['override_settings']['controller_cms'] ?? [];
    }

    public function initContent()
    {
        $res = parent::initContent();

        if (!empty($this->overrideSettings['remove_init_content_override'])) {
            return $res;
        }

        if ($this->assignCase !== self::CMS_CASE_PAGE || !Validate::isLoadedObject($this->cms)) {
            return $res;
        }

        if (!empty($this->overrideSettings['init_content_override_cms_jsonld'])) {
            $this->assignCmsJsonLdVars();
        }

        return $res;
    }

    /**
     * Assign image + dates used by templates/_partials/microdata/cms-jsonld.tpl.
     */
    protected function assignCmsJsonLdVars()
    {
        $image = $this->extractCmsImage($this->cms->content);
        $dates = $this->resolveCmsDates($image);

        $this->context->smarty->assign([
            'cms_jsonld_image' => $image,
            'cms_jsonld_date_published' => $dates['published'],
            'cms_jsonld_date_modified' => $dates['modified'],
        ]);
    }

    /**
     * @param string|null $content
     *
     * @return string|null
     */
    protected function extractCmsImage($content)
    {
        if (!is_string($content) || $content === '') {
            return null;
        }

        if (!preg_match(
            '#(?:src)=["\']((?:https?:)?(?://[^"\']+)?/img/cms/[^"\']+\.(?:webp|jpg|jpeg|png|gif))["\']#iu',
            $content,
            $matches
        )) {
            return null;
        }

        $image = $matches[1];
        if (strpos($image, '//') === 0) {
            $image = 'https:' . $image;
        } elseif (isset($image[0]) && $image[0] === '/') {
            $image = Tools::getShopDomainSsl(true) . $image;
        }

        return $image;
    }

    /**
     * CMS has no date columns: use CMS image filemtime when available.
     *
     * @param string|null $imageUrl
     *
     * @return array{published: string|null, modified: string|null}
     */
    protected function resolveCmsDates($imageUrl)
    {
        $result = ['published' => null, 'modified' => null];
        if (!$imageUrl) {
            return $result;
        }

        $path = parse_url($imageUrl, PHP_URL_PATH);
        if (!$path) {
            return $result;
        }

        $localPath = _PS_ROOT_DIR_ . $path;
        if (!is_file($localPath)) {
            $basename = basename($path);
            $fallback = _PS_IMG_DIR_ . 'cms/' . $basename;
            if (is_file($fallback)) {
                $localPath = $fallback;
            } else {
                return $result;
            }
        }

        $timestamp = @filemtime($localPath);
        if (!$timestamp) {
            return $result;
        }

        try {
            $date = new DateTime('@' . $timestamp);
            $date->setTimezone(new DateTimeZone('Europe/Paris'));
            $date->setTime(9, 0, 0);
            $formatted = $date->format('Y-m-d\TH:i:sP');
            $result['published'] = $formatted;
            $result['modified'] = $formatted;
        } catch (Exception $e) {
            return $result;
        }

        return $result;
    }
}

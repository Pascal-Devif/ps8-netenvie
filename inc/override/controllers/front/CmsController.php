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
     * Assign image + dates
     */
    protected function assignCmsJsonLdVars()
    {
        $this->ensureCmsDateColumns();

        $image = $this->extractCmsImage($this->cms->content);
        $dates = $this->resolveCmsDates();

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
     * @return array{published: string|null, modified: string|null}
     */
    protected function resolveCmsDates()
    {
        $published = $this->formatCmsDate($this->cms->date_add ?? null);
        $modified = $this->formatCmsDate($this->cms->date_upd ?? null);

        if (!$modified) {
            $modified = $published;
        }

        return [
            'published' => $published,
            'modified' => $modified,
        ];
    }

    protected function ensureCmsDateColumns()
    {
        if (Configuration::get('PS8_NETENVIE_CMS_DATES')) {
            return;
        }

        $db = Db::getInstance();
        $table = _DB_PREFIX_ . 'cms';
        $columns = $db->executeS('SHOW COLUMNS FROM `' . bqSQL($table) . '`');
        $existing = [];
        if (is_array($columns)) {
            foreach ($columns as $column) {
                $existing[$column['Field']] = true;
            }
        }

        if (!isset($existing['date_add'])) {
            $db->execute('ALTER TABLE `' . bqSQL($table) . '` ADD `date_add` DATETIME NULL DEFAULT NULL');
        }
        if (!isset($existing['date_upd'])) {
            $db->execute('ALTER TABLE `' . bqSQL($table) . '` ADD `date_upd` DATETIME NULL DEFAULT NULL');
        }

        Configuration::updateValue('PS8_NETENVIE_CMS_DATES', 1);
    }

    /**
     * @param string|null $mysqlDate
     *
     * @return string|null
     */
    protected function formatCmsDate($mysqlDate)
    {
        if (!$mysqlDate || $mysqlDate === '0000-00-00 00:00:00') {
            return null;
        }

        try {
            $date = new DateTime($mysqlDate, new DateTimeZone('Europe/Paris'));

            return $date->format('Y-m-d\TH:i:sP');
        } catch (Exception $e) {
            return null;
        }
    }
}

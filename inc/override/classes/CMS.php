<?php

class CMSTheme extends CMSCore
{
    /** @var string */
    public $date_add;

    /** @var string */
    public $date_upd;

    public function __construct($id = null, $id_lang = null, $id_shop = null, $translator = null)
    {
        self::$definition['fields']['date_add'] = ['type' => self::TYPE_DATE, 'validate' => 'isDate'];
        self::$definition['fields']['date_upd'] = ['type' => self::TYPE_DATE, 'validate' => 'isDate'];

        parent::__construct($id, $id_lang, $id_shop, $translator);
    }

    /**
     * Ensure date_add is set on first real update of legacy CMS rows.
     *
     * {@inheritdoc}
     */
    public function update($nullValues = false)
    {
        if (empty($this->date_add) || $this->date_add === '0000-00-00 00:00:00') {
            $this->date_add = date('Y-m-d H:i:s');
        }

        return parent::update($nullValues);
    }
}

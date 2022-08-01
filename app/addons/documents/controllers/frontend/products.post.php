<?php
/***************************************************************************
 *                                                                          *
 *   (c) 2004 Vladimir V. Kalynyak, Alexey V. Vinokurov, Ilya M. Shalnev    *
 *                                                                          *
 * This  is  commercial  software,  only  users  who have purchased a valid *
 * license  and  accept  to the terms of the  License Agreement can install *
 * and use this program.                                                    *
 *                                                                          *
 ****************************************************************************
 * PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
 * "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
 ****************************************************************************/


use Tygh\Registry;
use Tygh\Tygh;

if ($mode == 'documents'){
    Tygh::$app['session']['continue_url'] = "products.documents";  
    $params = $_REQUEST;
    $params['user_id'] = Tygh::$app['session']['auth']['user_id'];    
    list($documents, $search) = fn_get_documents();
    print_r($documents);
    Tygh::$app['view']->assign('documents', $documents);
    Tygh::$app['view']->assign('search', $search);
}elseif ($mode == 'document') {
    $document_data = [];
    $document_id = !empty($_REQUEST['document_id']) ? $_REQUEST['document_id'] : 0;    
    $document_data = fn_get_document_data($document_id);
    if (empty($document_data)) {
        return [CONTROLLER_STATUS_NO_PAGE];
    }   

    Tygh::$app['view']->assign('document_data', $document_data);

    fn_add_breadcrumb(["document", $document_data['document']]);
    $params = $_REQUEST;
    $params['extend'] = ['description'];
    $params['item_ids'] = !empty($document_data['worker_ids']) ? implode(',',$document_data['worker_ids']) : -1;

    if ($items_per_page = fn_change_session_param(Tygh::$app['session']['search_params'], $_REQUEST, 'items_per_page')) {
        $params['items_per_page'] = $items_per_page;
    }

    if ($sort_by = fn_change_session_param(Tygh::$app['session']['search_params'], $_REQUEST, 'sort_by')) {
        $params['sort_by'] = $sort_by;
    }

    if ($sort_order = fn_change_session_param(Tygh::$app['session']['search_params'], $_REQUEST, 'sort_order')) {
        $params['sort_order'] = $sort_order;
    }

    list($products, $search) = fn_get_products($params, Registry::get('settings.Appearance.products_per_page'));

    fn_gather_additional_products_data($products, [
        'get_icon'      => true,
        'get_detailed'  => true,
        'get_options'   => true,
        'get_discounts' => true,
        'get_features'  => false
    ]);

    $selected_layout = fn_get_products_layout($_REQUEST);

    Tygh::$app['view']->assign('products', $products);
    Tygh::$app['view']->assign('search', $search);
    Tygh::$app['view']->assign('selected_layout', $selected_layout);
}
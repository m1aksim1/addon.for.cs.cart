<?php
use Tygh\Registry;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $suffix = '';

    if($mode == 'update_document'){
        $document_id = !empty($_REQUEST['document_id']) ? $_REQUEST['document_id'] : 0;
        $data = !empty($_REQUEST['document_data']) ? $_REQUEST['document_data'] : [];
        $document_id = fn_update_document($data, $document_id);
        if(!empty($document_id)){
            $suffix = ".update_document?document_id={$document_id}";  
        }else{
            $suffix = ".add_document";  
        }
        
    } else if($mode == 'delete_document'){ 
        $document_id = !empty($_REQUEST['document_id']) ? $_REQUEST['document_id'] : 0;
        fn_delete_document($document_id);
        $suffix = ".manage_documents";
    }   
}


elseif($mode == 'add_document' || $mode == 'update_document'){
    $document_id = !empty($_REQUEST['document_id']) ? $_REQUEST['document_id'] : 0;    
    $document_data = fn_get_document_data($document_id);
    
    if (empty($document_data) && $mode == 'update') {
        return [CONTROLLER_STATUS_NO_PAGE];
    }

    Tygh::$app['view']->assign([
        'document_data' => $document_data,
        'u_info' => !empty($document_data['user_id']) ?fn_get_user_short_info($document_data['user_id']) : [], 
    ]);

} elseif($mode == 'manage_documents'){
    list($documents, $search) = fn_get_documents($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));
    Tygh::$app['view']->assign('documents', $documents);
    Tygh::$app['view']->assign('search', $search);

}
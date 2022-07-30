<?php 
function fn_get_documents($params = [], $items_per_page = 0){
    $default_params = array(
        'page' => 1,
        'items_per_page' => $items_per_page
    );
    $params = array_merge($default_params, $params);
    $sortings = array(
        'timestamp' => '?:documents.timestamp',
        'name' => '?:documents.name',
        'status' => '?:documents.status',
    );
    $condition = $limit = $join = '';

    if (!empty($params['limit'])) {
        $limit = db_quote(' LIMIT 0, ?i', $params['limit']);
    }
    $sorting = db_sort($params, $sortings, 'name', 'asc');

    if (!empty($params['usergroup_ids'])) {
        $condition .= db_quote(' AND ?:documents.document_id IN (?n)', explode(',', $params['usergroup_ids']));
    }
    if (!empty($params['document_id'])) {
        $condition .= db_quote(' AND ?:documents.document_id = ?i ', $params['document_id'] );
        }
        if (!empty($params['user_id'])) {
        $condition .= db_quote(' AND ?:documents.document_id = ?i ', $params['user_id'] );
    }  
    
    if (!empty($params['status'])) {
        $condition .= db_quote(' AND ?:documents.status = ?s', $params['status']);
    }

    $fields = array (
        '?:documents.*',
        '?:documents_availability.usergroup_id',
        '?:documents_availability.available_since',
    );

    $join .= db_quote(' LEFT JOIN ?:documents_availability ON ?:documents_availability.document_id = ?:documents.document_id ');         

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:documents $join WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $documents = db_get_hash_array(
        "SELECT ?p FROM ?:documents " .
        $join .
        "WHERE 1 ?p ?p ?p",
        'document_id', implode(', ', $fields), $condition, $sorting, $limit
    );
    foreach ($documents as $document_id => $document){
        $u_info = fn_get_user_info($document['user_id'],false);
        $documents[$document_id]['user_info'] = $u_info;
    }
    return array($documents, $params);
}

function fn_get_document_data($document_id = 0)
{
    $document = [];
    if(!empty($document_id)){
        list($documents) = fn_get_documents([
            'document_id' => $document_id   
        ], 1);
        
        if(!empty($documents)){
            $document = reset($documents);
            $document['usergroup_ids'] = fn_document_get_availability($document['document_id']);
        }
        $document['usergroup_ids'] = implode(',', $document['usergroup_ids']);
        $document['image_pairs'] = fn_get_image_pairs($document_id, 'document', 'A', true, true);
        $document['main_pair'] = fn_get_image_pairs($document_id, 'document', 'M', true, true);
   }
   return $document;
}

function fn_update_document($data, $document_id)
{
    if (isset($data['timestamp'])) {
        $data['timestamp'] = fn_parse_date($data['timestamp']);
    }
    if (isset($data['available_since'])) {
        $available_since = $data['available_since'] = fn_parse_date($data['available_since']);
    }
    
    if (!empty($document_id)) {
        db_query("UPDATE ?:documents SET ?u WHERE document_id = ?i", $data, $document_id);
        
    } else {
        $document_id = $data['document_id'] = db_replace_into('documents', $data);
    }
    $usergroup_ids = !empty($data['usergroup_ids']) ? $data['usergroup_ids'] : [];
    
    if (!empty($document_id)) {
        fn_attach_image_pairs('document_main', 'document', $document_id);

        // Update additional images
        fn_attach_image_pairs('document_additional', 'document', $document_id);

        // Add new additional images
        fn_attach_image_pairs('document_add_additional', 'document', $document_id);

        if (isset($data['removed_image_pair_ids'])) {
            $data['removed_image_pair_ids'] = array_filter($data['removed_image_pair_ids']);
        }
        
        if (!empty($data['removed_image_pair_ids'])) {
            fn_delete_image_pairs($document_id, 'document', '', $data['removed_image_pair_ids']);
        }
    }

    fn_document_delete_availability($document_id);
    fn_document_add_availability($document_id,  $usergroup_ids, $available_since);   
    return $document_id;    
}

function fn_delete_document($document_id)
{   
   if (!empty($document_id)) {
       db_query("DELETE FROM ?:documents WHERE document_id = ?i", $document_id);
   }
}

function fn_document_delete_availability($document_id){
    db_query("DELETE FROM ?:documents_availability WHERE document_id = ?i", $document_id);
 }
 
 function fn_document_add_availability($document_id, $usergroup_ids,$available_since){
    if(!empty($usergroup_ids)){
        foreach($usergroup_ids as $usergroup_id){
            db_query("REPLACE INTO `?:documents_availability` ?e",  [
                'usergroup_id' => $usergroup_id,
                'document_id' => $document_id,
                'available_since' => $available_since,
            ]);
        }
    }
 }

 function fn_document_get_availability($document_id){
    return !empty($document_id) ? db_get_fields('SELECT usergroup_id FROM `?:documents_availability` WHERE `document_id` = ?i', $document_id) : [];

 }
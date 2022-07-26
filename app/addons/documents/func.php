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
    );

    if (!empty($params['items_per_page'])) {
        $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:documents WHERE 1 $condition");
        $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
    }

    $documents = db_get_hash_array(
        "SELECT ?p FROM ?:documents " .
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
       }
   }
   return $document;
}

function fn_update_document($data, $document_id)
{
    if (isset($data['timestamp'])) {
        $data['timestamp'] = fn_parse_date($data['timestamp']);
    }

    if (!empty($document_id)) {
        db_query("UPDATE ?:documents SET ?u WHERE document_id = ?i", $data, $document_id);
        
    } else {
        $document_id = $data['document_id'] = db_replace_into('documents', $data);
    }
    return $document_id;    
}

function fn_delete_document($document_id)
{   
   if (!empty($document_id)) {
       db_query("DELETE FROM ?:documents WHERE document_id = ?i", $document_id);
   }
}
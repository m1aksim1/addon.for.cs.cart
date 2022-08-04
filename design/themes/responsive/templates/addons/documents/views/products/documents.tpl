{capture name="section"}
    {include file="addons/documents/views/products/components/orders_search_form.tpl"}
{/capture}
{include file="common/section.tpl" section_title=__("search_options") section_content=$smarty.capture.section class="ty-search-form" collapse=true}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
{if $search.sort_order == "asc"}
    {include_ext file="common/icon.tpl" class="ty-icon-down-dir" assign=sort_sign}
{else}
    {include_ext file="common/icon.tpl" class="ty-icon-up-dir" assign=sort_sign}
{/if}
{if !$config.tweaks.disable_dhtml}
    {assign var="ajax_class" value="cm-ajax"}
{/if}

{include file="common/pagination.tpl"}  

<table class="ty-table ty-orders-search">
    <thead
        data-ca-bulkedit-default-object="true"
        data-ca-bulkedit-component="defaultObject"
    >   
        <tr>
            <th width="15%"><a class="cm-ajax" href="{"`$c_url`&sort_by=timestamp&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("creation_date")}{if $search.sort_by === "timestamp"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>
            <th><a class="cm-ajax" href="{"`$c_url`&sort_by=name&sort_order=`$search.sort_order_rev`"|fn_url}" data-ca-target-id={$rev}>{__("name")}{if $search.sort_by === "name"}{$c_icon nofilter}{else}{$c_dummy nofilter}{/if}</a></th>            
            <th width="10%">{__("type")}</th>
            <th width="10%">{__("file")}</th>
            <th width="10%">{__("status")}</th>
            <th width="10%">{__("author")}</th>
        </tr>
    </thead>
    {foreach from=$documents item=document}
        {if $document.usergroup_ids == null}
            {$document.usergroup_ids.0 = 0}
        {/if}
        {if ($smarty.const.TIME > $document.available_since) and ($document.status == "A") and (($document.type == "I" and $user_info.user_id == 1) or ($document.type == "G"))}
        {foreach from=$document.usergroup_ids item=$usergroup}
            {if (($usergroup == 0 or $usergroup == null) or ($usergroup == 1 and $user_info.user_id == null) or ($usergroup == 2 and $user_info.user_id != null) or ($user_info.user_id == 1))}
                <tr>
                    <td width="15%" data-th="{__("creation_date")}">
                        {$document.timestamp|date_format:"`$settings.Appearance.date_format`"}
                    </td>
                    <td class="{$no_hide_input}" data-th="{__("name")}">
                        <a class="row-status" href="{"products.document?document_id=`$document.document_id`"|fn_url}">{$document.name}</a>
                    </td>   
                    
                    <td class="{$no_hide_input}" data-th="{__("type")}">
                        {if $document.type == "I"}{__("internal")}{/if}
                        {if $document.type == "G"}{__("general")}{/if}
                    </td>  
                    <td class="{$no_hide_input}" data-th="{__("file")}">
                        {$document.count_documents}
                    </td>
                    <td class="{$no_hide_input}" data-th="{__("status")}">
                        {$document.status}
                    </td>
                    <td class="{$no_hide_input}" data-th="{__("author")}">
                        {$document.author}
                    </td>
                </tr>
                {break}
            {/if}
            
        {/foreach}
        {/if}
    {/foreach}
</table>
    {if $document_data}
        {assign var="id" value=$document_data.document_id}  
    {else}
        {assign var="id" value=0}
    {/if}
    {capture name="mainbox"}
        <form action="{""|fn_url}" method="post" class="form-horizontal form-edit" name="banners_form" enctype="multipart/form-data">
            <input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
            <input type="hidden" class="cm-no-hide-input" name="document_id" value="{$id}" />
            <div id="content_general">
                <div class="control-group">
                    <label for="elm_banner_name" class="control-label cm-required">{__("name")}</label>
                    <div class="controls">
                        <input type="text" name="document_data[name]" id="elm_banner_name" value="{$document_data.name}" size="25" class="input-large" />
                    </div>
                </div>  

                <div class="control-group">
                    <label for="elm_banner_name" class="control-label">{__("category")}</label>
                    <div class="controls">
                        <input type="text" name="document_data[category]" id="elm_banner_name" value="{$document_data.category}" size="25" class="input-large" />
                    </div>
                </div>

                <div class="control-group" id="banner_text">
                    <label class="control-label" for="elm_banner_description">{__("description")}:</label>
                    <div class="controls">
                        <textarea id="elm_banner_description" name="document_data[description]" cols="35" rows="8" class="input-large">{$document_data.description}</textarea>
                    </div>
                </div>

                <div class="control-group">
                    <label for="elm_banner_name" class="control-label">{__("type")}</label>
                    <div class="controls">
                        <input type="text" name="document_data[type]" id="elm_banner_name" value="{$document_data.type}" size="25" class="input-large" />
                    </div>
                </div>  
        
                <div class="control-group">
                    <label class="control-label" for="elm_banner_timestamp_{$id}">{__("creation_date")}</label>
                    <div class="controls">
                        {include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="document_data[timestamp]" date_val=$document_data.timestamp|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="elm_banner_timestamp_{$id}">{__("status")}</label>
                    <div class="controls">
                        <select name="document_data[status]">
                            <option value="A">{__("active")}</option>
                            <option value="H">{__("hidden")}</option>
                            <option value="D">{__("disabled")}</option>
                        </select>
                    </div>
                </div>
                    
                <div class="control-group">
                    <label for="elm_banner_name" class="control-label">{__("author")}</label>
                    <div class="controls">
                        <input type="text" name="document_data[author]" id="elm_banner_name" value="{$user_info.email}" size="25" class="input-large" />
                    </div>
                </div>  
                
            <!--content_general--></div>

            <div id="content_addons" class="hidden clearfix">
                {hook name="banners:detailed_content"}
                {/hook}
            <!--content_addons--></div>

            {capture name="buttons"}
                {if !$id}
                    {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="banners_form" but_name="dispatch[products.update_document]"}
                {else}
                    {include file="buttons/save_cancel.tpl" but_name="dispatch[products.update_document]" but_role="submit-link" but_target_form="banners_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
                    {capture name="tools_list"}
                        <li>{btn type="list" text=__("delete") class="cm-confirm" href="products.delete_document?document_id=`$id`" method="POST"}</li>
                    {/capture}
                    {dropdown content=$smarty.capture.tools_list}
                {/if}
            {/capture}
        </form>
    {/capture}

    {include file="common/mainbox.tpl"
        title=($id) ? $document_data.document: "add new document"
        content=$smarty.capture.mainbox
        buttons=$smarty.capture.buttons
        select_languages=true}

    {** banner section **}
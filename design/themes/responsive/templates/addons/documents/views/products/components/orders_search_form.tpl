<form action="{""|fn_url}" class="ty-orders-search-options" name="orders_search_form" method="get">

<div class="clearfix">
    <div class="span3 ty-control-group">
        <label class="ty-control-group__title">{__("name")}</label>
        <input type="text" name="name" value="{$search.name}" size="10" class="ty-search-form__input" />
    </div>
    <div class="span3 ty-control-group">
        <label class="ty-control-group__title">{__("file")}</label>
        <input type="text" name="document_id" value="{$search.document_id}" size="10" lass="ty-search-form__input"c />
    </div>

    {include file="common/period_selector.tpl" period=$search.period form_name="orders_search_form"}

    <div class="span2 ty-control-group">
        <label class="control-label" for="elm_banner_timestamp_{$id}">{__("type")}</label>
        <select name="type" id="tag_status_identifier" class="ty-search-form__input">
            <option value="I"{if $search.type == "I"} selected="selected"{/if}>{__("internal")}</option>
            <option value="G"{if $search.type == "G"} selected="selected"{/if}>{__("general")}</option>
        </select>
    </div>
</div>
<hr>
<div class="clearfix">
    <div class="span4 ty-control-group">
        {include 
            file="pickers/categories/picker.tpl" 
            but_text=_("add category") 
            data_id="return_users" 
            but_meta="btn" 
            input_name="category" 
            item_ids=$search.category                        
            display = "checkbox"
            view_mode ="mixed"
        }
    </div>
    <div class="span4 ty-control-group">
        <label for="elm_banner_name" class="control-label">{__("author")}</label>
        <div class="controls">
            <input type="text" name="author" id="elm_banner_name" value="{$search.author}" size="25" class="input-large" />
        </div>
    </div>  
    <div class="span4 ty-control-group">
        <label for="tag_status_identifier">{__("status")}</label>
        <select name="status" id="tag_status_identifier">
            <option value="">{__("all")}</option>
            <option value="A"{if $search.status == "A"} selected="selected"{/if}>{__("active")}</option>
            <option value="D"{if $search.status == "D"} selected="selected"{/if}>{__("disabled")}</option>
            <option value="H"{if $search.status == "H"} selected="selected"{/if}>{__("hidden")}</option>
        </select>
    </div>
    <div class="span4 ty-control-group">
        <label class="control-label" for="elm_banner_timestamp_{$id}">{__("usergroups")}</label>
        <select name="status" id="tag_status_identifier">
            <option value="">{__("all")}</option>
            <option value="D"{if $search.usergroups == "1"} selected="selected"{/if}>{__("guest")}</option>
            <option value="H"{if $search.usergroups == "2"} selected="selected"{/if}>{__("registered")}</option>
        </select>
    </div>   
</div>





<div class="buttons-container ty-search-form__buttons-container">
    {include file="buttons/button.tpl" but_meta="ty-btn__secondary" but_text=__("storefront_search_button") but_name="dispatch[orders.search]"}
</div>
</form>
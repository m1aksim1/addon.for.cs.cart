<div class="sidebar-row">
<h6>{__("search")}</h6>
<form action="{""|fn_url}" name="tags_search_form" method="get">
    {capture name="simple_search"}
    <div class="sidebar-field">
        <label for="elm_tag">{__("name")}</label>
        <input type="text" id="elm_tag" name="name" size="20" value="{$search.name}" onfocus="this.select();" class="input-text" />
    </div>
    <div class="sidebar-field">
        <label for="elm_tag">{__("category")}</label>
        {include 
            file="pickers/categories/picker.tpl" 
            but_text=_("add category") 
            data_id="return_users" 
            but_meta="btn" 
            input_name="category" 
            item_ids=$search.category                        
            placement="left"
            display = "checkbox"
            view_mode ="mixed"
        }
    </div>
    <div class="sidebar-field">
        <label class="control-label" for="elm_banner_timestamp_{$id}">{__("creation_date")}</label>
        <div class="controls">
            {include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="timestamp" date_val=$search.timestamp|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
        </div>
    </div>
    
    <div class="sidebar-field">
        <label class="control-label" for="elm_banner_timestamp_{$id}">{__("available_since")}</label>
        <div class="controls">
            {include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="available_since" date_val=$search.available_since|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
        </div>
    </div>
    <div class="sidebar-field">
        <label class="control-label" for="elm_banner_timestamp_{$id}">{__("type")}</label>
            <select name="type" id="tag_status_identifier">
                <option value="I"{if $search.type == "I"} selected="selected"{/if}>{__("internal")}</option>
                <option value="G"{if $search.type == "G"} selected="selected"{/if}>{__("general")}</option>
            </select>
    </div>
    <div class="sidebar-field">
        <label class="control-label" for="elm_banner_timestamp_{$id}">{__("usergroups")}</label>
        <div class="controls">
            {include file="common/select_usergroups.tpl" id="ug_id" name="usergroup_ids" usergroups=["type"=>"C", "status"=>["A", "H"]]|fn_get_usergroups:$smarty.const.DESCR_SL usergroup_ids=$search.usergroup_ids input_extra="" list_mode=true}
        </div>
    </div>
    
    <div class="sidebar-field">
        <label class="control-label">{__("file name")}:</label>
        
    </div>
        
    <div class="sidebar-field">
        <label for="elm_banner_name" class="control-label">{__("author")}</label>
        <div class="controls">
            <input type="text" name="author" id="elm_banner_name" value="{$search.author}" size="25" class="input-large" />
        </div>
    </div>  
    <div class="sidebar-field">
        <label for="tag_status_identifier">{__("status")}</label>
        <select name="status" id="tag_status_identifier">
            <option value="">{__("all")}</option>
            <option value="A"{if $search.status == "A"} selected="selected"{/if}>{__("active")}</option>
            <option value="D"{if $search.status == "D"} selected="selected"{/if}>{__("disabled")}</option>
            <option value="H"{if $search.status == "H"} selected="selected"{/if}>{__("hidden")}</option>
        </select>
    </div>
    {/capture}

    {include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search dispatch=$dispatch view_type="tags"}

    </form>
</div>
<div class="ty-feature">
    <div class="ty-feature__description ty-wysiwyg-content">
        <b>{__("name")}:</b> 
        <br>
        {$document_data.name}
        <br>
    </div>
    <b>{__("description")}:</b> 
    <br>
    {$document_data.description}
    <br>
<b>{__("documents")}:</b> 
</div>
{hook name="products:layout_content"}
    {include 
    file="addons/documents/views/products/components/product_images.tpl"
	product=$document_data
    image_width=200px
    image_height=200px
    thumbnails_size = 50
    }
{/hook}

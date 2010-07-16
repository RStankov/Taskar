module SectionsHelper
  def new_section_link(before = nil)
    before = before.id.to_s if before
    
    content_tag(:li, :class => "add_section", :"data-before" => before) do
      link_to("&nbsp;", new_project_section_path(@project, :before => before))
    end
  end
end
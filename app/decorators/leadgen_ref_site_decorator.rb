class LeadgenRefSiteDecorator < Draper::Decorator
  delegate_all

  def admin_contet_wysiwyg_config
    {
      data: {
        options: {
          toolbarButtons: ['undo', 'redo', 'bold', 'italic', 'underline', 'color', 'insertLink','fontFamily', 'fontSize', 'paragraphFormat', 'align', 'formatOL', 'formatUL', 'outdent', 'indent', 'quote'],
          quickInsertButtons: ['table', 'ul', 'ol', 'hr']
        }
      }
    }
  end
end
